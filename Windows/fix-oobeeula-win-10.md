# Error en OOBE (Ventana Azul)

Al presionar **shift + f2** en la ventana azul de OOBE se produce un error.

## Comandos de CMD

```bash
net user administrador /active:yes
net user /add (usuario) (contraseña)
net localgroup administradores (usuario) /add
cd %windir%\system32\oobe
msoobe.exe
net user administrador /active:no
```

---

**Fuente:**  
[YouTube Video](https://www.youtube.com/watch?v=mhiHRI13uW0)