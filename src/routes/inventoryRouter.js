const express = require('express');
const { param, body } = require('express-validator');
const { inventoryController } = require('../controllers');
const { validationMiddleware, authCheckMiddleware } = require('../middlewares');

const inventoryRouter = express.Router();

inventoryRouter.get('/me', authCheckMiddleware, inventoryController.me);
inventoryRouter.get(
  '/:userId',
  [
    param('userId')
      .isUUID()
      .withMessage('Param userId should be uuid'),
  ],
  authCheckMiddleware,
  validationMiddleware,

  inventoryController.user,
);
inventoryRouter.post(
  '/grant',
  [
    body('userId')
      .isUUID()
      .withMessage('User id should be uuid'),
    body('itemStorageId')
      .isNumeric()
      .withMessage('Item storage id should be a number')
      .isFloat({ min: 1 })
      .withMessage('Item storage id should be positive'),
    body('itemAmount')
      .isNumeric()
      .withMessage('Item amount id should be a number')
      .isFloat({ min: 1 })
      .withMessage('Item amount should be positive'),
  ],
  authCheckMiddleware,
  validationMiddleware,
  inventoryController.grant,
);

inventoryRouter.post(
  '/consume',
  [
    body('userId')
      .isUUID()
      .withMessage('User id should be uuid'),
    body('itemStorageId')
      .isNumeric()
      .withMessage('Item storage id should be a number')
      .isFloat({ min: 1 })
      .withMessage('Item storage id should be positive'),
    body('itemAmount')
      .isNumeric()
      .withMessage('Item amount id should be a number')
      .isFloat({ min: 1 })
      .withMessage('Item amount should be positive'),
  ],
  authCheckMiddleware,
  validationMiddleware,
  inventoryController.consume,
);

module.exports = inventoryRouter;
