const express = require('express');
const router = express.Router();
const Transaction = require('../models/Transaction');
const multer = require('multer');
const path = require('path');

// Configuración de multer para guardar imágenes
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => {
    const name = Date.now() + path.extname(file.originalname);
    cb(null, name);
  }
});
const upload = multer({ storage });

// Obtener transacciones del usuario autenticado
router.get('/', async (req, res) => {
  const userId = req.userId;
  const transactions = await Transaction.find({ userId }).sort({ date: -1 });
  res.json(transactions);
});

// Crear nueva transacción
router.post('/', upload.single('image'), async (req, res) => {
  const { title, description, amount, type, category, date } = req.body;
  const imageUrl = req.file ? 'uploads/' + req.file.filename : '';
  const transaction = new Transaction({
    title,
    description,
    amount,
    type,
    category,
    date,
    imageUrl,
    userId: req.userId,
  });
  await transaction.save();
  res.json({ message: 'Transacción guardada', transaction });
});

module.exports = router;
