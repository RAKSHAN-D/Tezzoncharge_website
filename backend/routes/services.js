import express from 'express';
import { services } from '../data/services.js';

const router = express.Router();

router.get('/', (req, res) => {
  try {
    if (!services || services.length === 0) {
      return res.status(404).json({ error: "No services found." });
    }
    res.status(200).json(services);
  } catch (error) {
    console.error("Services route error:", error);
    res.status(500).json({ error: "Internal server error. Could not fetch services." });
  }
});

export default router;
