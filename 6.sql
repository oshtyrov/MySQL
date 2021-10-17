-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
INSERT INTO orders (user_id ) values
	('1'),
	('2'),
	('3')
;

SELECT id, name FROM users
WHERE id IN(SELECT user_id FROM orders)
;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT
	p.name,
	c.name
FROM
	catalogs AS c
JOIN
	products AS p
WHERE
	c.id = p.catalog_id
;

-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.


DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255),
  `to` VARCHAR(255)
)
;

INSERT INTO flights(`from`, `to`) VALUES
  ('London', 'Paris'),
  ('Rome', 'Florence'),
  ('Madrid', 'Stambul')
;

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  `label` VARCHAR(255),
  `name` VARCHAR(255)
)
;

INSERT INTO cities(`label`, `name`) VALUES
  ('London', 'Лоднод'),
  ('Rome', 'Рим'),
  ('Madrid', 'Мадрид'),
  ('Paris', 'Париж'),
  ('Florence', 'Флоренция'),
  ('Stambul', 'Стамбул')
;