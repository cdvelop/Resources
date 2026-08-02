# Escritorio remoto desde Debian hacia un PC Windows (RDP)

## Aclaración importante

La app con el diálogo "Connection details" (placeholder `spice://foo.example.org:5900`) es
**virt-viewer / remote-viewer**, pensada para conectarse a **máquinas virtuales** (KVM/QEMU/oVirt)
vía protocolo **SPICE**. No es la herramienta adecuada para conectarse a un PC Windows físico por RDP.

La opción recomendada, más parecida a la experiencia de "Conexión a Escritorio remoto" de Windows,
es **Remmina**.

## 1. Preparar el PC Windows (equipo destino)

1. Abrir **Configuración → Sistema → Escritorio remoto**.
2. Activar "Habilitar Escritorio remoto".
   - Solo disponible en Windows **Pro / Enterprise / Education**. En Windows Home no existe esta
     opción (alternativa: RustDesk o AnyDesk).
3. Anotar el **nombre del equipo** o la **IP** (`ipconfig` en CMD → "Dirección IPv4").
4. Asegurarse de que el usuario con el que se va a entrar tiene contraseña (RDP no permite cuentas
   sin contraseña).

## 2. Instalar Remmina en Debian

```bash
sudo apt update
sudo apt install remmina remmina-plugin-rdp
```

## 3. Configurar la conexión

1. Abrir **Remmina** desde el menú de aplicaciones.
2. Clic en el botón **"+"** (nueva conexión) arriba a la izquierda.
3. En el desplegable **Protocol**, elegir **RDP - Remote Desktop Protocol**.
4. En **Server**, escribir la IP o nombre del PC Windows (ej: `192.168.1.50`).
5. En **User name**, poner el usuario de Windows (cuenta local: solo el usuario; cuenta de
   dominio: `DOMINIO\usuario`).
6. Escribir la contraseña (opcional guardarla).
7. Clic en **Save and Connect**.

Debería verse y comportarse muy parecido al cliente de Windows: ventana con el escritorio remoto,
redimensionable, con opción de pantalla completa.

## 4. Notas útiles

- Si el PC Windows y la laptop están en la **misma red local**, con la IP local basta.
- Para conectarse **desde fuera de casa**, se necesita VPN o redirección de puertos (por seguridad,
  no exponer el puerto 3389 directo a internet).
- Remmina guarda las conexiones como perfiles: la próxima vez basta con doble clic en el perfil
  guardado.
