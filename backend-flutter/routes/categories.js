const express = require('express');
const router = express.Router();
const Category = require('../models/Category');

// Obtener categorías del usuario
router.get('/', async (req, res) => {
  const categories = await Category.find({ userId: req.userId });
  res.json(categories);
});

// Crear nueva categoría
router.post('/', async (req, res) => {
  const { name, color } = req.body;
  const category = new Category({ name, color, userId: req.userId });
  await category.save();
  res.json({ message: 'Categoría creada', category });
});

module.exports = router;
