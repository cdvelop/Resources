# install google chrome

## paso 1: agregar la llave de gpg

```bash
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg > /dev/null && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list && sudo apt update
```

## paso 2: instalar google chrome

```bash
sudo apt install google-chrome-stable
```

## verificar la version

```bash
google-chrome-stable --version
```
