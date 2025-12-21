import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const client = new pg.Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

try {
    await client.connect();
    console.log(`SUCCESS: Connected to ${process.env.DB_NAME}`);
} catch (error) {
    console.error(`FAILURE: Unable to connect to ${process.env.DB_NAME}`, error);
} finally {
    await client.end();
    process.exit();
}
