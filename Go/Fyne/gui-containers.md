# contenedores

```go
func (h *handler) guiSplit() fyne.CanvasObject {
	content := container.NewHSplit(
		container.NewVBox(h.formLeftContent()),
		container.NewScroll(h.Console.scroll),
	)

	content.Offset = 0.3

	return content
}

```
