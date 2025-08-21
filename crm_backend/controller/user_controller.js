const UserService = require('../services/user_services');


exports.register = async (req, res,next) => {
    try{
        const { email, password } = req.body;

        const successRes = await UserService.registerUser(email, password);

        res.json({status: true,success:"User registred successfully" })
    }catch(err){
        throw err;
    }
}
exports.login = async (req, res,next) => {
    try{
        const { email, password } = req.body;

     
    }catch(err){
        throw err;
    }
}