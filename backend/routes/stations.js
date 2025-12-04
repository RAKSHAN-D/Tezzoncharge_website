import express from 'express';
import { stations } from '../data/stations.js';

const router = express.Router();

// GET all stations
router.get('/', (req, res) => {
  try {
    if (!stations || stations.length === 0) {
      return res.status(404).json({ error: "No stations found." });
    }
    res.status(200).json(stations);
  } catch (error) {
    console.error("Stations route error:", error);
    res.status(500).json({ error: "Internal server error. Could not fetch stations." });
  }
});

// GET a specific station by ID
router.get('/:id', (req, res) => {
  try {
    const stationId = parseInt(req.params.id);

    // Validate ID
    if (isNaN(stationId)) {
      return res.status(400).json({ error: "Invalid station ID. Must be a number." });
    }

    const station = stations.find(s => s.id === stationId);

    if (station) {
      res.status(200).json(station);
    } else {
      res.status(404).json({ error: "Station not found." });
    }
  } catch (error) {
    console.error("Station detail route error:", error);
    res.status(500).json({ error: "Internal server error. Could not fetch station." });
  }
});

export default router;
