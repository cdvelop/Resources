
## comando para agregar clave llave ssh y no vuelva a pedirla
ssh-add

## en caso de error: "Could not open a connection to your authentication agent."
exec ssh-agent bash
## después ya puedes probar nuevamente


### Si lo ha intentado ssh-add y aún se le solicita que ingrese su frase de contraseña, intente usar ssh-add -K. Esto agrega su frase de contraseña a su llavero.