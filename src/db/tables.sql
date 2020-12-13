DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS features CASCADE;
DROP TABLE IF EXISTS features_values CASCADE;
DROP TABLE IF EXISTS items_storage CASCADE;
DROP TABLE IF EXISTS item_storage_feature_value CASCADE;
DROP TABLE IF EXISTS users_items CASCADE;

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name TEXT
);

CREATE TABLE features (
  id SERIAL PRIMARY KEY,
  name TEXT
);

CREATE TABLE features_values (
  id SERIAL PRIMARY KEY,
  feature_id INTEGER REFERENCES features(id) ON DELETE SET NULL,
  feature_value TEXT
);

CREATE TABLE items_storage (
  id SERIAL PRIMARY KEY,
  item_id INTEGER REFERENCES items(id) ON DELETE SET NULL,
  amount INTEGER
);

CREATE TABLE item_storage_feature_value (
  item_storage_id INTEGER REFERENCES items_storage(id) ON DELETE SET NULL,
  feature_value_id INTEGER REFERENCES features_values(id) ON DELETE SET NULL
);

CREATE TABLE users_items (
  user_id UUID,
  item_storage_id INTEGER REFERENCES items_storage(id) ON DELETE SET NULL,
  amount INTEGER
);