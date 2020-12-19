const { dbQuery } = require('../db');

const me = async (req, res) => {
  const userId = req.user.id;
  const result = await dbQuery(`SELECT * FROM find_user_items('${userId}')`);
  res.send(result.rows);
};

const user = async (req, res) => {
  const { userId } = req.params;
  const result = await dbQuery(`SELECT * FROM find_user_items('${userId}')`);
  res.send(result.rows);
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
