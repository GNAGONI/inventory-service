DROP FUNCTION IF EXISTS grant_item_to_user CASCADE;
CREATE OR REPLACE FUNCTION
	grant_item_to_user(
		item_storage_id_to_grant INTEGER,
		user_id_to_grant UUID,
		item_amount_to_grant INTEGER
	)	RETURNS VOID AS $$
DECLARE
	previous_amount INTEGER;
	check_item_storage_id BOOLEAN;
BEGIN
	SELECT EXISTS(
		SELECT * FROM items_storage
		WHERE id = item_storage_id_to_grant
	) INTO check_item_storage_id;

	IF (check_item_storage_id = false) THEN
		RAISE EXCEPTION 'Item storage has no entity with provided id'; 
	END IF;
	
	SELECT amount INTO previous_amount
	FROM items_storage
	WHERE id = item_storage_id_to_grant;
	
	IF ((previous_amount - item_amount_to_grant) < 0) THEN
		RAISE EXCEPTION 'Requested amount of items is more than amount of items in items storage'; 
	END IF;
	
	UPDATE items_storage
	SET amount = previous_amount - item_amount_to_grant
	WHERE id = item_storage_id_to_grant;

	INSERT INTO users_items (user_id, item_storage_id, amount)
	VALUES (user_id_to_grant, item_storage_id_to_grant, item_amount_to_grant)
	ON CONFLICT (user_id, item_storage_id)
	DO
		UPDATE SET amount = users_items.amount + item_amount_to_grant;

END
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS consume_item_from_user CASCADE;
CREATE OR REPLACE FUNCTION
	consume_item_from_user(
		item_storage_id_to_consume INTEGER,
		user_id_to_consume UUID,
		item_amount_to_consume INTEGER
	)	RETURNS VOID AS $$
DECLARE
	previous_amount INTEGER;
	check_users_items BOOLEAN;
BEGIN
	SELECT EXISTS(
		SELECT * FROM users_items
		WHERE user_id = user_id_to_consume
		AND item_storage_id = item_storage_id_to_consume
	) INTO check_users_items;
	
	IF (check_users_items = false) THEN
		RAISE EXCEPTION 'User have no items with provided id'; 
	END IF;

	SELECT amount INTO previous_amount
	FROM users_items
	WHERE user_id = user_id_to_consume
	AND item_storage_id = item_storage_id_to_consume;
	
	IF ((previous_amount - item_amount_to_consume) < 0) THEN
		RAISE EXCEPTION 'Amount of items to consume is more than the amount of items user have';
	END IF;

	UPDATE users_items
	SET amount = previous_amount - item_amount_to_consume
	WHERE user_id = user_id_to_consume
	AND item_storage_id = item_storage_id_to_consume;
	
	IF ((previous_amount - item_amount_to_consume) = 0) THEN
		DELETE FROM users_items
		WHERE user_id = user_id_to_consume
		AND item_storage_id = item_storage_id_to_consume
		AND amount = 0;
	END IF;

END
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS create_item CASCADE;
CREATE OR REPLACE FUNCTION create_item(item_name TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO items (name)
		VALUES (item_name);
END;
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS create_feature CASCADE;
CREATE OR REPLACE FUNCTION create_feature(feature_name TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO features (name)
		VALUES (feature_name);
END;
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS add_values_to_feature CASCADE;
CREATE OR REPLACE FUNCTION add_values_to_feature(feature_id INTEGER, feature_values TEXT[]) RETURNS VOID AS $$
DECLARE
	feature_value text;
BEGIN
	FOREACH feature_value IN ARRAY feature_values
	LOOP
		INSERT INTO features_values(feature_id, feature_value)
		VALUES (feature_id, feature_value);
	END LOOP;	
END;
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS create_item_storage CASCADE;
CREATE OR REPLACE FUNCTION create_item_storage(item_id INTEGER, amount INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO items_storage (item_id, amount)
		VALUES (item_id, amount);
END;
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS add_values_to_item_storage CASCADE;
CREATE OR REPLACE FUNCTION add_values_to_item_storage(item_storage_id INTEGER, feature_values_ids INTEGER[])
	RETURNS VOID AS $$
DECLARE
	feature_value_id INTEGER;
BEGIN
	FOREACH feature_value_id IN ARRAY feature_values_ids
	LOOP
		INSERT INTO item_storage_feature_value(item_storage_id, feature_value_id)
		VALUES (item_storage_id, feature_value_id);
	END LOOP;	
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS find_user_items CASCADE;
CREATE OR REPLACE FUNCTION find_user_items(id UUID)
	RETURNS SETOF users_preprocessed_items_array AS $$
BEGIN
	RETURN QUERY SELECT * FROM users_preprocessed_items_array
	WHERE user_id = id;
END;
$$ LANGUAGE plpgsql;


