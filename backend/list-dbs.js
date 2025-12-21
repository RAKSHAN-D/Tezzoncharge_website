import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const client = new pg.Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: 'postgres' // Connect to default database to list others
});

try {
    await client.connect();
    const res = await client.query('SELECT datname FROM pg_database WHERE datistemplate = false;');
    console.log('Available databases:');
    res.rows.forEach(row => console.log(` - ${row.datname}`));
} catch (error) {
    console.error('FAILURE: Unable to list databases:', error);
} finally {
    await client.end();
    process.exit();
}
