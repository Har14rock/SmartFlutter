const express = require('express');
const router = express.Router();
const Event = require('../models/Event');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');

// Multer config
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname)),
});
const upload = multer({ storage });

// Middleware para autenticación JWT
function auth(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token' });
  try {
    const decoded = jwt.verify(token, 'SECRET_KEY');
    req.userId = decoded.userId;
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
}

// Obtener eventos
router.get('/', auth, async (req, res) => {
  const events = await Event.find({ owner: req.userId });
  res.json(events);
});

// Crear evento (con imagen)
router.post('/', auth, upload.single('image'), async (req, res) => {
  const { name, description } = req.body;
  const imageUrl = req.file ? `http://localhost:3000/${req.file.path}` : '';
  const event = new Event({ name, description, imageUrl, owner: req.userId });
  await event.save();
  res.json(event);
});

// Actualizar evento
router.put('/:id', auth, async (req, res) => {
  const { name, description } = req.body;
  const event = await Event.findByIdAndUpdate(
    req.params.id, 
    { name, description }, 
    { new: true }
  );
  res.json(event);
});

// Eliminar evento
router.delete('/:id', auth, async (req, res) => {
  await Event.findByIdAndDelete(req.params.id);
  res.json({ message: 'Deleted' });
});

module.exports = router;
