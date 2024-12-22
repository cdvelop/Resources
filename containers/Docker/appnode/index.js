import express from 'express'
import mongoose from 'mongoose'

const Animal = mongoose.model('Animal', new mongoose.Schema({
    tipo: String,
    estado: String,
}))

const app = express()

// para conectar a un container con mongo debemos ir https://hub.docker.com/_/mongo
// para ver las variables de entorno
//db connect ej: <db_engine>://<user>:<password>@<host>:<port>/<database>?authSource<user_type>
// mongoose.connect('mongodb://cesar:123@monguito:27017/miapp')
mongoose.connect('mongodb://cesar:123@monguito:27017/miapp?authSource=admin')

// endpoint /
app.get('/', async (_req, res) => {
    console.log('listando... chanchitos...')
    const animales = await Animal.find();
    return res.send(animales)
})

// endpoint /crear
app.get('/crear', async (_req, res) => {
    console.log('creando...chanchitos')
    await Animal.create({ tipo: 'Chanchito', estado: 'Feliz' })
    return res.send('ok')
})

app.listen(3000, () => console.log('listening...'))