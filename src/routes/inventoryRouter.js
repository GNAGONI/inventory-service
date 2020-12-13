const express = require('express');
const { param } = require('express-validator');
const { inventoryController } = require('../controllers');
const { validationMiddleware } = require('../middlewares');

const inventoryRouter = express.Router();

inventoryRouter.get('/me', inventoryController.me);
inventoryRouter.get(
  '/:userId',
  [
    param('userId')
      .isUUID()
      .withMessage('Param userId should be uuid'),
  ],
  validationMiddleware,
  inventoryController.user,
);
inventoryRouter.post(
  '/grant/:userId',
  [
    param('userId')
      .isUUID()
      .withMessage('Param userId should be uuid'),
  ],
  validationMiddleware,
  inventoryController.grant,
);
inventoryRouter.post(
  '/consume/:userId',
  [
    param('userId')
      .isUUID()
      .withMessage('Param userId should be uuid'),
  ],
  validationMiddleware,
  inventoryController.consume,
);

module.exports = inventoryRouter;
