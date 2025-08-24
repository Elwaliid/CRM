const UserService = require('../services/user_services');


exports.register = async (req, res,next) => {
    try{
        const { email, password } = req.body;

        const successRes = await UserService.registerUser(email, password);

        res.json({status: "true", success: "User registered successfully" })
    }catch(err){
        throw err;
    }
}
exports.login = async (req, res,next) => {
    try{
        const { email, password } = req.body;

        const user =  UserService.loginUser(email);
      if(!user){
            throw newError("wrong email ");
        }
        const isMatch = await user.comparePassword(password);

        if(!isMatch){
              throw newError("password invalid");
        }

         let tokenData =  {_id: user._id, email: user.email};
         const token = await UserService.generateToken(tokenData,"secretKey","1h");
         res.status(200).json({
            status: true,
            token: token,})
    }catch(err){
        throw err;
    }
}