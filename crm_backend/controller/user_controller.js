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
         const token = await UserService.generateToken(tokenData,"secretKey","300h");
         res.status(200).json({
            status: true,
            token: token,
        });
    }catch(err){
        throw err;
    }
}

exports.googleLogin = async (req, res, next) => {
  try {
    const { idToken } = req.body; // from Flutter GoogleSignIn
    const user = await UserService.loginWithGoogle(idToken);
    res.json({ status: true, user, token: user.token });
  } catch (err) {
    next(err);
  }
};

exports.appleLogin = async (req, res, next) => {
  try {
    const { idToken } = req.body; // from Flutter SignInWithApple
    const user = await UserService.loginWithApple(idToken);
    res.json({ status: true, user, token: user.token });
  } catch (err) {
    next(err);
  }
};
