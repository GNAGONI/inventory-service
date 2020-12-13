DROP VIEW IF EXISTS users_items_features CASCADE;
CREATE VIEW users_items_features AS
	SELECT
		users_items.user_id as user_id,
		users_items.amount as item_amount,
		items_storage.id as item_storage_id,
		items.name as item_name,
		features.id as feature_id,
		features.name as feature_name,
		features_values.id as feature_value_id,
		features_values.feature_value as feature_value
	FROM users_items AS users_items
	JOIN items_storage AS items_storage
		ON items_storage.id = users_items.item_storage_id
	JOIN items AS items
		ON items.id = items_storage.item_id
	JOIN item_storage_feature_value AS item_storage_feature_value
		ON item_storage_feature_value.item_storage_id = items_storage.id
	JOIN features_values AS features_values
		ON features_values.id = item_storage_feature_value.feature_value_id
	JOIN features AS features
		ON features.id = features_values.feature_id;


DROP VIEW IF EXISTS users_items_preprocessed_features_json CASCADE;
CREATE VIEW users_items_preprocessed_features_json AS
SELECT
	user_id,
	item_name,
	item_storage_id,
	item_amount,
	json_build_object(
		'id', feature_id,
		'name', feature_name,
		'value', json_build_object(
			'id', feature_value_id,
			'name', feature_value
		)
 	) AS features
FROM users_items_features
GROUP BY
	user_id,
	item_name, item_storage_id, item_amount,
	feature_id, feature_name, feature_value, feature_value_id
ORDER BY user_id;

select * from users_items_preprocessed_features_json;


DROP VIEW IF EXISTS users_preprocessed_items_json CASCADE;
CREATE VIEW users_preprocessed_items_json AS
SELECT
	user_id,
	json_build_object(
		'name', item_name,
		'id', item_storage_id,
		'amount', item_amount,
		'features', json_agg(features)
		
	) AS items
FROM users_items_preprocessed_features_json
GROUP BY user_id, item_name,item_name, item_storage_id, item_amount;
SELECT * FROM users_preprocessed_items_json;


DROP VIEW IF EXISTS users_preprocessed_items_array CASCADE;
CREATE VIEW users_preprocessed_items_array AS
SELECT
	user_id,
	json_agg(items) AS items
FROM users_preprocessed_items_json
GROUP BY user_id;
SELECT * FROM users_preprocessed_items_array;




-- demo

DROP VIEW IF EXISTS demo_users_items_preprocessed_features CASCADE;
CREATE VIEW demo_users_items_preprocessed_features AS
SELECT
	user_id, item_name, json_object_agg(feature_name, feature_value) AS features
FROM users_items_features
GROUP BY user_id, item_name
ORDER BY user_id;


DROP VIEW IF EXISTS demo_users_preprocessed_items CASCADE;
CREATE VIEW demo_users_preprocessed_items AS
SELECT
	user_id, json_object_agg(item_name, features) AS items
FROM demo_users_items_preprocessed_features
GROUP BY user_id;


DROP VIEW IF EXISTS demo_users_items_preprocessed_features_string CASCADE;
CREATE VIEW demo_users_items_preprocessed_features_string AS
SELECT
	user_id,
 	concat('$name:', item_name, '$id:', item_storage_id, '$amount:', item_amount) AS item,
	json_object_agg(
		concat('$name:', feature_name, '$id:', feature_id),
		concat('$name:', feature_value, '$id:', feature_value_id)
	) AS features
FROM users_items_features
GROUP BY user_id , item_storage_id, item_name, item_amount
ORDER BY user_id;


DROP VIEW IF EXISTS demo_users_preprocessed_items_string CASCADE;
CREATE VIEW demo_users_preprocessed_items_string AS
SELECT
	user_id,
	json_object_agg(item, features) AS items
FROM demo_users_items_preprocessed_features_string
GROUP BY user_id;