import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const client = new pg.Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: 'postgres'
});

try {
    await client.connect();
    const res = await client.query('SELECT datname FROM pg_database WHERE datistemplate = false;');
    console.log('Database inspection:');
    res.rows.forEach(row => {
        console.log(` - Name: "${row.datname}", Length: ${row.datname.length}, Hex: ${Buffer.from(row.datname).toString('hex')}`);
    });
} catch (error) {
    console.error('FAILURE:', error);
} finally {
    await client.end();
    process.exit();
}
