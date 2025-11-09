# Inicio de Sesión Automático en Windows

Para configurar el inicio de sesión automático en Windows, el primer paso es ejecutar `netplwiz`.

1.  Presiona `Win + R` para abrir el cuadro de diálogo **Ejecutar**.
2.  Escribe `netplwiz` y presiona **Enter**.
3.  Busca la casilla **"Los usuarios deben escribir su nombre y contraseña para usar el equipo"**.

---

## Solución si la casilla de verificación no aparece

Si la casilla mencionada no está visible, puedes restaurarla siguiendo estos pasos:

1.  **Abrir CMD como Administrador**:
    Busca "Símbolo del sistema" o "cmd" en el menú de inicio, haz clic derecho y selecciona **"Ejecutar como administrador"**.

2.  **Ejecutar el comando de registro**:
    Copia y pega el siguiente comando en la ventana de CMD y presiona **Enter**. Este comando modifica el registro para forzar la aparición de la casilla.
    ```cmd
    reg ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v DevicePasswordLessBuildVersion /t REG_DWORD /d 0 /f
    ```

3.  **Reiniciar el equipo**:
    Para que los cambios surtan efecto, es necesario reiniciar la computadora.

Una vez reiniciado, la casilla debería estar habilitada en la ventana de `netplwiz`, permitiéndote desactivar el requerimiento de contraseña al iniciar sesión.

---

**Fuente:** [Fix "Users must enter a user name and password..." Checkbox Missing in Windows 10](https://www.askvg.com/fix-users-must-enter-a-user-name-and-password-to-use-this-computer-checkbox-missing-in-windows-10/)
