const mongoose = require('mongoose');


const connecttion =  mongoose.createConnection('mongodb://127.0.0.1:27017/CRM')
.on('open',()=>{console.log("Mongo connected");}).on('error',()=>{console.log("Mongo connection error")});

module.exports = connecttion;