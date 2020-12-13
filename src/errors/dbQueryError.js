const errorTypes = require('./errorTypes');

const dbQueryError = cause => {
  const error = new Error();
  error.type = errorTypes.dbQueryError;
  error.cause = [cause];
  return error;
};

module.exports = dbQueryError;
