const app = require('./app');
const db = require('./config/db');
const UserModel = require('./models/user_model');
const port = 3000;

app.get('/',(req,res)=>{
    res.send("helloooo")
})
app.get("/api/data",(req,res)=>{
    res.json({success: true, message: "Oumourek Riglou!"})
})

app.listen(port, '0.0.0.0', ()=>{
    console.log(`server on port http://localhost:${port}`);
    console.log(`server also accessible on http://192.168.1.7:${port}`);
})
