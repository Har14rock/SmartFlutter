const mongoose = require('mongoose');
const eventSchema = new mongoose.Schema({
  name: String,
  description: String,
  imageUrl: String,
  owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
});
module.exports = mongoose.model('Event', eventSchema);
