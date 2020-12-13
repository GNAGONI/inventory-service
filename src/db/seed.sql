DROP FUNCTION IF EXISTS fill_data;
CREATE OR REPLACE FUNCTION fill_data()
	RETURNS VOID AS $$
BEGIN
		PERFORM create_item('knife');
		PERFORM create_item('sword');
		PERFORM create_item('shield');
		PERFORM create_item('horse');

		PERFORM create_feature('size');
		PERFORM create_feature('colour');
		PERFORM create_feature('boost');

		PERFORM add_values_to_feature(1, ARRAY['small', 'medium', 'big']);
		PERFORM add_values_to_feature(2, ARRAY['red', 'blue', 'white']);
		PERFORM add_values_to_feature(3, ARRAY['x0.5', 'x1.5', 'x2', 'x3']);

		PERFORM create_item_storage(1, 100); -- create 100 knifes
		PERFORM create_item_storage(2, 50);  -- create 50 swords
		PERFORM create_item_storage(3, 5);   -- create 5 shields
		PERFORM create_item_storage(4, 10);  -- create 10 horses

		PERFORM add_values_to_item_storage(1, ARRAY[3, 7]);  -- SIZE = 'big',  BOOST = 'x0.5'
		PERFORM add_values_to_item_storage(2, ARRAY[6, 10]); -- COLOUR = 'white', BOOST = 'x3'
		PERFORM add_values_to_item_storage(3, ARRAY[1]);     -- SIZE = 'small'
		PERFORM add_values_to_item_storage(4, ARRAY[7, 6]);     -- BOOST = 'x0.5', COLOUR = 'white'

		PERFORM grant_item_to_user(1, 'bfa81a1e-583d-48bc-a50c-a7460dab5ffb', 1);
		PERFORM grant_item_to_user(2, 'bfa81a1e-583d-48bc-a50c-a7460dab5ffb', 1);
		PERFORM grant_item_to_user(3, '09f3f185-552a-4231-9077-f2bba2d5ade7', 4);
		PERFORM grant_item_to_user(4, '09f3f185-552a-4231-9077-f2bba2d5ade7', 1);
END;
$$ LANGUAGE plpgsql;


SELECT fill_data();
