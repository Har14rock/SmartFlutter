const mongoose = require('mongoose');
const userSchema = new mongoose.Schema({
  email: { type: String, unique: true },
  password: String, // Hasheada
});
module.exports = mongoose.model('User', userSchema);
