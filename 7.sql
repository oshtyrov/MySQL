/*Транзакции, переменные, представления 
 
 
1. В базе данных shop и sample присутствуют одни и те же таблицы, 
учебной базы данных. Переместите запись id = 1 из таблицы 
shop.users в таблицу sample.users. Используйте транзакции.*/ 
DROP TABLE IF EXISTS sample;
CREATE TABLE `sample` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'Имя покупателя',
  `birthday_at` date DEFAULT NULL COMMENT 'Дата рождения',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Покупатели';

START TRANSACTION; 
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1; 
DELETE FROM shop.users WHERE id = 1; 
COMMIT; 
 
 
 
/*2. Создайте представление, которое выводит название name товарной 
 позиции из таблицы products и соответствующее название каталога 
 name из таблицы catalogs.*/ 
 
CREATE VIEW v AS SELECT 
 p.name, 
 c.name as name_catalog 
FROM 
 catalogs AS c 
LEFT JOIN 
 products AS p 
ON 
 c.id = p.catalog_id; 
 
SELECT * FROM v; 
 
 
/*Практическое задание по теме “Хранимые процедуры и функции, триггеры" 
 
1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать 
фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/ 
 
CREATE FUNCTION hello () 
RETURNS TINYTEXT 
BEGIN 
	DECLARE var INT
	SET var = HOUR(NOW());
	CASE 
	WHEN var BETWEEN 6 AND 12 THEN RETURN "Доброе утро"; 
	WHEN var BETWEEN 12 AND 18 THEN RETURN "Добрый день"; 
	WHEN var BETWEEN 18 AND 00 THEN RETURN "Добрый вечер"; 
	WHEN var BETWEEN 00 AND 6 THEN RETURN "Доброй ночи";  
	END CASE; 
END 

SELECT NOW(), hello();