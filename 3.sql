-- базу наполнил вручную.
-- ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке

SELECT distinct firstname
FROM users;

-- iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). 
-- Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)

-- добавляем в профайлы is_active BOOL default true
-- также в профайлі добавляем колонку age со значениями

UPDATE profiles
SET
	is_active = false 
WHERE age < '18';

-- iv. Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)

DELETE FROM messages
WHERE created_at > CURDATE();

-- по теме курсовой определюсь в ближайшее время
