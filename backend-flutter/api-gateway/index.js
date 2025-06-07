import express from 'express';
import axios from 'axios';

const app = express();
app.use(express.json());

// Este es el punto de entrada público de la app
app.post('/api/transactions', async (req, res) => {
  try {
    // Redirigir al balanceador NGINX, que enviará a algún processor
    const response = await axios.post('http://nginx:80/process', req.body);
    res.json(response.data);
  } catch (error) {
    console.error('❌ Error al enviar al processor:', error.message);
    res.status(500).json({ error: 'Fallo al procesar transacción' });
  }
});

app.listen(4000, () => {
  console.log('🌐 API Gateway corriendo en puerto 4000');
});
