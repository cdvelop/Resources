#!/bin/bash
# secure-postgres.sh
# Restringe PostgreSQL a loopback — aplica el fix tanto en instalación nativa
# como en contenedores Docker que tengan el puerto 5432 expuesto en 0.0.0.0.
#
# Uso:
#   sudo bash secure-postgres.sh          # fix nativo + Docker
#   sudo bash secure-postgres.sh --native # solo instalación nativa
#   sudo bash secure-postgres.sh --docker # solo contenedores Docker

set -euo pipefail

MODE="${1:-all}"

ok()  { echo -e "\e[32m✓\e[0m $*"; }
warn(){ echo -e "\e[33m!\e[0m $*"; }
err() { echo -e "\e[31m✗\e[0m $*"; exit 1; }

# ─── NATIVO ──────────────────────────────────────────────────────────────────

fix_native() {
    [[ ! -d /etc/postgresql ]] && return

    local conf=""
    for candidate in /etc/postgresql/*/main/postgresql.conf; do
        [[ -f "$candidate" ]] && conf="$candidate" && break
    done
    [[ -z "$conf" ]] && return

    ok "Native PostgreSQL found: $conf"
    cp "$conf" "${conf}.bak.$(date +%Y%m%d%H%M%S)"

    if grep -qE "^\s*listen_addresses" "$conf"; then
        sed -i "s|^\s*listen_addresses\s*=.*|listen_addresses = 'localhost'|" "$conf"
    else
        echo "listen_addresses = 'localhost'" >> "$conf"
    fi

    systemctl is-active --quiet postgresql && systemctl restart postgresql
    ok "listen_addresses restricted to localhost"
}

# ─── DOCKER ──────────────────────────────────────────────────────────────────

fix_docker() {
    command -v docker &>/dev/null || return

    local containers
    containers=$(docker ps --format "{{.Names}}\t{{.Ports}}" 2>/dev/null \
        | grep "0\.0\.0\.0:5432" | awk '{print $1}')

    [[ -z "$containers" ]] && return

    for name in $containers; do
        local image restart volumes env_vars
        image=$(docker inspect "$name" --format '{{.Config.Image}}')
        restart=$(docker inspect "$name" --format '{{.HostConfig.RestartPolicy.Name}}')
        volumes=$(docker inspect "$name" --format '{{range .Mounts}}-v {{.Source}}:{{.Destination}} {{end}}')
        env_vars=$(docker inspect "$name" --format '{{range .Config.Env}}-e {{.}} {{end}}' \
            | grep -o '\-e POSTGRES_[^=]*=[^ ]*' | tr '\n' ' ' || true)

        warn "$name: port 5432 is open to all network interfaces (0.0.0.0)"
        echo ""
        echo "  Fix: stop the container, delete it, and start it again"
        echo "  with port 5432 restricted to localhost only."
        echo "  Your database data is safe — it lives in the volume, not the container."
        echo ""

        read -r -p "  Apply fix to $name now? [y/N] " resp
        if [[ "${resp,,}" == "y" ]]; then
            docker stop "$name" && docker rm "$name"
            # shellcheck disable=SC2086
            docker run --name "$name" --restart "$restart" \
                $env_vars -p 127.0.0.1:5432:5432 $volumes -d "$image"
            ok "$name restarted — port 5432 now restricted to localhost"
        else
            warn "Skipped. To apply manually:"
            echo "  docker stop $name && docker rm $name"
            # shellcheck disable=SC2086
            echo "  docker run --name $name --restart $restart $env_vars-p 127.0.0.1:5432:5432 ${volumes}-d $image"
        fi
    done
}

# ─── VERIFICACIÓN FINAL ───────────────────────────────────────────────────────

verify() {
    echo ""
    if ss -tlnp | grep -q "0\.0\.0\.0:5432"; then
        warn "5432 still exposed on 0.0.0.0 — check manually"
    else
        ok "5432 is not exposed on 0.0.0.0"
    fi
}

# ─── MAIN ─────────────────────────────────────────────────────────────────────

[[ $EUID -ne 0 ]] && err "Ejecutar como root: sudo bash $0"

case "$MODE" in
    --native) fix_native ;;
    --docker) fix_docker ;;
    all|*)    fix_native; fix_docker ;;
esac

verify
