const { dbQuery } = require('../db');

const me = async (req, res) => {
  const r = await dbQuery(
    "SELECT * FROM grant_item_to_user(1, 'bfa81a1e-583d-48bc-a50c-a7460dab5ffb', 100000)",
  );
  console.log(r);

  res.send(200);
};

const user = async (req, res) => {
  res.send(200);
};

const grant = async (req, res) => {
  const { userId, itemStorageId, itemAmount } = req.body;
  await dbQuery(
    `SELECT * FROM grant_item_to_user('${itemStorageId}', '${userId}', '${itemAmount}');`,
  );
  res.sendStatus(200);
};

const consume = async (req, res) => {
  const { userId, itemStorageId, itemAmount } = req.body;
  await dbQuery(
    `SELECT * FROM consume_item_from_user('${itemStorageId}', '${userId}', '${itemAmount}');`,
  );
  res.sendStatus(200);
};

module.exports = {
  me,
  user,
  grant,
  consume,
};
