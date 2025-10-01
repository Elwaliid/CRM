const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const userRouter = require('./routes/user_router');
const contactRouter = require('./routes/contact_router');
 const taskRouter = require('./routes/task_router');

const app = express();

app.use(cors()); // Enable CORS for all origins - for development only
app.use(bodyParser.json());

app.use('/', userRouter);
app.use('/contact', contactRouter);
app.use('/task', taskRouter);
module.exports = app;
