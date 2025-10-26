import express from 'express';
import { stations } from '../data/stations.js';

const router = express.Router();

// GET all stations
router.get('/', (req, res) => {
  res.json(stations);
});

// Optional: GET a specific station by ID
router.get('/:id', (req, res) => {
  const stationId = parseInt(req.params.id);
  const station = stations.find(s => s.id === stationId);

  if (station) {
    res.json(station);
  } else {
    res.status(404).json({ error: "Station not found" });
  }
});

export default router;
