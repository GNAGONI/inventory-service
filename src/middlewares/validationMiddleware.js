const { validationResult } = require('express-validator');
const { validationError } = require('../errors');

const validationMiddleware = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    throw validationError(errors.array());
  }
  next();
};

module.exports = validationMiddleware;
