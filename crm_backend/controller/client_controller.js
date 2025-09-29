const ClientService = require('../services/client_services');

exports.addOrUpdateContact = async (req, res) => {
    try{
     const { email,second_email,name, adress,identity,phones,website,other_info,type } = req.body;
     const contact = await ClientService.existContact(email);
        if(!contact){
            // Create new contact ya babaaaaaaaa
             const newContact = await ClientService.addContact( { email,second_email,name, adress,identity,phones,website,other_info,type } );
               res.status(201).json({
      status: true,
      success: " $type added successfully",
    });
        }

    }catch(err){    console.error("Contact error:", err);
    res.status(500).json({ status: false, message: "Internal server error" });}
}