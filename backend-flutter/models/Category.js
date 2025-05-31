const mongoose = require('mongoose');

const CategorySchema = new mongoose.Schema({
  name: String,
  color: String,
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
});

module.exports = mongoose.model('Category', CategorySchema);
