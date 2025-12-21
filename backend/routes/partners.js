import express from 'express';
import { createPartner } from '../controllers/partnerController.js';
import Partner from '../models/Partner.js';

const router = express.Router();

/**
 * Public Website Endpoint
 * POST /api/partners
 */
router.post('/', createPartner);

/**
 * CMS Endpoints (Single Source of Truth)
 */

// List all partners
router.get('/', async (req, res) => {
    try {
        const partners = await Partner.findAll({
            order: [['created_at', 'DESC']]
        });
        res.status(200).json(partners);
    } catch (error) {
        console.error('Error fetching partners:', error);
        res.status(500).json({ error: 'Internal server error.' });
    }
});

// Get partner details
router.get('/:id', async (req, res) => {
    try {
        const partner = await Partner.findByPk(req.params.id);
        if (!partner) {
            return res.status(404).json({ error: 'Partner not found.' });
        }
        res.status(200).json(partner);
    } catch (error) {
        console.error('Error fetching partner:', error);
        res.status(500).json({ error: 'Internal server error.' });
    }
});

export default router;
