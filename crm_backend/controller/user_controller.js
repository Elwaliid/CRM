const UserService = require('../services/user_services');


exports.register = async (req, res,next) => {
    try{
        const { email, password } = req.body;

        const newUser = await UserService.registerUser(email, password);

         let tokenData = { _id: newUser._id, email: newUser.email };
    const token = await UserService.generateToken(tokenData, "secretKey", "300h");

    res.status(201).json({
      status: true,
      success: "User registered successfully",
      token: token,  // 🔑 include the token in response
    });
  } catch (err) {
    console.error("Register error:", err);
    res.status(500).json({ status: false, message: "Internal server error" });
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

exports.googleSignin = async (req, res, next) => {
    try {
        const { email, name, googleId } = req.body;

        // Validate required fields
        if (!email || !name || !googleId) {
            return res.status(400).json({
                status: false,
                message: "Missing required fields: email, name, and googleId are required"
            });
        }

        console.log('Processing Google Sign-In for:', email);

        // Check if user exists
        let user = await UserService.findOrCreateGoogleUser(email, name, googleId);

        // Generate JWT token
        let tokenData = { _id: user._id, email: user.email };
        const token = await UserService.generateToken(tokenData, "secretKey", "300h");

        console.log('Google Sign-In successful for:', email);

        res.status(200).json({
            status: true,
            token: token,
            user: {
                _id: user._id,
                email: user.email,
                name: user.name,
                authProvider: user.authProvider
            }
        });
    } catch (err) {
        console.error("Google Sign-In error:", err);
        res.status(500).json({
            status: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? err.message : undefined
        });
    }
}






