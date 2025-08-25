const UserService = require('../services/user_services');


exports.register = async (req, res,next) => {
    try{
        const { email, password } = req.body;

        const successRes = await UserService.registerUser(email, password);

        res.json({status: "true", success: "User registered successfully" })
    }catch(err){
        console.error('Login error:', err);
        res.status(500).json({ status: false, message: 'Internal server error' });
    }
}
exports.login = async (req, res,next) => {
    try{
        const { email, password } = req.body;

        const user = await UserService.loginUser(email);
      if(!user){
        return res.status(400).json({ status: false, message: "Wrong email" });
        }
        const isMatch = await user.comparePassword(password);

        if(!isMatch){
              return res.status(400).json({ status: false, message: "Invalid password" });
        }

         let tokenData =  {_id: user._id, email: user.email};
         const token = await UserService.generateToken(tokenData,"secretKey","1h");
         res.status(200).json({
            status: true,
            token: token,
        });
    }catch(err){
        throw err;
    }
}