import express from 'express';

const app = express();
app.use(express.json());

app.post('/notify', (req, res) => {
  const { userId, message } = req.body;

  console.log(`🔔 Notificación enviada a ${userId}: ${message}`);

  res.json({ status: 'notificado' });
});

app.listen(4002, () => {
  console.log('📣 Notifier corriendo en puerto 4002');
});
