-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.

update users
SET
	created_at = curdate(),
	updated_at  = curdate() 
;

-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы
-- типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

ALTER TABLE users MODIFY created_at DATETIME;
ALTER TABLE users MODIFY updated_at DATETIME;

-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
-- если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
-- чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

insert into storehouses_products(storehouse_id, product_id, value) values
	('1', '1', '0'),
	('2', '2', '200'),
	('3', '3', '10'),
	('4', '4', '3'),
	('5', '5', '8'),
	('6', '6', '600'),
	('7', '321', '344'),
	('8', '54', '234'),
	('9', '7', '0'),
	('10', '8', '8665'),
	('11', '11', '375'),
	('12', '12', '334'),
	('13', '13', '0')
;

SELECT value
from storehouses_products
order by case when value=0 then 1 else 0 end, value
;

-- (по желанию) Из таблицы users необходимо извлечь пользователей, 
-- родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT * FROM users WHERE (MONTH(birthday_at)) = 5 or (MONTH(birthday_at)) = 8;

-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
-- Отсортируйте записи в порядке, заданном в списке IN.
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id,'5','1','2');

-- Подсчитайте средний возраст пользователей в таблице users
-- вариант 1, корявый
SELECT
  AVG(
  (YEAR(CURRENT_DATE)-YEAR(birthday_at))-(RIGHT(CURRENT_DATE,5)<RIGHT(birthday_at,5))
  ) AS middle_age
FROM users;

-- вариант 2
SELECT
	AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS middle_age
FROM users;

-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT COUNT(*), DAYNAME(DATE_FORMAT(birthday_at,'2020-%m-%d')) AS day_name FROM users GROUP BY day_name;
SELECT *, DAYNAME(birthday_at) as day_name FROM users;


-- (по желанию) Подсчитайте произведение чисел в столбце таблицы
SELECT value FROM (
VALUE(2),(3),(4),(5)
) X(value);

-- или
select exp(sum(ln(value))) from tab

