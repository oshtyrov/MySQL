-- Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем.

SELECT from_user_id
FROM messages
WHERE to_user_id = 1
GROUP BY from_user_id
ORDER BY COUNT(*) DESC
LIMIT 1
;

-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..

SELECT COUNT(*) AS right_answer
	FROM likes
	WHERE user_id  IN (SELECT user_id FROM profiles WHERE YEAR(CURDATE())-YEAR(birthday) < 10)
;

-- Определить кто больше поставил лайков (всего): мужчины или женщины.
	
SELECT gender AS right_answer FROM profiles WHERE user_id IN (SELECT user_id FROM likes)
GROUP BY gender
ORDER BY COUNT(*) DESC
LIMIT 1
;