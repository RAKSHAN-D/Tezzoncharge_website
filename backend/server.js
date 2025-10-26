import express from 'express';
import cors from 'cors';

import servicesRoutes from './routes/services.js';
import contactRoutes from './routes/contact.js';
import stationsRoutes from './routes/stations.js';

// Add below other app.use lines


const app = express();
const PORT = 5000;

app.use(cors());
app.use(express.json());

app.use('/api/services', servicesRoutes);
app.use('/api/contact', contactRoutes);
app.use('/api/stations', stationsRoutes);

app.get('/', (req, res) => {
  res.send('Welcome to Tezzon Charge API');
});

app.listen(PORT, () => {
  console.log(`Server is listening on port ${PORT}`);
});
