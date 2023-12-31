-- Active: 1690719083532@@127.0.0.1@3306@task_6
CREATE DATABASE IF NOT EXISTS task_6; -- Создал БД task_6, если ЕЕ не было раньше

-- 2. Подключение к конкретной базе 
USE task_6; -- Выбрал БД для работы task_6

-- 3. Создание таблицы - user_statistic. 
DROP TABLE IF EXISTS user_statistic; -- Удалить таблицу, если она существует
CREATE TABLE IF NOT EXISTS user_statistic
(
	-- Формула столбца: имя_столбца тип_данных ограничения 
    id INT PRIMARY KEY AUTO_INCREMENT, -- первичный ключ, целое число 
    session_duration INT -- длительность сессии
);

-- 4. Заполнение таблицы данными
INSERT user_statistic(session_duration)
VALUES 
	(2345345), -- id = 1
    (6733673), -- id = 2
	(657456), -- id = 3
    (7846362), -- id = 4
    (1515567); -- id = 5

SELECT * FROM user_statistic;

DROP PROCEDURE IF EXISTS get_time;
DELIMITER $$ -- Начало процедуры для сервера , "$$" - символ - разделитель, как ";"
CREATE PROCEDURE get_time
(
	IN user_number INT, -- id пользователя 
	OUT formatted_time VARCHAR(45) 
)
BEGIN
	DECLARE unformatted_time INT; -- NULL
    DECLARE day_time INT; -- NULL
    DECLARE hour_time INT; -- NULL
    DECLARE minute_time INT; -- NULL
    DECLARE second_time INT; -- NULL
    
	SELECT session_duration INTO unformatted_time -- Добавляет продолжительность сессии по условию user_number = id в переменную 
    FROM user_statistic 
    WHERE user_number = id; 
	
    SET day_time = unformatted_time DIV 86400;
    SET hour_time = (unformatted_time % 86400) DIV 3600;
    SET minute_time = ((unformatted_time % 86400) % 3600) DIV 60;
    SET second_time = (((unformatted_time % 86400) % 3600) % 60);
    SET formatted_time = CONCAT(day_time, " дней, ", hour_time, " часов, ", minute_time, " минут, ", second_time, " секунд.");END $$
DELIMITER ;
-- '$$ -- Конец процедуры, причем, для сервера
CALL get_time
	(1, @procedure_result);
SELECT @procedure_result;

DROP PROCEDURE IF EXISTS print_numbers;
DELIMITER //
CREATE PROCEDURE print_numbers
(
	IN input_numbers INT
)
BEGIN
	DECLARE n INT;
    DECLARE result VARCHAR(45) DEFAULT "";
    SET n = 0;

	REPEAT
		SET n = n + 2;
        SET result = CONCAT(result, n, ",");
        UNTIL n > input_numbers - 2 -- Условие выхода из цикла: когда n больше введёного числа
	END REPEAT;
	SELECT result;
END //

CALL print_numbers(10);
