DROP DATABASE IF EXISTS books;
CREATE DATABASE books;

USE books;
CREATE TABLE book(
	id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	reader VARCHAR(100),
	isbn VARCHAR(50),
	title VARCHAR(100),
	author VARCHAR(100),
	description VARCHAR(255)
);

INSERT INTO book VALUES (122341, "Reader 1", "1234561", "Title 1", "Author 1", "Description 1"); 
INSERT INTO book VALUES (122342, "Reader 2", "1234562", "Title 2", "Author 2", "Description 2"); 
INSERT INTO book VALUES (122343, "Reader 3", "1234563", "Title 3", "Author 3", "Description 3"); 
INSERT INTO book VALUES (122344, "Reader 4", "1234564", "Title 4", "Author 4", "Description 4"); 
INSERT INTO book VALUES (122345, "Reader 5", "1234565", "Title 5", "Author 5", "Description 5"); 
INSERT INTO book VALUES (122346, "Reader 6", "1234566", "Title 6", "Author 6", "Description 6");