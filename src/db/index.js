const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');

dotenv.config();

const client = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: process.env.POSTGRES_PORT,
});

const dbConnect = cb => {
  (async () => {
    try {
      await client.connect();
      client.on('error', e => {
        console.error(e);
        process.exit(2);
      });
      cb();
    } catch (e) {
      console.error(e);
      process.exit(2);
    }
  })();
};

module.exports = {
  client,
  dbConnect,
};
