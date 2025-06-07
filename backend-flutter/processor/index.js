import express from 'express';
import { Worker } from 'worker_threads';
import axios from 'axios';

const app = express();
app.use(express.json());

app.post('/process', (req, res) => {
  const tx = req.body;

  const worker = new Worker('./worker.js', {
    workerData: tx
  });

  worker.on('message', async (result) => {
    console.log('✅ Procesado:', result);

    try {
      await axios.post('http://notifier:4002/notify', {
        userId: result.userId,
        message: result.message
      });
      console.log('🔔 Notificación enviada al notificador');
    } catch (err) {
      console.error('❌ Error al notificar:', err.message);
    }

    res.json({ status: 'completado', resultado: result });
  });

  worker.on('error', (err) => {
    console.error('❌ Worker error:', err);
    res.status(500).json({ error: 'Error interno del procesador' });
  });
});

app.listen(4001, () => {
  console.log('🧠 Processor en puerto 4001');
});
