const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const userRouter = require('./routes/user_router');

const app = express();

app.use(cors()); // Enable CORS for all origins - for development only
app.use(bodyParser.json());

app.use('/', userRouter);

module.exports = app;
