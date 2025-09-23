const mongoose = require('mongoose');


const connecttion =  mongoose.createConnection('mongodb://127.0.0.1:27017/CRM')
.on('open',()=>{console.log("weeeeee");}).on('error',()=>{console.log("oooooh 3la zbiii")});

module.exports = connecttion;