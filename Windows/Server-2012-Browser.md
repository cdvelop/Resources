estoy en windows server 2012 el cual trae internet explorer necesito instalar otro navegador como edge o chorme pero no deja descargar archivos por porblemas de seguridad ..donde se confgura internet explorer para que permita descargar?


En **Windows Server 2012** esto ocurre casi siempre por **Internet Explorer Enhanced Security Configuration (IE ESC)**.
Esa configuración bloquea descargas, scripts y muchos sitios por seguridad.

### 1️⃣ Desactivar *Internet Explorer Enhanced Security Configuration*

1. Abre **Server Manager**.
2. En el panel izquierdo haz clic en **Local Server**.
3. Busca la opción:

**Internet Explorer Enhanced Security Configuration**

4. Haz clic en **On**.

5. Cambia a **Off** para:

   * **Administrators**
   * **Users**

6. Acepta.

Después de esto **Internet Explorer permitirá descargas normalmente**.

---

### 2️⃣ Si aún bloquea la descarga

Haz esto dentro de **Internet Explorer**:

1. Presiona **Alt** para mostrar el menú.
2. Ve a **Tools → Internet Options**.
3. Pestaña **Security**.
4. Selecciona **Internet**.
5. Haz clic en **Custom Level**.
6. Busca la opción:

**Downloads → File Download**

7. Ponla en **Enable**.

---

### 3️⃣ Alternativa rápida (muy usada en servidores)

Si solo quieres descargar **Chrome o Edge**:

1. En IE abre:

   ```
   https://www.google.com/chrome
   ```

   o

   ```
   https://www.microsoft.com/edge
   ```

2. Cuando salga el aviso de seguridad selecciona **Add** o **Allow**.

---

💡 **Recomendación:**
Instala **Chrome o Edge lo antes posible**, porque **Internet Explorer en Server 2012 está totalmente obsoleto y muchos sitios ya no funcionan bien.**

