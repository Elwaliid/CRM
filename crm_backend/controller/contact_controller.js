const ContactService = require('../services/contact_services');

exports.addOrUpdateContact = async (req, res) => {
    try{
     const {email,second_email,name, address,identity,phones,website,other_info,type } = req.body;
     const contact = await ContactService.existContact(email);
        if(!contact){
            // Create new contact ya babaaaaaaaa
             const newContact = await ContactService.addContact( email,second_email,name, address,identity,phones,website,other_info,type  );
               res.status(201).json({
      status: true,
      message: " $type added successfully",
    });
        }else{
            // Update existing contact biismallah 3alik
            await ContactService.updateContact(email,second_email,name, address,identity,phones,website,other_info,type );
            res.status(200).json({ status: true, message: "Contact updated successfully" });
        }

    }catch(err){    console.error("Contact error:", err);
    res.status(500).json({ status: false, message: "Internal server error" });}
}
