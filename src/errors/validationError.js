const errorTypes = require('./errorTypes');

const validationError = cause => {
  const error = new Error();
  error.type = errorTypes.validationError;
  error.cause = cause.map(item => item.msg);
  return error;
};

module.exports = validationError;
