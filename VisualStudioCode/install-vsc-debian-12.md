Para **instalar Visual Studio Code en Debian 12** sin tener que descargar e instalar manualmente cada vez, lo ideal es **agregar el repositorio oficial de Microsoft**.
Con eso, VS Code se actualizará automáticamente usando `apt` como cualquier otro paquete del sistema.

Aquí tienes los pasos exactos para Debian 12:

---

# ✅ **Instalar VS Code desde el repositorio oficial (actualizaciones automáticas)**

### **1. Instalar dependencias necesarias**

```bash
sudo apt update
sudo apt install -y wget gpg
```

### **2. Importar la clave GPG de Microsoft**

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
```

### **3. Agregar el repositorio oficial de VS Code**

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
```

### **4. Actualizar e instalar**

```bash
sudo apt update
sudo apt install code
```

---

# 🔄 **Actualizar VS Code en el futuro**

Cuando salga una nueva versión simplemente corres:

```bash
sudo apt update && sudo apt upgrade
```

o esperar a que Debian la aplique automáticamente si tienes actualizaciones automáticas activadas.

---

# 📌 Nota: ¿Quieres la versión “Insiders”?

Si quieres la versión beta (VS Code Insiders):

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code insiders main" | sudo tee /etc/apt/sources.list.d/vscode-insiders.list
sudo apt update
sudo apt install code-insiders
```

---

# 🧼 **¿Tienes instalada la versión manual (.deb)?**

No hay problema, puedes instalar el repo encima, pero si quieres limpiar antes:

```bash
sudo apt remove code
```

---
