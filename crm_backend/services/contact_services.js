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
     static async addContact(owner,email,secondEmail,name, address,identity,phones,website,other_info,type,isPined ) {
            try {
                const addContact = new ContactModel({owner,email,secondEmail,name,address,identity,phones,website,notes: other_info,type,isPined });
                return await addContact.save();
            } catch (err) {
                throw err;
            }
        }
            static async updateContact(id,email,secondEmail,name, address,identity,phones,website,other_info,type,isPined ) {
                try{
                    const contact = await ContactModel.findById(id);
                    if(!contact) throw new Error('Contact not found');
                    if (email !== undefined) contact.email = email;
                    if (secondEmail !== undefined) contact.secondEmail = secondEmail;
                    if (name !== undefined) contact.name = name;
                    if (address !== undefined) contact.address = address;
                    if (identity !== undefined) contact.identity = identity;
                    if (phones !== undefined) contact.phones = phones;
                    if (website !== undefined) contact.website = website;
                    if (other_info !== undefined) contact.notes = other_info;
                    if (type !== undefined) contact.type = type;
                    if (isPined !== undefined) contact.isPined = isPined;
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

    static async getClientsCountToday() {
        try {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            return await ContactModel.countDocuments({
                type: 'Client',
                createdAt: { $gte: today, $lt: tomorrow }
            });
        } catch (err) {
            throw err;
        }
    }

    static async getClientsCountByMonth(year, month) {
        try {
            const daysInMonth = new Date(year, month, 0).getDate();
            const dailyCounts = [];
            for (let day = 1; day <= daysInMonth; day++) {
                const dayStart = new Date(year, month - 1, day);
                const dayEnd = new Date(year, month - 1, day + 1);
                const count = await ContactModel.countDocuments({
                    type: 'Client',
                    createdAt: { $gte: dayStart, $lt: dayEnd }
                });
                dailyCounts.push(count);
            }
            return dailyCounts;
        } catch (err) {
            throw err;
        }
    }

}
module.exports = ContactService;
