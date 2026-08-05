# Resetear contraseña de administrador — Windows 10 LTSC

Notas propias. Caso: máquina propia, olvidé la contraseña del usuario
`Administrador` (habilitado). Además existe un usuario creado como `User` y
**renombrado a `Dental1`**, pero cuya **carpeta de perfil sigue siendo `C:\Users\User`**
(renombrar el usuario no renombra la carpeta — importante para no confundirse).

**No hace falta descargar herramienta.** Sirve cualquiera de estas dos que ya
tengo en `ISOS/`:

- `Windows_10_LTSC_Enterprise_x86FRE_es-es.iso` → método del **truco utilman/cmd**
- `WinPE11_..._Sergei_Strelec_....iso` → trae editores de contraseña con interfaz

---

## Comprobar ANTES: nombre real de la cuenta y BitLocker

- El nombre para iniciar sesión es el **nombre de cuenta** (`Administrador`,
  `Dental1`), no el de la carpeta.
- **BitLocker:** si la unidad `C:` está cifrada, ningún método offline funciona sin
  la clave de recuperación. LTSC normalmente **no** lo activa solo, pero
  compruébalo. Si al montar `C:` desde WinPE pide clave, es BitLocker → necesitas
  la clave de 48 dígitos (cuenta Microsoft / AD / impresa) antes de seguir.

---

## Método A — Truco utilman (con el USB de instalación de Windows) — recomendado

No instala ni descarga nada. Sustituye temporalmente la herramienta de
accesibilidad de la pantalla de login por un `cmd` con permisos SYSTEM.

### A.1 Arrancar y abrir consola

1. Arranca desde el USB de instalación de Windows 10 (modo UEFI, sin CSM).
2. En la primera pantalla del instalador pulsa **Shift + F10** → se abre `cmd`.
3. Localiza la letra de la unidad del sistema (en WinPE la `C:` del instalador no
   suele ser la de Windows):
   ```
   diskpart
   list volume
   exit
   ```
   Busca el volumen grande con Windows. Supongamos que es `D:`.

### A.2 Cambiar utilman por cmd

```
D:
cd Windows\System32
ren utilman.exe utilman.exe.bak
copy cmd.exe utilman.exe
```

Cierra todo y reinicia (`wpeutil reboot` o simplemente quita el USB y reinicia)
para arrancar Windows normal.

### A.3 En la pantalla de login

1. Pulsa el icono de **Accesibilidad** (abajo a la derecha). En vez de las
   opciones de accesibilidad se abre un **`cmd` como SYSTEM**.
2. Restablece la contraseña (sin saber la anterior):
   ```
   net user Administrador NuevaClave123
   ```
   Para el otro usuario, usa su **nombre de cuenta real** (`Dental1`):
   ```
   net user Dental1 OtraClave123
   ```
   Si no recuerdas el nombre exacto, lista las cuentas:
   ```
   net user
   ```
3. Inicia sesión con la clave nueva.

### A.4 Deshacer el cambio (IMPORTANTE)

Dejar `cmd` como `utilman` es un agujero de seguridad. Revierte:

- Vuelve a arrancar el USB → **Shift + F10** → :
  ```
  D:
  cd Windows\System32
  del utilman.exe
  ren utilman.exe.bak utilman.exe
  ```

> Variante equivalente: en vez de `utilman.exe` se puede usar `sethc.exe` (se
> dispara pulsando **Shift 5 veces** en el login). Mismo principio, mismo deshacer.

---

## Método B — Sergei Strelec WinPE (con interfaz gráfica)

Si prefieres no tocar la línea de comandos:

1. Arranca la ISO de Strelec (modo UEFI).
2. Menú **Passwords / Windows Login** → hay varias:
   - **Windows Login Unlocker** — lista las cuentas y permite blanquear la
     contraseña o desbloquear la cuenta con un botón.
   - **NT Password Edit / Reset Windows Password** — editor del `SAM` offline.
3. Selecciona la instalación de Windows (elige la partición correcta si hay
   varias), marca la cuenta `Administrador` o `Dental1`, y usa **Reset / Clear
   password** (dejar en blanco) o fijar una nueva.
4. Reinicia a Windows.

Ventaja: no hay que deshacer nada (no modifica `utilman`). Desventaja: editar el
`SAM` directamente; hazlo con la cuenta correcta.

---

## Notas y precauciones

- **No borres la contraseña de una cuenta con datos de EFS cifrados**: perderías
  el acceso a esos archivos. Prefiere *cambiarla* (Método A) antes que *blanquearla*.
  En un equipo con perfiles normales sin EFS, blanquear es seguro.
- Después de entrar, si quieres evitar repetir esto, apunta la clave o crea un
  disco de restablecimiento de contraseña desde el Panel de control.
- Si la máquina está unida a un dominio, la contraseña de cuentas de dominio no se
  resetea así (solo las **locales**); usa las herramientas del dominio.
