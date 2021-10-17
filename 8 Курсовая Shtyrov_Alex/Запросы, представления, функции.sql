-- песни на "бразильском" и "кубинском" языке (диалекты испанского)
SELECT *
	FROM songs
	WHERE language_country_id = 340
		OR language_country_id = 316
;

-- ид, имя, фамилия юзеров, имена которых включают 'Be' или 'Da', сортировка по id, лимит - 5 записей
SELECT id, firstname, lastname 
	FROM users
	WHERE firstname RLIKE 'Be|Da'
ORDER BY id
LIMIT 5
;

-- подсчитать общее количество активных пользователей женского пола
SELECT COUNT(*) AS right_answer
	FROM users
	WHERE id  IN (SELECT user_id FROM profiles WHERE gender = 'f' AND is_active = 1)
;

-- Определить, у кого, мужчин или женщин больше создано плейлистов и вывести их количество
SELECT gender, COUNT(*) AS playlists 
	FROM profiles
	WHERE user_id IN (SELECT created_by_user_id FROM playlists)
GROUP BY gender
ORDER BY COUNT(*) DESC
LIMIT 1
;

--  информация про активных пользователей из двух таблиц в алфавитном порядке по именам
SELECT
	u.id,
	u.firstname,
	u.lastname,
	u.email,
	p.gender
	FROM users AS u
		LEFT JOIN
	profiles AS p
	ON u.id = p.user_id
	WHERE p.is_active = 1
ORDER BY u.firstname 
;

-- все плейлисты пользователей с фамилией Cremin
SELECT
	u.id AS user_id,
	u.firstname,
	u.lastname,
	p.id AS playlist_id,
	p.playlist_name 
	FROM users AS u
		LEFT JOIN
			playlists AS p
		ON u.id = p.created_by_user_id
	WHERE u.lastname = 'Cremin'
ORDER BY u.firstname
;

	
-- список песен из всех плейлистов пользователя 1 (не уникальные), их ид и названия
SELECT
	users.id AS user_id,
	playlists.playlist_name,
	playlist_songs_list.song_id,
	songs.song_title,
	playlist_songs_list.genre_id 
	FROM users
		JOIN playlists
	ON users.id = playlists.created_by_user_id
		JOIN playlist_songs_list
	ON playlists.songs_list_id = playlist_songs_list.playlist_id
		JOIN songs
	ON playlist_songs_list.song_id = songs.id
	WHERE users.id = 1
;

-- сборная таблица с данными: ид песни, ее название, название жанра, ид исполнителя, название исполнителя, название исполнителя, название альбома

SELECT 
	s.id AS song_id,
	s.song_title,
	g.genre_name,
	a.artist_name,
	al.album_title
	FROM songs AS s
		JOIN
	genres AS g 
	ON s.genre_id = g.id
		JOIN 
	artists AS a 
	ON a.id = s.artist_id
		JOIN
	albums AS al
	ON al.id = s.album_id
ORDER BY a.artist_name 
;

-- представления

-- Определяет 10 самых популярных песн среди пользователей (песни, которые чаще всего встречается в плейлистах пользователей).
DROP VIEW IF EXISTS most_popular_10;
CREATE VIEW most_popular_10 AS	
	SELECT COUNT(song_id),
	playlist_songs_list.song_id AS song_id,
	songs.song_title,
	artists.artist_name,
	genres.genre_name 
		FROM playlist_songs_list
			JOIN
		songs
		ON songs.id = playlist_songs_list.playlist_id
			JOIN 
		artists
		ON artists.id = songs.artist_id
			JOIN 
		genres
		ON genres.id = songs.genre_id
	GROUP BY songs.song_title
	ORDER BY COUNT(*) DESC
	LIMIT 10
;

SELECT * FROM most_popular_10;

-- процедуры/функции

-- процедуре передается ид пользователя, возвращает количество его плейлистов

DROP PROCEDURE IF EXISTS user_playlists;
DELIMITER //
CREATE PROCEDURE user_playlists (user_id BIGINT)
BEGIN
	SELECT COUNT(*) FROM playlists
	WHERE playlists.created_by_user_id = user_id;
END//
DELIMITER ;
CALL user_playlists(1);

-- функция принимает ид пользователя и возвращает ид его любимого музыкального жанра

DROP FUNCTION IF EXISTS geekmusic.find_favorite_genre_user;
DELIMITER //
CREATE FUNCTION geekmusic.find_favorite_genre_user(check_user_id BIGINT)
RETURNS TINYINT READS SQL DATA
BEGIN
	DECLARE favorit_genre TINYINT;
	
	SET favorit_genre = (
		SELECT
			playlist_songs_list.genre_id
		FROM users
			JOIN playlists
		ON users.id = playlists.created_by_user_id
			JOIN playlist_songs_list
		ON playlists.songs_list_id = playlist_songs_list.playlist_id
		WHERE users.id = check_user_id
		GROUP by genre_id
		ORDER BY COUNT(*) DESC
		LIMIT 1
	);
	RETURN favorit_genre;
END//
DELIMITER ;

SELECT find_favorite_genre_user(1);

-- функция принимает ид пользователя. Исходя из любимого жанра пользователя, он советует артиста, с наибольшим количеством
-- песен любимого жанра пользователя.

DROP FUNCTION IF EXISTS geekmusic.artist_for_you;
DELIMITER //
CREATE FUNCTION geekmusic.artist_for_you(check_user_id BIGINT)
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
	DECLARE favorit_genre TINYINT;
	DECLARE artists_name VARCHAR(255);
	
	SET favorit_genre = (
		SELECT
			playlist_songs_list.genre_id
		FROM users
			JOIN playlists
		ON users.id = playlists.created_by_user_id
			JOIN playlist_songs_list
		ON playlists.songs_list_id = playlist_songs_list.playlist_id
		WHERE users.id = check_user_id
		GROUP by genre_id
		ORDER BY COUNT(*) DESC
		LIMIT 1
	);

	SET artists_name = (
		SELECT 
			artists.artist_name
		FROM songs
			JOIN
		artists
		ON artists.id = songs.artist_id
		WHERE genre_id = favorit_genre
		GROUP BY artist_id
		ORDER BY COUNT(*) DESC
		LIMIT 1
	);
	
	RETURN artists_name;
END//
DELIMITER ;

SELECT geekmusic.artist_for_you(1);

