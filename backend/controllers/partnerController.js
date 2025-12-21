import Partner from '../models/Partner.js';

/**
 * Handle new partner application submission
 * POST /api/partners
 */
export const createPartner = async (req, res) => {
    try {
        const { fullName, email, phone, city, partnerType, location, locationOwnership } = req.body;

        // 1. Validate all required fields
        if (!fullName || !email || !phone || !city || !partnerType || !location || !locationOwnership) {
            return res.status(400).json({
                error: 'Missing required fields. Please provide all information.'
            });
        }

        // 2. Map camelCase request fields to snake_case PostgreSQL columns via Sequelize model
        // 3. Insert a new record into the partners table
        // 4. Set status = 'PENDING' and created_at handled by model/DB
        const newPartner = await Partner.create({
            fullName,
            email,
            phone,
            city,
            partnerType,
            location,
            locationOwnership,
            status: 'PENDING'
        });

        // 7. Return a JSON success response
        return res.status(201).json({
            message: 'Partner application submitted successfully!',
            partnerId: newPartner.id
        });

    } catch (error) {
        console.error('Error in createPartner:', error);

        // Handle unique constraint violation (e.g., duplicate email)
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(409).json({
                error: 'An application with this email already exists.'
            });
        }

        return res.status(500).json({
            error: 'Internal server error. Please try again later.'
        });
    }
};
