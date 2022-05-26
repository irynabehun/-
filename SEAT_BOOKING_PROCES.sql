CREATE DEFINER=`root`@`localhost` PROCEDURE `SEAT_BOOKING`(
in  s_class varchar(5),
in card_num varchar(16),
in name_card varchar(50), 
in s_id varchar(10),
in user_id varchar(5)
)
BEGIN
declare pr int;
declare nr int;


	SELECT seats_remaining_pr INTO pr FROM showe
WHERE show_id = s_id;
SELECT seats_remaining_nr INTO nr FROM showe
WHERE show_id LIKE s_id;
	IF s_class LIKE 'pr' THEN 
    IF pr = 0  THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'No More Premiun Seats Available. Try a different Class';
		ELSE
			UPDATE showe SET seats_remaining_pr = seats_remaining_pr - 1 Where show_id = s_id;
            
            INSERT INTO booking (booking_time, boking_date, seat_class, card_number, name_on_card, show_id, user_id)
   VALUES (CURTIME(), CURRENT_DATE(), s_class, card_num, name_card, s_id, user_id);
		END IF;
	ELSE
		IF Nr = 0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'No More Normal Seats Available. Try a different Class';
		ELSE
			UPDATE showe SET seats_remaining_nr = seats_remaining_nr - 1 
            Where show_id = s_id;
            INSERT INTO booking (booking_time, boking_date, seat_class, card_number, name_on_card, show_id, user_id)
   VALUES (b_time, b_date, s_class, card_num, name_card, s_id, user_id);
		END IF; 
	END IF;
END