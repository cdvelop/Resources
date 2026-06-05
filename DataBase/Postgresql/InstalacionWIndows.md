# Pasos  instalacion Postgres 9.5 en Windows

## Paso 1 
  descargar postgres desde https://www.enterprisedb.com/download-postgresql-binaries
  ![version a descragar](pg_pasos/01-version.png)

## Paso 2  
 ![directorio de trabajo](pg_pasos/02-directorio.png)

## Paso 3 inicar postgres

1. Crear el clúster de datos:

```powershell
.\bin\initdb.exe -D data -U postgres -W -E UTF8
```
![salida esperada](pg_pasos/03-inicio.png)


2. Iniciar el servidor:

```powershell
.\bin\pg_ctl.exe -D data -l logfile start
```

3. Verificar que está funcionando:

```powershell
.\bin\pg_isready.exe
```

4. Conectarse:

```powershell
.\bin\psql.exe -U postgres
```

o

```powershell
.\bin\psql.exe -h localhost -U postgres
```

### Verifica la versión

También conviene revisar qué versión descargaste:

```powershell
.\bin\postgres.exe --version
```

y compartir la salida. Algunas versiones recientes cambiaron opciones de autenticación y podría indicarte exactamente cuál es la sintaxis correcta para tu versión específica.
