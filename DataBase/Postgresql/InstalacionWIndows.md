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

## 5- ejecutar pg admin 
![pgadmin](pg_pasos/04-pgadmin.png)

## 6- pgadmin3
![06-pgadmin3](pg_pasos/06-pgadmin3.png)

## 7- conexion
![07-conexion](pg_pasos/07-conexion.png)

## 8- formulario 
![08-formulario](pg_pasos/08-formulario.png)

## 9- advertencia
![09-advertencia](pg_pasos/09-advertencia.png)

## 10- finalizacion 
![fin](pg_pasos/10-fin.png)


