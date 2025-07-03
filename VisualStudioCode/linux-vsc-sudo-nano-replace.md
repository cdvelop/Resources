Para abrir VS Code como superusuario de forma segura, usa este comando:

```bash
sudo code --no-sandbox --user-data-dir=/tmp/vsc-root /etc/libvirt/qemu.conf
```

Esto evita problemas de permisos y sandbox. Así podrás editar el archivo cómodamente. 