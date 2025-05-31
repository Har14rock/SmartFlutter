const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRoutes = require('./routes/auth');
const transactionsRoutes = require('./routes/transactions');
const categoriesRoutes = require('./routes/categories');
const jwt = require('jsonwebtoken');
const app = express();

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// Conectar a MongoDB
mongoose.connect('mongodb://127.0.0.1:27017/smartbudget')
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('Error de conexión MongoDB:', err));

// Middleware para proteger rutas
app.use((req, res, next) => {
  if (req.path.startsWith('/api/auth')) return next();

  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ message: 'No token' });

  try {
    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, 'SECRET_KEY');
    req.userId = decoded.userId;
    next();
  } catch {
    return res.status(401).json({ message: 'Token inválido' });
  }
});

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/transactions', transactionsRoutes);
app.use('/api/categories', categoriesRoutes);

// Iniciar servidor
app.listen(3000, () => {
  console.log('API running on port 3000');
});
