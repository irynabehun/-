DROP DATABASE movie;
CREATE DATABASE movie;
USE movie;

CREATE Table user(
user_id INT PRIMARY KEY AUTO_INCREMENT,
first_name varchar(15), 
last_name varchar(20),
email varchar(30),
age int,
phone_num varchar(12) NOT NULL);

Create Table cinema(
cinema_id INT AUTO_INCREMENT,
name_of_cinema varchar(30) NOT NULL,
adress varchar(60),
Primary Key(cinema_id));

CREATE Table hall(
hall_id INT AUTO_INCREMENT,
num_of_seats_pr int NOT NULL,
num_of_seats_nr int NOT NULL,
cinema_id INT,
Primary Key(hall_id),
Foreign Key(cinema_id) REFERENCES cinema(cinema_id)ON DELETE CASCADE ON UPDATE CASCADE);

Create Table movie(
movie_id INT AUTO_INCREMENT,
m_name varchar(30) NOT NULL,
m_language varchar(15),
genre varchar(30),
audience varchar(5),
cost_nr int NOT NULL,
m_time_min int,
Primary Key(movie_id));

CREATE Table showe(				
show_id INT AUTO_INCREMENT,
show_time time NOT NULL,
show_date date NOT NULL,				
seats_remaining_pr int,
seats_remaining_nr int,
hall_id INT ,
movie_id INT ,
Primary Key(show_id),
Foreign Key (hall_id) REFERENCES hall(hall_id) ON DELETE CASCADE ON UPDATE CASCADE,
Foreign Key (movie_id) REFERENCES movie(movie_id) ON DELETE CASCADE ON UPDATE CASCADE );

CREATE Table booking(
booking_id INT AUTO_INCREMENT,
booking_time time NOT NULL,
boking_date date NOT NULL,
seat_class varchar(2) NOT NULL,                                          
card_number varchar(16),
name_on_card varchar(50),
show_id INT,
user_id INT,
Foreign Key (user_id) REFERENCES user (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
Foreign Key (show_id) REFERENCES showe (show_id) ON DELETE CASCADE ON UPDATE CASCADE,
Primary Key(booking_id));
