const ContactService = require('../services/contact_services');

exports.addOrUpdateContact = async (req, res) => {
    try{
     const {email,secondEmail,name, address,identity,phones,website,other_info,type } = req.body;
     const contact = await ContactService.existContact(email);
        if(!contact){
            // Create new contact ya babaaaaaaaa
             const newContact = await ContactService.addContact( email,secondEmail,name, address,identity,phones,website,other_info,type  );
               res.status(201).json({
      status: true,
      message: " $type added successfully",
    });
        }else{
            // Update existing contact biismallah 3alik
            await ContactService.updateContact(email,secondEmail,name, address,identity,phones,website,other_info,type );
            res.status(200).json({ status: true, message: "Contact updated successfully" });
        }

    }catch(err){    console.error("Contact error:", err);
    res.status(500).json({ status: false, message: "Internal server error" });}
}

exports.getContacts = async (req, res) => {
    try {
        const contacts = await ContactService.getContacts();
        res.status(200).json({
            status: true,
            contacts: contacts
        });
    } catch (err) {
        console.error("Get contacts error:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
}
