# principales comandos para manejar issues desde la terminal

# crear issue
```bash
gh issue create -R <owner>/<repo> -t "<title>" -b "<body>"
```
## crear issue y asignar etiquetas
```bash
gh issue create -R <owner>/<repo> -t "<title>" -b "<body>" --label <label1,label2>
```
## crear issue y asignar un responsable
```bash
gh issue create -R <owner>/<repo> -t "<title>" -b "<body>" --assignee <assignee1,assignee2>
```
## crear issue y asignar un responsable y etiquetas
```bash
gh issue create -R <owner>/<repo> -t "<title>" -b "<body>" --assignee <assignee1,assignee2> --label <label1,label2>
```
## crear issue y asignar un responsable, etiquetas y fecha de cierre
```bash
gh issue create -R <owner>/<repo> -t "<title>" -b "<body>" --assignee <assignee1,assignee2> --label <label1,label2> --milestone <milestone> --due-date <date>
```

# editar issue
```bash
gh issue edit <issue_number> -R <owner>/<repo> -t "<title>" -b "<body>"
```
## editar issue y asignar etiquetas
```bash
gh issue edit <issue_number> -R <owner>/<repo> -t "<title>" -b "<body>" --label <label1,label2>
```
## editar issue y asignar un responsable
```bash
gh issue edit <issue_number> -R <owner>/<repo> -t "<title>" -b "<body>" --assignee <assignee1,assignee2>
```
## editar issue y asignar un responsable y etiquetas
```bash
gh issue edit <issue_number> -R <owner>/<repo> -t "<title>" -b "<body>" --assignee <assignee1,assignee2> --label <label1,label2>
```
## editar issue y asignar un responsable, etiquetas y fecha de cierre
```bash
gh issue edit <issue_number> -R <owner>/<repo> -t "<title>" -b "<body>" --assignee <assignee1,assignee2> --label <label1,label2> --milestone <milestone> --due-date <date>
```

---

# listar issues
```bash
gh issue list
```
## listar issues de un repositorio especifico
```bash
gh issue list -R <owner>/<repo>
```
## listar issues de un repositorio especifico y filtrar por etiquetas
```bash
gh issue list -R <owner>/<repo> --label <label>
```
## listar issues de un repositorio especifico y filtrar por estado
```bash
gh issue list -R <owner>/<repo> --state <state>
```
## listar issues de un repositorio especifico y filtrar por autor
```bash
gh issue list -R <owner>/<repo> --author <author>
```
## listar issues de un repositorio especifico y filtrar por fecha de creacion
```bash
gh issue list -R <owner>/<repo> --created <date>
```
## listar issues de un repositorio especifico y filtrar por fecha de cierre
```bash
gh issue list -R <owner>/<repo> --closed <date>
```

---

# cerrar issue
```bash
gh issue close <issue_number> -R <owner>/<repo>
```
## cerrar issue y agregar un comentario
```bash
gh issue close <issue_number> -R <owner>/<repo> -c "<comment>"
```
## cerrar issue y agregar un comentario y etiquetas
```bash
gh issue close <issue_number> -R <owner>/<repo> -c "<comment>" --label <label1,label2>
```


---

# estado de los issues

## estado de un issue
```bash
gh issue status <issue_number> -R <owner>/<repo>
```
## estado de todos los issues
```bash
gh issue status -R <owner>/<repo>
```
## ver estado de todos los issues simplemente
```bash
gh issue list --state all
```

## ver solo issues abiertos
```bash
gh issue list --state open
```

## ver solo issues cerrados
```bash
gh issue list --state closed
```
---