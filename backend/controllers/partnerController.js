import * as partnerService from '../services/partnerService.js';

/**
 * Handle new partner application submission
 * POST /api/partners
 */
export const createPartner = async (req, res) => {
    try {
        const { fullName, email, phone, city, partnerType, location, locationOwnership } = req.body;

        // 1. Controller Checks: Is request valid? Do required fields exist?
        if (!fullName || !email || !phone || !city || !partnerType || !location || !locationOwnership) {
            console.log('[Controller] Validation Failed: Missing required fields');
            return res.status(400).json({
                error: 'Missing required fields. Please provide all information.'
            });
        }

        // 2. Controller Checks: Who is calling? (Context/Identity check)
        // For public forms, we might log the IP or User-Agent, or check session if applicable
        const clientIp = req.ip || req.headers['x-forwarded-for'] || 'unknown';
        console.log(`[Controller] Incoming request from: ${clientIp} for email: ${email}`);

        // 3. Delegation: "Service, do the actual work"
        const newPartner = await partnerService.createPartnerApplication({
            fullName,
            email,
            phone,
            city,
            partnerType,
            location,
            locationOwnership
        });

        // 4. Controller gets result back & converts it to HTTP response
        console.log(`[Controller] Service completed work. New Partner ID: ${newPartner.id}`);
        return res.status(201).json({
            message: 'Partner application submitted successfully!',
            partnerId: newPartner.id
        });

    } catch (error) {
        console.error('[Controller] Error caught:', error.message);

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
