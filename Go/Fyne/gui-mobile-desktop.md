# para diferenciar si la app es de tipo mobile o desktop ej:
```go
    a := app.New()

	if a.Driver().Device().IsMobile() {
		fmt.Println("mobile")
	} else {
		fmt.Println("desktop")
	}

// para probar con -tags mobile
```