const dotenv = require('dotenv');
const { Pool } = require('pg');
const { dbQueryError } = require('../errors');

dotenv.config();

const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: process.env.POSTGRES_PORT,
  max: 10,
});

const dbQuery = async (queryStr, params) => {
  const queryPromise = () =>
    new Promise((resolve, reject) => {
      pool.connect((connectionErr, client, release) => {
        if (connectionErr) {
          reject(dbQueryError('Database connection failed'));
        } else {
          client.on('error', e => {
            client.release(true);
            reject(dbQueryError('Database connection failed'));
          });
          client
            .query(queryStr, params)
            .then(res => {
              resolve(res);
            })
            .catch(queryErr => {
              reject(dbQueryError(queryErr.message));
            })
            .finally(() => {
              release();
            });
        }
      });
    });
  const result = await queryPromise();
  return result;
};

module.exports = {
  dbQuery,
};
