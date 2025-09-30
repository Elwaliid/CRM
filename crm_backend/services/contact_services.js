const ContactModel = require('../models/contact_model');
const jwt = require('jsonwebtoken');


class ContactService {
 static async existContact(id) {
        try {
            return await ContactModel.findById(id);
        } catch (err) {
            throw err;
        }
    }
     static async addContact(email,secondEmail,name, address,identity,phones,website,other_info,type ) {
            try {
                const addContact = new ContactModel({email,secondEmail,name,address,identity,phones,website,notes: other_info,type });
                return await addContact.save();
            } catch (err) {
                throw err;
            }
        }
            static async updateContact(id,email,secondEmail,name, address,identity,phones,website,other_info,type ) {
                try{
                    const contact = await ContactModel.findById(id);
                    if(!contact) throw new Error('Contact not found');
                    contact.email = email;
                    contact.secondEmail = secondEmail;
                    contact.name = name;
                    contact.address = address;
                    contact.identity = identity;
                    contact.phones = phones;
                    contact.website = website;
                    contact.notes = other_info;
                    contact.type = type;
                    await contact.save();
                    return contact;
                }catch (err) {  throw err;}
            }

    static async getContacts() {
        try {
            return await ContactModel.find();
        } catch (err) {
            throw err;
        }
    }
    static async deleteIt(id) {
        try{
            return await ContactModel.findByIdAndDelete(id);
        }catch (err) {  throw err;}
    }

}
module.exports = ContactService;