const fs = require('fs');
const path = require('path');
const { client } = require('./index');

const seed = async () => {
  try {
    const tablesSQL = fs.readFileSync(
      path.resolve(__dirname, './tables.sql'),
      'utf8',
    );
    const functionsSQL = fs.readFileSync(
      path.resolve(__dirname, './functions.sql'),
      'utf8',
    );
    const viewsSQL = fs.readFileSync(
      path.resolve(__dirname, './views.sql'),
      'utf8',
    );
    const seedSQL = fs.readFileSync(
      path.resolve(__dirname, './seed.sql'),
      'utf8',
    );

    await client.connect();
    await client.query(tablesSQL);
    await client.query(functionsSQL);
    await client.query(viewsSQL);
    await client.query(seedSQL);

    process.exit();
  } catch (err) {
    console.error(err);
    process.exit(2);
  }
};

seed();
