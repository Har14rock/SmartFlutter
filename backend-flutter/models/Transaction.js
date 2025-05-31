const mongoose = require('mongoose');

const TransactionSchema = new mongoose.Schema({
  title: String,
  description: String,
  amount: Number,
  type: { type: String, enum: ['ingreso', 'gasto'] },
  category: String,
  imageUrl: String,
  date: Date,
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
});

module.exports = mongoose.model('Transaction', TransactionSchema);
