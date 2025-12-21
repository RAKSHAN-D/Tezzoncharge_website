import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const variations = ['TC_CMS', 'tc_cms', 'Tc_Cms'];

for (const dbName of variations) {
    const client = new pg.Client({
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: dbName
    });

    try {
        await client.connect();
        console.log(`SUCCESS: Connected to ${dbName}`);
        await client.end();
        process.exit(0);
    } catch (error) {
        console.error(`FAILURE: Unable to connect to ${dbName}`);
    }
}
process.exit(1);
