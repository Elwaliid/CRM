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

app.listen(port,  ()=>{
    console.log(`server on port http://localhost:${port}`);
   
})
