const authCheckMiddleware = require('./authCheckMiddleware');
const errorMiddleware = require('./errorMiddleware');
const validationMiddleware = require('./validationMiddleware');

module.exports = {
  authCheckMiddleware,
  errorMiddleware,
  validationMiddleware,
};
