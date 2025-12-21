import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

import servicesRoutes from './routes/services.js';
import contactRoutes from './routes/contact.js';
import stationsRoutes from './routes/stations.js';
import partnersRoutes from './routes/partners.js';

import sequelize from './config/db.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use('/api/services', servicesRoutes);
app.use('/api/contact', contactRoutes);
app.use('/api/stations', stationsRoutes);
app.use('/api/partners', partnersRoutes);

app.get('/', (req, res) => {
  res.send('Welcome to Tezzon Charge API');
});

// Sync database and start server
const startServer = async () => {
  try {
    await sequelize.authenticate();
    console.log('Database connected successfully.');
    await sequelize.sync();
    console.log('Database synced.');
  } catch (err) {
    console.error('CRITICAL: Failed to connect to or sync database. Form submissions will fail.');
    console.error('Error details:', err); // Log the full error object
    console.error('Please ensure PostgreSQL is running and credentials in backend/.env are correct.');
  }

  app.listen(PORT, () => {
    console.log(`Server is listening on port ${PORT}`);
    console.log(`Frontend can now reach the API at http://localhost:${PORT}`);
  });
};

startServer();
