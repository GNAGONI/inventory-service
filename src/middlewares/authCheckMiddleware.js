const jwt = require('jsonwebtoken');

const authCheckMiddleware = (req, res, next) => {
  try {
    const token = req.headers.authorization;

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = {
      email: decoded.email,
      id: decoded.id,
    };
    next();
  } catch (err) {
    res.sendStatus(401);
  }
};

module.exports = authCheckMiddleware;
