const { errorTypes } = require('../errors');

const errorMiddleware = (err, req, res, next) => {
  switch (err.type) {
    case errorTypes.validationError:
      return res.status(422).send({ message: err.cause });
    case errorTypes.dbQueryError:
      return res.status(400).send({ message: err.cause });
    default:
      console.error(err);
      return res.status(400).send({ message: 'Oops, something went wrong' });
  }
};

module.exports = errorMiddleware;
