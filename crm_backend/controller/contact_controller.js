const ContactService = require('../services/contact_services');

exports.addOrUpdateContact = async (req, res) => {
    try{
     const {id,commiter,email,secondEmail,name, address,identity,phones,website,other_info,type } = req.body;
     id? contact = await ContactService.existContact(id): contact = null;
        if(contact == null){
            // Create new contact ya babaaaaaaaa
             const newContact = await ContactService.addContact(email,secondEmail,name, address,identity,phones,website,other_info,type  );
               res.status(201).json({
      status: true,
      message: `${type} added successfully`,
    });
        }else{
            // Update existing contact biismallah 3alik
            await ContactService.updateContact(id,email,secondEmail,name, address,identity,phones,website,other_info,type );
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

exports.deleteContact = async (req, res) => {
    try{
    const { id } = req.body;
    const contact = await ContactService.existContact(id);
    if(!contact){res.status(404).json({ status: false, message: "Contact  not found" }); return;}
    await ContactService.deleteIt(id); 
    res.status(200).json({ status: true, message: "Contact deleted successfully" });
    }catch(err){console.error("Delete contact error:", err);}
}
