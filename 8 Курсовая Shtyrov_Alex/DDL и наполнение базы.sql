-- Курсовой проект в стиле базы данных для ютуб музыка, яндекс музыка, дизер и тп.

DROP DATABASE IF EXISTS Geekmusic;
CREATE DATABASE Geekmusic;
USE Geekmusic;

-- 1 Таблицы медиа типов
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW()
);

-- 2 таблица медиа для хранения обложек альбомов, аватарок и тп
DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

-- 3 Таблица пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    password_hash VARCHAR(100),
    email VARCHAR(50) UNIQUE,
    phone BIGINT UNIQUE, 
    INDEX users_phone_idx(phone),
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

-- 4 Таблица профайлов с данными о пользователях
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender CHAR(1) NOT NULL,
	user_avatar_id BIGINT UNSIGNED NOT NULL,
	is_active BIT DEFAULT 1,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (user_avatar_id) REFERENCES media(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON UPDATE CASCADE
	ON DELETE RESTRICT
);

-- 5 Таблица стран (по совместительстыу языков песен и стран исполнителей)
DROP TABLE IF EXISTS countries;
CREATE TABLE countries(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	country_name VARCHAR(50) UNIQUE
);

-- 6 Таблица исполнителей
DROP TABLE IF EXISTS artists;
CREATE TABLE artists(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	artist_name VARCHAR(50) UNIQUE,
	artist_country_id SMALLINT UNSIGNED NOT NULL,
	artist_photo_id BIGINT UNSIGNED NOT NULL,
	description_artist text,
	INDEX artist_name_indx(artist_name),
	FOREIGN KEY (artist_country_id) REFERENCES countries(id),
	FOREIGN KEY (artist_photo_id) REFERENCES media(id)
);

-- 7 Таблица альбомов
DROP TABLE IF EXISTS albums;
CREATE TABLE albums(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	album_title VARCHAR(50),
	artist_id BIGINT UNSIGNED NOT NULL,
	almum_photo_id BIGINT UNSIGNED NOT NULL,
	INDEX album_title_idx(album_title),
	FOREIGN KEY (artist_id) REFERENCES artists(id),
	FOREIGN KEY (almum_photo_id) REFERENCES media(id)
);

-- 8 Таблица жанров песен
DROP TABLE IF EXISTS genres;
CREATE TABLE genres(
	id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
	genre_name VARCHAR(50) UNIQUE
);


-- 9 Таблица песен
DROP TABLE IF EXISTS songs;
CREATE TABLE songs(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	link_to_file_song VARCHAR(200) UNIQUE,
	song_title VARCHAR(50),
	genre_id TINYINT UNSIGNED NOT NULL,
	artist_id BIGINT UNSIGNED NOT NULL,
	album_id BIGINT UNSIGNED NOT NULL,
	language_country_id SMALLINT UNSIGNED NOT NULL,
	song_duration TIME NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	song_lyrics text,
	INDEX songs_title_idx(song_title),
	FOREIGN KEY (genre_id) REFERENCES genres(id),
	FOREIGN KEY (artist_id) REFERENCES artists(id),
	FOREIGN KEY (album_id) REFERENCES albums(id),
	FOREIGN KEY (language_country_id) REFERENCES countries(id)
);

-- 10 Таблица списков песен плейлистов всех пользователей
DROP TABLE IF EXISTS playlist_songs_list;
CREATE TABLE playlist_songs_list(
	playlist_id BIGINT UNSIGNED NOT NULL,
	song_id BIGINT UNSIGNED NOT NULL,
	album_id BIGINT UNSIGNED NOT NULL,
	genre_id TINYINT UNSIGNED NOT NULL,
	FOREIGN KEY (song_id) REFERENCES songs(id),
	FOREIGN KEY (album_id) REFERENCES songs(album_id),
	FOREIGN KEY (genre_id) REFERENCES songs(genre_id),
	INDEX playlist_songs_list(playlist_id)
);


-- 11 Таблица плейлистов
DROP TABLE IF EXISTS playlists;
CREATE TABLE playlists(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	playlist_name VARCHAR(50),
	songs_list_id BIGINT UNSIGNED NOT NULL,
	created_by_user_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (created_by_user_id) REFERENCES users(id),
	FOREIGN KEY (songs_list_id) REFERENCES playlist_songs_list(playlist_id),
	INDEX (created_by_user_id),
	INDEX (playlist_name)
);

INSERT INTO `countries` (`id`, `country_name`) VALUES 
	(204, 'Afghanistan'),
	(205, 'Albania'),
	(206, 'Algeria'),
	(344, 'Andorra'),
	(233, 'Angola'),
	(364, 'Antigua and Barbuda'),
	(394, 'Argentina'),
	(336, 'Armenia'),
	(351, 'Australia'),
	(219, 'Austria'),
	(276, 'Azerbaijan'),
	(302, 'Bahamas'),
	(268, 'Bahrain'),
	(388, 'Bangladesh'),
	(333, 'Barbados'),
	(365, 'Belarus'),
	(239, 'Belgium'),
	(311, 'Belize'),
	(237, 'Benin'),
	(238, 'Bhutan'),
	(243, 'Bolivia'),
	(202, 'Bosnia and Herzegovina'),
	(270, 'Botswana'),
	(340, 'Brazil'),
	(224, 'Brunei'),
	(390, 'Bulgaria'),
	(353, 'Burkina Faso'),
	(215, 'Burundi'),
	(346, 'Côte d''Ivoire'),
	(305, 'Cabo Verde'),
	(343, 'Cambodia'),
	(254, 'Cameroon'),
	(308, 'Canada'),
	(220, 'Central African Republic'),
	(361, 'Chad'),
	(285, 'Chile'),
	(312, 'Colombia'),
	(252, 'Comoros'),
	(203, 'Congo Congo-Brazzaville'),
	(225, 'Costa Rica'),
	(211, 'Croatia'),
	(316, 'Cuba'),
	(301, 'Cyprus'),
	(212, 'Czechia (Czech Republic)'),
	(329, 'Democratic Republic of the Congo'),
	(214, 'Denmark'),
	(207, 'Djibouti'),
	(325, 'Dominica'),
	(334, 'Dominican Republic'),
	(397, 'Ecuador'),
	(326, 'Egypt'),
	(244, 'El Salvador'),
	(284, 'Equatorial Guinea'),
	(241, 'Eritrea'),
	(298, 'Estonia'),
	(283, 'Eswatini (fmr. "Swaziland")'),
	(294, 'Ethiopia'),
	(385, 'Fiji'),
	(386, 'Finland'),
	(209, 'France'),
	(293, 'Germany'),
	(263, 'Greece'),
	(201, 'Hungary'),
	(338, 'Israel'),
	(235, 'Italy'),
	(234, 'Japan'),
	(304, 'Russia'),
	(266, 'Turkey'),
	(375, 'Ukraine')
;

INSERT INTO `media_types` (`id`, `name`, `created_at`) VALUES 
	('1', 'BMP', '1983-08-13 22:47:20'),
	('2', 'ECW', '2003-02-14 21:44:22'),
	('3', 'GIF', '1988-07-23 08:49:19'),
	('4', 'ICO', '1980-02-20 02:04:50'),
	('5', 'ILBM', '1970-10-15 18:43:57'),
	('6', 'JPEG', '2020-02-16 07:35:56'),
	('7', 'JPEG 2000', '2002-03-11 21:07:09'),
	('8', 'MrSID', '1992-12-19 17:37:53'),
	('9', 'PCX', '2004-08-30 01:02:08'),
	('10', 'PNG', '1970-04-17 01:48:22'),
	('11', 'PSD', '2013-03-07 10:14:00'),
	('12', 'TGA', '2010-02-23 18:46:00'),
	('13', 'TIFF', '2014-02-07 17:00:59'),
	('14', 'HD Photo', '1988-10-11 09:42:04'),
	('15', 'WebP', '2002-08-20 17:55:21'),
	('16', 'XBM', '2017-12-08 23:41:15'),
	('17', 'XPS', '2015-08-21 13:20:28'),
	('18', 'RLA', '2000-12-07 07:03:00'),
	('19', 'RPF', '1998-04-08 04:20:14'),
	('20', 'PNM', '1985-06-05 04:13:21')
;

INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('1', '1', 'eveniet', 12315287, NULL, '1981-09-07 15:08:56', '1982-01-06 22:37:13');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('2', '2', 'officiis', 996125347, NULL, '2001-12-24 08:19:59', '1995-08-13 09:02:21');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('3', '3', 'non', 695, NULL, '1992-09-07 06:21:58', '1980-03-14 21:42:49');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('4', '4', 'impedit', 731233, NULL, '1974-10-28 10:41:46', '1970-11-28 15:31:15');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('5', '5', 'qui', 0, NULL, '1987-02-01 23:25:43', '2004-09-26 17:12:56');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('6', '6', 'et', 46, NULL, '1981-06-14 21:03:58', '2003-09-18 15:01:39');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('7', '7', 'quibusdam', 54475, NULL, '2007-04-05 04:45:04', '1987-08-28 03:33:35');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('8', '8', 'corrupti', 485676, NULL, '1971-06-19 19:45:13', '2008-08-25 21:59:38');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('9', '9', 'non', 4145310, NULL, '1975-05-31 17:52:16', '2019-01-19 02:21:27');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('10', '10', 'reprehenderit', 285753, NULL, '2005-05-11 11:35:16', '2010-07-10 22:42:46');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('11', '11', 'voluptas', 281892, NULL, '1986-01-14 09:44:42', '2010-10-05 06:21:04');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('12', '12', 'porro', 766, NULL, '2010-01-11 04:46:23', '2011-12-31 01:03:26');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('13', '13', 'voluptas', 91825, NULL, '1971-06-09 22:19:11', '1984-05-03 11:21:55');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('14', '14', 'eaque', 59, NULL, '1982-09-15 15:07:44', '1980-04-16 14:48:54');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('15', '15', 'vel', 60419597, NULL, '2012-07-12 16:36:58', '1994-05-09 05:56:30');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('16', '16', 'expedita', 65480, NULL, '1978-02-17 00:45:19', '1971-10-17 01:44:09');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('17', '17', 'temporibus', 200426949, NULL, '2014-03-01 22:54:07', '2002-01-28 14:03:46');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('18', '18', 'corporis', 3229386, NULL, '2006-10-05 23:03:19', '2013-01-21 12:28:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('19', '19', 'ratione', 0, NULL, '1983-08-26 22:56:47', '1985-04-23 06:45:08');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('20', '20', 'quaerat', 0, NULL, '2014-08-17 17:05:06', '1988-03-02 21:07:44');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('21', '1', 'id', 0, NULL, '2010-09-27 19:00:23', '1978-04-23 21:40:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('22', '2', 'officiis', 23, NULL, '1984-05-28 05:35:48', '2019-10-27 18:09:38');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('23', '3', 'dignissimos', 835114, NULL, '2009-03-14 13:20:23', '1973-01-17 21:56:14');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('24', '4', 'est', 7, NULL, '1992-05-21 06:35:16', '1992-10-01 01:18:38');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('25', '5', 'iste', 1778, NULL, '2019-05-18 09:54:45', '2005-08-05 05:22:31');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('26', '6', 'laborum', 28013636, NULL, '1996-05-03 12:49:31', '2014-10-02 09:27:12');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('27', '7', 'in', 570145, NULL, '2020-02-25 10:57:31', '1975-02-10 14:36:32');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('28', '8', 'doloribus', 593328259, NULL, '1979-05-29 13:47:05', '1977-08-03 06:58:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('29', '9', 'dolores', 516, NULL, '2007-03-11 14:09:57', '1982-07-24 02:42:53');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('30', '10', 'deleniti', 75944, NULL, '2006-03-10 19:27:55', '1987-05-15 17:11:26');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('31', '11', 'dolor', 94, NULL, '2011-08-24 14:00:08', '1975-12-18 20:14:55');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('32', '12', 'corrupti', 4, NULL, '2006-04-26 09:33:07', '1980-12-04 05:22:59');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('33', '13', 'et', 7, NULL, '2000-11-26 23:43:17', '2015-11-25 06:39:25');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('34', '14', 'deleniti', 0, NULL, '2016-03-22 02:35:39', '2009-07-01 04:05:01');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('35', '15', 'dolorem', 86032, NULL, '1997-09-18 10:14:20', '1970-07-03 09:05:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('36', '16', 'cumque', 131, NULL, '2007-03-13 18:16:06', '1984-03-20 16:14:12');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('37', '17', 'est', 1546424, NULL, '1998-08-19 17:30:14', '2006-01-08 09:41:16');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('38', '18', 'eum', 730086, NULL, '1971-04-04 08:40:50', '1998-10-29 07:24:01');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('39', '19', 'quis', 154838, NULL, '1994-10-19 07:33:08', '2015-05-04 01:44:46');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('40', '20', 'consequatur', 349717575, NULL, '2011-09-19 12:04:43', '2001-06-03 23:50:35');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('41', '1', 'beatae', 39, NULL, '2008-04-05 22:35:42', '2018-12-31 13:48:33');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('42', '2', 'tenetur', 0, NULL, '2020-05-22 22:31:08', '2011-08-21 02:51:40');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('43', '3', 'similique', 13045, NULL, '1991-03-22 13:09:15', '1988-08-13 20:22:01');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('44', '4', 'animi', 53359069, NULL, '1992-12-27 12:20:04', '1979-09-27 03:55:15');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('45', '5', 'id', 0, NULL, '1989-04-10 01:32:51', '1993-09-14 02:29:54');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('46', '6', 'qui', 7445143, NULL, '2013-08-14 01:56:50', '1988-07-02 08:22:09');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('47', '7', 'enim', 163, NULL, '2001-04-05 07:16:22', '1988-12-29 14:01:01');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('48', '8', 'harum', 9, NULL, '1983-06-11 15:49:25', '1997-03-27 22:54:09');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('49', '9', 'ducimus', 449810, NULL, '2012-01-07 03:39:47', '2018-11-04 00:18:16');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('50', '10', 'quo', 983754, NULL, '2000-01-02 23:08:23', '2010-03-03 00:51:54');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('51', '11', 'fuga', 8134705, NULL, '1991-06-23 00:30:13', '1970-06-12 05:46:50');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('52', '12', 'magnam', 7, NULL, '1996-05-26 01:49:07', '2006-08-06 13:58:37');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('53', '13', 'et', 248079287, NULL, '1972-07-29 14:07:18', '1990-08-15 10:43:16');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('54', '14', 'eligendi', 9, NULL, '1970-12-10 23:03:41', '1973-11-12 04:24:36');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('55', '15', 'quos', 0, NULL, '1974-01-27 17:06:17', '2010-06-01 18:51:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('56', '16', 'iure', 133, NULL, '1975-04-05 03:52:59', '1997-07-07 16:03:01');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('57', '17', 'architecto', 3094552, NULL, '1974-02-05 11:36:23', '1987-05-11 13:16:01');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('58', '18', 'non', 17, NULL, '1988-09-13 20:34:29', '1990-07-25 19:27:10');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('59', '19', 'nihil', 4670, NULL, '1986-11-06 05:21:07', '2002-10-05 00:18:08');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('60', '20', 'sed', 0, NULL, '1994-06-01 18:32:27', '1994-12-04 00:52:02');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('61', '1', 'mollitia', 241101, NULL, '1972-03-25 23:37:36', '1974-07-04 04:37:54');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('62', '2', 'doloremque', 968, NULL, '2019-12-16 13:08:36', '1991-05-27 18:39:36');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('63', '3', 'a', 188614395, NULL, '2013-10-03 20:39:15', '1988-04-16 19:04:44');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('64', '4', 'corrupti', 9, NULL, '1989-01-01 20:35:08', '1989-06-09 06:54:10');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('65', '5', 'aperiam', 855982, NULL, '2016-02-08 15:40:51', '2011-08-08 03:27:03');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('66', '6', 'dolore', 89749, NULL, '2016-12-12 09:58:39', '1995-04-30 08:15:51');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('67', '7', 'eum', 50, NULL, '1977-10-18 08:48:05', '1992-08-12 12:09:58');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('68', '8', 'maxime', 630, NULL, '1988-12-11 16:03:27', '1990-11-23 15:07:02');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('69', '9', 'expedita', 7050957, NULL, '2009-10-05 04:59:56', '2009-01-03 05:47:08');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('70', '10', 'mollitia', 806, NULL, '1994-01-28 17:41:50', '1999-01-10 19:36:54');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('71', '11', 'enim', 7303, NULL, '1984-11-14 05:52:30', '2011-09-28 02:04:23');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('72', '12', 'quam', 5527, NULL, '1987-12-13 04:59:16', '2017-12-26 03:28:27');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('73', '13', 'illo', 99, NULL, '1992-04-04 21:19:52', '2017-08-01 04:19:17');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('74', '14', 'libero', 0, NULL, '2017-07-09 08:47:48', '1984-03-01 10:49:45');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('75', '15', 'voluptates', 4616, NULL, '2002-06-18 06:11:57', '1998-05-31 19:18:57');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('76', '16', 'assumenda', 78, NULL, '2004-02-23 01:10:25', '2000-07-21 23:45:44');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('77', '17', 'itaque', 501002, NULL, '2010-04-04 13:24:26', '2016-10-21 23:36:05');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('78', '18', 'ut', 70840, NULL, '2016-09-25 13:35:17', '1971-03-03 18:48:06');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('79', '19', 'est', 855029818, NULL, '2017-08-03 12:30:38', '1981-12-01 13:47:31');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('80', '20', 'sint', 2, NULL, '1986-12-08 20:33:28', '1992-07-04 05:40:24');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('81', '1', 'in', 815, NULL, '1986-05-15 04:01:19', '1980-09-25 02:57:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('82', '2', 'tenetur', 3131, NULL, '2000-11-19 09:43:42', '1991-02-12 01:31:39');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('83', '3', 'sed', 41298717, NULL, '1996-08-06 01:12:29', '1974-01-18 15:41:07');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('84', '4', 'et', 7901, NULL, '2000-09-10 20:00:03', '1987-02-08 20:43:03');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('85', '5', 'sint', 755, NULL, '1994-01-14 22:02:38', '1977-11-23 03:54:19');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('86', '6', 'temporibus', 948670, NULL, '1992-08-16 06:36:08', '2002-11-30 03:26:54');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('87', '7', 'voluptas', 45726618, NULL, '2003-03-26 03:54:50', '1974-06-27 03:04:50');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('88', '8', 'aut', 73, NULL, '1994-03-24 01:02:20', '1983-08-02 16:05:36');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('89', '9', 'error', 219368482, NULL, '1970-12-11 21:14:34', '2005-08-10 09:08:27');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('90', '10', 'aut', 438, NULL, '1986-11-25 00:57:00', '2005-01-23 03:19:00');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('91', '11', 'tempore', 533, NULL, '1972-03-19 04:26:04', '2002-03-02 15:10:15');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('92', '12', 'eius', 4864923, NULL, '1980-04-08 00:20:04', '2011-12-27 04:13:56');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('93', '13', 'fugit', 340552154, NULL, '2000-10-28 00:46:39', '2018-04-11 12:23:34');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('94', '14', 'quibusdam', 3, NULL, '2003-03-31 22:26:31', '2014-06-10 01:09:56');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('95', '15', 'excepturi', 0, NULL, '1987-11-08 12:33:35', '1994-01-03 03:41:54');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('96', '16', 'voluptatem', 81536364, NULL, '1994-07-02 06:05:26', '2012-10-09 14:13:00');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('97', '17', 'cupiditate', 93, NULL, '1995-12-20 16:00:17', '1987-07-22 20:37:57');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('98', '18', 'maiores', 961937492, NULL, '1980-04-07 22:41:36', '1977-04-16 16:32:27');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('99', '19', 'sint', 9851983, NULL, '2001-01-19 11:47:21', '1980-05-23 23:22:21');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('100', '20', 'ea', 6643, NULL, '1975-02-06 09:37:17', '2011-08-17 12:26:29');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('101', '1', 'exercitationem', 197005314, NULL, '1985-11-19 23:33:04', '1982-09-20 07:32:33');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('102', '2', 'incidunt', 2305890, NULL, '1999-09-25 23:22:34', '2013-05-29 11:56:18');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('103', '3', 'facilis', 9765, NULL, '1995-10-05 02:13:31', '2000-02-19 13:37:12');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('104', '4', 'aliquam', 686, NULL, '2010-10-20 13:55:21', '2010-09-11 14:29:05');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('105', '5', 'repellat', 852, NULL, '1978-07-13 01:38:27', '2002-12-05 14:42:42');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('106', '6', 'expedita', 56613, NULL, '2008-04-08 05:27:03', '1973-09-09 06:47:48');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('107', '7', 'ut', 6330445, NULL, '1988-07-18 00:03:08', '1991-01-26 12:29:10');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('108', '8', 'tenetur', 75336, NULL, '2000-12-26 18:48:21', '1999-04-20 03:07:07');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('109', '9', 'accusantium', 72125, NULL, '2007-05-27 07:42:12', '2011-02-07 04:09:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('110', '10', 'magni', 60507901, NULL, '1987-11-30 04:34:20', '2012-11-06 09:54:12');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('111', '11', 'fugit', 636, NULL, '2012-11-02 22:40:23', '1984-03-13 18:06:06');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('112', '12', 'laborum', 0, NULL, '1997-05-31 04:22:16', '1970-07-05 00:07:18');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('113', '13', 'ea', 610, NULL, '1995-01-09 10:21:51', '2017-01-01 23:55:46');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('114', '14', 'consectetur', 7930007, NULL, '1981-04-09 20:35:10', '1988-09-14 03:41:26');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('115', '15', 'fugit', 318642, NULL, '1976-04-24 05:49:05', '2005-11-23 07:53:03');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('116', '16', 'ratione', 86415458, NULL, '1978-08-07 13:21:02', '2007-06-11 06:02:11');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('117', '17', 'similique', 958953, NULL, '2017-07-26 15:22:20', '1971-08-26 01:20:33');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('118', '18', 'eos', 52, NULL, '1994-04-27 04:24:29', '1989-07-11 14:24:09');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('119', '19', 'qui', 9288, NULL, '1978-11-14 03:49:56', '2012-01-14 00:08:12');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('120', '20', 'optio', 113627960, NULL, '1994-08-04 19:56:16', '2019-07-08 04:02:39');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('121', '1', 'dolor', 2729263, NULL, '2002-04-30 06:19:49', '2008-12-16 04:04:26');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('122', '2', 'quisquam', 2199, NULL, '1995-02-09 16:36:24', '2019-05-27 20:12:57');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('123', '3', 'omnis', 912, NULL, '1997-12-13 03:38:57', '2001-05-30 23:54:44');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('124', '4', 'et', 26553, NULL, '1989-02-20 08:15:37', '1982-08-23 16:36:51');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('125', '5', 'qui', 3, NULL, '2012-03-23 16:52:13', '1983-04-08 05:31:18');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('126', '6', 'exercitationem', 819, NULL, '2006-06-18 21:52:38', '1976-04-21 18:34:27');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('127', '7', 'et', 80113, NULL, '2017-05-31 20:29:00', '1972-10-10 10:22:12');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('128', '8', 'repellendus', 82429877, NULL, '1978-02-20 07:15:21', '1975-01-19 13:01:36');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('129', '9', 'facere', 375677428, NULL, '1996-07-28 07:36:49', '1980-06-12 06:34:07');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('130', '10', 'facilis', 1415967, NULL, '1986-07-15 11:53:31', '1983-04-26 06:55:04');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('131', '11', 'est', 407, NULL, '2019-12-29 11:52:27', '1990-05-05 20:21:20');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('132', '12', 'sunt', 1591, NULL, '1999-01-12 05:11:05', '2010-03-01 16:54:41');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('133', '13', 'nihil', 0, NULL, '1986-12-10 07:18:11', '1983-01-24 08:42:45');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('134', '14', 'nisi', 831059, NULL, '2003-07-17 00:17:02', '1997-07-20 15:25:22');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('135', '15', 'ipsum', 443464, NULL, '1995-08-13 18:15:09', '1991-05-13 21:46:37');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('136', '16', 'quia', 77880751, NULL, '1979-12-25 12:07:19', '1991-09-26 02:12:23');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('137', '17', 'facilis', 8497, NULL, '2020-03-21 04:06:37', '2014-03-30 03:26:11');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('138', '18', 'rem', 866, NULL, '2013-02-14 16:58:32', '1975-09-26 12:31:23');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('139', '19', 'tempora', 0, NULL, '2016-07-24 17:33:47', '1989-11-23 15:46:31');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('140', '20', 'ut', 4, NULL, '1983-01-14 16:00:33', '1996-04-30 23:06:40');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('141', '1', 'ab', 96, NULL, '1987-04-06 17:00:30', '2011-05-25 14:57:58');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('142', '2', 'eum', 70644, NULL, '2010-12-19 00:00:04', '2002-01-18 17:21:28');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('143', '3', 'fuga', 727, NULL, '2015-11-14 19:22:52', '1989-12-08 19:09:27');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('144', '4', 'alias', 57263539, NULL, '1997-09-09 17:00:44', '2016-04-12 14:21:42');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('145', '5', 'quas', 55378, NULL, '2013-09-06 13:03:38', '1983-01-29 22:57:35');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('146', '6', 'reiciendis', 0, NULL, '2008-09-09 01:06:42', '2007-12-05 10:02:53');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('147', '7', 'et', 7197130, NULL, '2000-02-26 11:21:01', '1983-09-09 19:46:22');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('148', '8', 'aut', 1, NULL, '2017-12-21 15:50:04', '1984-06-23 11:52:55');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('149', '9', 'labore', 6742, NULL, '2017-10-01 07:17:11', '2002-06-10 10:35:38');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('150', '10', 'distinctio', 480887008, NULL, '1980-06-12 08:37:54', '2019-09-08 17:56:16');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('151', '11', 'quaerat', 0, NULL, '2001-04-22 16:34:58', '1973-08-13 04:58:22');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('152', '12', 'illo', 8279305, NULL, '1978-07-02 11:18:49', '2011-12-28 14:09:20');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('153', '13', 'error', 8, NULL, '1983-08-19 07:36:14', '2009-08-23 17:59:57');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('154', '14', 'voluptas', 4132, NULL, '1989-02-27 22:08:56', '2006-11-27 02:07:37');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('155', '15', 'maxime', 4345184, NULL, '1990-10-04 15:38:05', '1987-03-10 14:04:03');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('156', '16', 'ducimus', 493449, NULL, '1995-12-30 09:51:54', '2018-08-13 14:38:07');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('157', '17', 'dolorum', 4997, NULL, '1972-01-31 17:59:29', '1990-08-15 08:28:35');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('158', '18', 'enim', 179, NULL, '1998-07-26 16:32:50', '1998-08-07 23:10:25');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('159', '19', 'sunt', 71, NULL, '1986-03-06 19:04:03', '2014-03-21 01:32:45');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('160', '20', 'incidunt', 80569, NULL, '1974-11-03 03:04:50', '1980-10-17 23:08:02');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('161', '1', 'in', 778, NULL, '1998-09-18 03:09:11', '1977-09-17 04:24:53');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('162', '2', 'esse', 8, NULL, '1978-03-11 20:04:38', '2005-02-16 22:01:58');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('163', '3', 'fugit', 69633, NULL, '2018-03-04 05:52:31', '1999-02-08 23:03:06');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('164', '4', 'hic', 933, NULL, '1993-03-20 08:44:58', '1970-03-16 04:20:30');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('165', '5', 'dolores', 797398, NULL, '1976-11-17 06:50:18', '2019-12-23 01:58:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('166', '6', 'harum', 376117, NULL, '1986-07-10 11:40:45', '2008-04-13 04:26:05');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('167', '7', 'quasi', 0, NULL, '1995-04-14 10:51:50', '1991-12-25 18:59:53');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('168', '8', 'assumenda', 0, NULL, '1970-09-20 20:53:29', '1984-01-02 07:43:31');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('169', '9', 'voluptas', 62, NULL, '1993-03-20 05:16:34', '1978-07-01 04:43:38');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('170', '10', 'omnis', 504185143, NULL, '2003-11-26 11:07:58', '2005-11-23 06:55:47');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('171', '11', 'nostrum', 8311, NULL, '1994-06-09 23:45:19', '2006-10-21 10:57:36');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('172', '12', 'natus', 7, NULL, '1975-08-10 08:43:16', '2018-03-20 15:11:20');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('173', '13', 'sint', 24, NULL, '2018-05-25 11:30:55', '1973-10-21 10:39:01');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('174', '14', 'non', 1816, NULL, '1971-08-11 00:48:53', '1978-07-13 16:39:33');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('175', '15', 'consequatur', 16271159, NULL, '1972-08-11 10:39:01', '2018-11-06 05:25:00');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('176', '16', 'dicta', 560528736, NULL, '1975-12-10 11:59:34', '1994-04-21 02:47:15');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('177', '17', 'officiis', 718, NULL, '1974-11-13 13:43:06', '2019-05-19 21:19:39');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('178', '18', 'adipisci', 7657, NULL, '2006-07-08 19:04:54', '2013-07-22 00:04:42');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('179', '19', 'praesentium', 5, NULL, '2005-08-21 12:42:06', '1973-12-25 22:22:07');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('180', '20', 'rem', 906679, NULL, '1975-05-21 02:21:25', '1973-07-17 16:41:02');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('181', '1', 'in', 8, NULL, '2017-09-15 12:45:02', '2013-04-23 14:04:50');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('182', '2', 'voluptas', 83131152, NULL, '2001-12-10 20:40:59', '1983-10-24 09:57:00');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('183', '3', 'perspiciatis', 331058, NULL, '2003-05-21 06:15:49', '2010-01-18 14:49:57');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('184', '4', 'ea', 7, NULL, '2003-09-18 23:57:09', '2009-03-19 04:23:43');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('185', '5', 'praesentium', 86278, NULL, '1974-07-16 03:09:16', '1986-01-09 15:17:58');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('186', '6', 'inventore', 0, NULL, '2016-07-01 08:35:05', '1994-07-11 09:16:51');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('187', '7', 'sint', 401375873, NULL, '1979-04-02 02:10:24', '1990-01-21 12:24:26');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('188', '8', 'consequatur', 31934936, NULL, '2013-10-10 09:06:14', '2000-06-08 23:09:00');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('189', '9', 'vel', 528, NULL, '2007-02-26 19:56:57', '1971-11-29 09:07:23');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('190', '10', 'dolore', 0, NULL, '1997-04-02 20:29:25', '1977-08-11 03:01:43');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('191', '11', 'dolor', 2, NULL, '2017-09-29 01:48:49', '2003-07-12 10:31:30');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('192', '12', 'dolores', 53, NULL, '1989-01-30 19:55:23', '1981-09-14 06:49:19');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('193', '13', 'in', 1994, NULL, '2007-04-19 05:13:19', '2007-06-15 07:07:51');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('194', '14', 'consequuntur', 0, NULL, '2011-02-15 17:43:16', '2010-11-26 23:36:51');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('195', '15', 'natus', 0, NULL, '1986-04-26 14:36:03', '1989-04-17 16:46:19');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('196', '16', 'ipsum', 86, NULL, '1991-06-19 01:29:05', '1986-01-14 06:04:14');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('197', '17', 'consequatur', 9384, NULL, '1985-07-31 06:33:03', '2008-09-30 06:49:53');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('198', '18', 'consequuntur', 2827064, NULL, '2012-10-02 06:05:38', '2012-08-25 14:06:18');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('199', '19', 'illum', 338978, NULL, '2017-08-23 20:59:26', '1999-02-11 17:42:21');
INSERT INTO `media` (`id`, `media_type_id`, `filename`, `size`, `metadata`, `created_at`, `updated_at`) VALUES ('200', '20', 'natus', 119867, NULL, '1996-07-29 23:16:44', '1996-12-21 19:24:37');


INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('1', 'Jerel', 'Smitham', '31874ee3bd71596e046af2819259027ad4f32405', 'groob@example.net', '380514583960');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('2', 'Dexter', 'Maggio', '6946bae85e17c10a47f26f8d44c49681be9b4e8d', 'rkirlin@example.com', '386481644380');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('3', 'Freddy', 'Vandervort', '5ce89c2afff35a720ae9885df10260befe65a099', 'demario.howell@example.org', '382975384634');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('4', 'Ryan', 'Weimann', '3dd29832fb116de88e0698e54567b74a26d69caf', 'zlubowitz@example.org', '383513983869');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('5', 'Rylan', 'Kozey', '38abafd97dd8a3334afd5ee222c2db0aba2f8098', 'pframi@example.com', '382965723811');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('6', 'Velva', 'Marvin', '575ae27ee62927fd1b9a0689ee48bc000990b2e2', 'trycia.hartmann@example.net', '384886820102');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('7', 'Robbie', 'Ryan', 'f5b9c5b717dcb3ec5ddfff07d133038d7ac0ecd3', 'leonor36@example.com', '380418660771');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('8', 'Carlee', 'Hickle', '1fe72d7d9e2555864aa0928805e70e81bbfe3340', 'carlee.lang@example.org', '386326728668');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('9', 'Rigoberto', 'Hintz', '344da39d268c4f80e9a87823ac87708f2804a76b', 'guiseppe17@example.com', '388072564364');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('10', 'Ricky', 'Ziemann', '972506aba0626755d93f80027a5ced12c1798c11', 'medhurst.webster@example.net', '385535023780');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('11', 'Helga', 'Lind', '4de21aa758421fe5cadf1f4afde781c24c524625', 'modesto.farrell@example.net', '386263004112');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('12', 'Meagan', 'Monahan', 'c78da6ecd0595157af94aab8635d49b3084e52e5', 'bernier.johanna@example.org', '380781698217');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('13', 'Jakob', 'Kuhlman', '24f5aeb227647d4c9e20d80ca162483038d1042a', 'anderson.rudy@example.com', '385946395532');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('14', 'Donny', 'Parisian', '651d3f625e77d94238e3e02f5597a60a996099be', 'fcassin@example.org', '381077036978');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('15', 'Baron', 'Murray', '7bb4c0f2ed2ce4bf223546e0505f687083df1473', 'mollie43@example.net', '388673164602');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('16', 'Chanel', 'Thompson', '25030b2bcd44bb91d29aae6df8eef333bc53d8d3', 'pwisozk@example.com', '380054248846');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('17', 'Allene', 'Windler', '843b276f130710ebb616e23d9419f8f36b47ea93', 'thompson.alysha@example.net', '382631779005');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('18', 'Fatima', 'Stiedemann', '4a9053ae4f7d8701c3cd9cdae54348aa27fed4b8', 'hillard07@example.net', '383159380797');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('19', 'Melisa', 'Stroman', 'f3a9f1e1d425c0b5efb6f3d058a7a54315f86f76', 'klowe@example.org', '389618222662');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('20', 'Montana', 'Carroll', '7c1df44d5e0051a630cd6dafc4931f29d96cc044', 'hilario.welch@example.org', '385296572283');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('21', 'Adela', 'Schinner', 'fcfca7129ce55ef6efe5496c9e5dd7c0722ff897', 'thompson.theresia@example.net', '382170616737');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('22', 'Darrick', 'Gislason', 'fcad1a72fe3b421322e8fd14500ea1e58e55c3b9', 'reagan78@example.net', '380148789649');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('23', 'Delores', 'Sawayn', 'fd34658743eaebea92055a7cd5778cf07cc1de9f', 'eichmann.astrid@example.org', '386616582963');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('24', 'Rhoda', 'Koelpin', '7bdf2e0077450fe3a519577a325c626fb69500a1', 'kristopher.bashirian@example.net', '386117164571');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('25', 'Stephan', 'Walsh', 'f302f63f452ce3bbb85d464390db1be528bf4ae0', 'lenora.vonrueden@example.net', '384001711099');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('26', 'Bessie', 'Collier', 'd8d79c21bc391c90135b34b715fbe1b2fafa9169', 'stracke.mariane@example.net', '381898025050');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('27', 'Bethany', 'Bartoletti', '9628d8e1fa41a900b530e5c54d2826bc45529f17', 'do\'keefe@example.org', '384284013542');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('28', 'Elta', 'Abernathy', '0da26935998824ea77abd05420a3418acf73eaed', 'oparisian@example.org', '388618863429');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('29', 'Amelia', 'Cremin', '6bb90217222fbbc24e2c8248cad64abb0153c7b9', 'lamar.becker@example.net', '385618356568');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('30', 'Theresa', 'Mills', 'fbc76c869d774b49fbb6ab8bb76baabb634d86e6', 'ngreenfelder@example.com', '389285994521');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('31', 'Pearl', 'Lang', 'b0d97abe6958a72266462a0abaa9f98b304126b0', 'allan.kuphal@example.net', '386929540471');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('32', 'Darwin', 'Stokes', '68e5f3aed7cb84493b9cfd1500bb6d55c9ad3ba0', 'tevin27@example.org', '380632460247');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('33', 'Romaine', 'Russel', 'ac55fac3a50187b0df20c459aec2ef1e3d2100d9', 'aortiz@example.com', '388741475781');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('34', 'Darrion', 'Maggio', 'fe1755735be0774688383ef39f356a9dbdbcec6b', 'walter.chesley@example.net', '387065769969');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('35', 'Marielle', 'Bartell', '6c2c57c13b1d786f7e8d45be98edad01dbcbcff4', 'baumbach.zaria@example.net', '387685018312');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('36', 'Kareem', 'Schmeler', '7e80b7c4d5c58c6c5b2c85ac288f0722c4e77a1b', 'ricky14@example.net', '385503787882');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('37', 'Filomena', 'Spinka', '660e310dd6e3c118998e63ef94a70d20f500d912', 'fbecker@example.org', '388723981315');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('38', 'Cathrine', 'Wunsch', '28dd5a7964105a3bf5861963188d2ed9dc117e93', 'pmonahan@example.com', '385767580168');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('39', 'Karelle', 'Powlowski', '1783512ee649a14e76cac71d2f3b3f3f9bd4ed7a', 'mccullough.casimer@example.com', '382492559603');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('40', 'Francisca', 'Lang', 'ac3f830e9eae00e8218fb82a2f42d1460f9215fb', 'estrella.hermann@example.net', '384346204469');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('41', 'Rubye', 'Ebert', '82ce6891c02d161ef7e0e634da5e07e41dea0ae2', 'mbode@example.net', '383131830389');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('42', 'Raina', 'Cremin', '93c8a107ba52dac103d0c2a0bf024ba461a5babf', 'charity.luettgen@example.org', '381155166267');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('43', 'Braden', 'Tromp', 'a74ff1af6972baf57a689ea26cf48427e471cb9e', 'orlando.halvorson@example.net', '387861960842');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('44', 'Noah', 'Rath', 'dc93567a40469c80399a71429098be461a6de42a', 'crooks.nakia@example.net', '387669624509');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('45', 'Kyle', 'Renner', 'cd8a5687ca7bb6fce5d39459ac97f18dc553c26f', 'stacey57@example.com', '385324777089');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('46', 'Delphia', 'Hyatt', '09ec4a669164f1c995d6273dbc0f9d3b0c9dbb8c', 'zeichmann@example.com', '388399145021');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('47', 'Bradly', 'Wunsch', '6a480b60a25f9bed93d4e90268b9bb61641f1f2a', 'wnikolaus@example.org', '382971148383');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('48', 'Madalyn', 'Nitzsche', '7f92f6b356c210ac4c87136c7e649ec276e5d485', 'jerad.conroy@example.net', '382606257400');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('49', 'Curt', 'Raynor', 'e629ed8b530215dbfbc6ef463240b07bf61f907e', 'zane91@example.org', '386814548145');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('50', 'Elmore', 'Schmeler', '0a708b19da0973473023b376eca723b64f3d6164', 'edgardo.mueller@example.net', '385096375886');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('51', 'Talia', 'Auer', '0312140c877ac0d5821c79fe33b32b20104a3619', 'nrempel@example.net', '381891075982');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('52', 'Dedrick', 'Hermiston', 'ef911fdf654812f41ff7cc68a7266a148485644e', 'sydni02@example.com', '386603076485');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('53', 'Aurelie', 'Bechtelar', '776063fb46257f7529af33b00acbb5fd6aa3d6dc', 'grutherford@example.net', '389817386763');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('54', 'Elliott', 'Larson', 'a2fbf5e9cf7ea078e66412fc81d5aeb590346079', 'stracke.ardith@example.net', '383934060437');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('55', 'Cordie', 'Prosacco', '388b4e492ead4b0b11c45278c0ae6f52ae680721', 'stracke.ron@example.net', '383245277921');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('56', 'Heloise', 'Harber', '19b50ea25c117f5eb3e4a26449ee2ff8a0e11a65', 'aufderhar.archibald@example.org', '383532864376');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('57', 'Clement', 'Donnelly', '027c815703952c8289f69d9c525f6ac80538a722', 'murphy.ona@example.net', '387650985950');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('58', 'Jared', 'Blanda', '9ee1d3663134d5be942c5d05351cb18356890054', 'plesch@example.net', '380420284317');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('59', 'Rodger', 'Nader', 'aa8ba0e19191713f037d2a33b62fe0a4d8a66e4d', 'blebsack@example.net', '388768620360');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('60', 'Kitty', 'Bergnaum', 'fcb6d7fc8b4b1a74496808e2d86fea8c18272994', 'koss.schuyler@example.com', '382117518726');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('61', 'Zoila', 'Prohaska', '5f023abb9fc7cf5aaf5e9bc963030aeb90782ab8', 'ward.eriberto@example.net', '389815315101');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('62', 'Alaina', 'Johns', '738822211b9fbef04c89db5aaa9ae38cd407162d', 'tmorissette@example.org', '380617485018');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('63', 'Mabelle', 'Kirlin', 'fa07505cb8e1d90f76fa00b29326e297b19e4596', 'ilene49@example.net', '388913838136');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('64', 'Sonny', 'O\'Reilly', '6aa6572ad106ddd92693602bbc1b84b7e5f44510', 'gdeckow@example.com', '380646128649');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('65', 'Oscar', 'Quigley', '6deccaaca281bde041947aa4edd7142e5ed299bf', 'xcartwright@example.org', '382183980690');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('66', 'Wilfrid', 'Dickens', '6cbb5d56f58470f27360147e31b8673bfc55b381', 'hane.kavon@example.com', '389732116609');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('67', 'Jayden', 'Sanford', '0e5917dc0ef656a8e078fd7c4365f67334269d4f', 'thiel.mckenzie@example.org', '386890831105');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('68', 'Manuela', 'Stamm', 'c75c72b18d30e557be4458546124d9ab71d17744', 'xhegmann@example.net', '382927054204');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('69', 'Maxwell', 'Grady', '7894a6f1f713cb111f1c3c020c8673ebeaf4e147', 'abshire.ezekiel@example.com', '385475467569');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('70', 'Rowan', 'Dooley', '8d2c324718f2dd7c51fa5a5bd615a8b008b3b5ec', 'ubaldo12@example.com', '380285131894');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('71', 'Rebeca', 'Littel', 'bd120fb16861b1e5648fe9aff1af34dff278ce4d', 'sallie39@example.org', '387657846417');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('72', 'Jaeden', 'Towne', 'e1f8574aeb504350a4afdf92011e1578d441ffc7', 'kayleigh82@example.org', '383598902653');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('73', 'Dena', 'Mertz', '1548afc9772db36aa7800badc607797b0a54c7f3', 'naomie.osinski@example.net', '385724877263');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('74', 'Vivienne', 'Reichert', '0e10b9b518e197f8b988cb8a138d987e93f36627', 'jolie.blanda@example.net', '387357894643');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('75', 'Lazaro', 'Hoppe', 'fe0085313c635636612f53a72fafc9e42c0b930c', 'adolfo19@example.com', '389178242930');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('76', 'Harley', 'Roberts', '362faaa7216c1595f1c66676012756f4e7e9aff7', 'muller.kiana@example.com', '388956642961');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('77', 'Roel', 'Tillman', 'c5aee9c0a8ea8bd947ff41d9eb8eefaec5b1c01b', 'uarmstrong@example.org', '383170891278');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('78', 'Cristina', 'Franecki', '07721e96e7b65f828ad30f2feb16ebf93a0d1de8', 'dicki.ella@example.org', '386834457074');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('79', 'Elliot', 'Armstrong', '83218e53962380670222f505e6c4a0b552d5fca6', 'wfisher@example.org', '388645882173');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('80', 'Nina', 'Zboncak', '347ce09acbdd2b4e67af87d5a8b1e5a45e0b2ce8', 'mkoelpin@example.com', '384196497844');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('81', 'Eric', 'Reichert', '9fa44dabdd9afbd755bc6d933c43f26cb715ef85', 'rolando.wolff@example.net', '380954257408');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('82', 'Rick', 'Moen', '032c7074ce1b5e67030d7dc0de1932ae34cb7690', 'uschoen@example.com', '381023359159');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('83', 'Emmy', 'Barton', '861685a4116f3fd98c27206496e9ee9363048601', 'nicholas86@example.com', '380802941774');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('84', 'Elna', 'Abbott', '407b5481e8f7df5dc9b8fc7676c44c8bd8d263f9', 'rashawn86@example.org', '382119082757');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('85', 'Selmer', 'Weber', '1750a58608b425e2c76f927417cac7e3e65c1505', 'koch.mohammed@example.org', '388574456041');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('86', 'Serenity', 'Osinski', '887e1f0a47c90877d661ed240d01a23f901ffd82', 'gluettgen@example.com', '386130878636');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('87', 'Kendrick', 'Beatty', '5af2b261a8013d72a3f768fc14afb54511162276', 'gretchen19@example.org', '380059460131');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('88', 'Aylin', 'Balistreri', '9d3b2587c7cd9a6d2f0a3eb2ae3af64ccc93dbf0', 'sid.weber@example.org', '380410279799');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('89', 'Kristofer', 'Jacobi', '048e0e06d024e14bff2740dfe63bf021314f837c', 'emmanuel.murphy@example.net', '387270817630');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('90', 'Heloise', 'Pfeffer', '9893bfc1e18974537e067ad0cb7004a505a8ec09', 'qdicki@example.com', '383197190663');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('91', 'Zelda', 'Johnson', 'ce5aa6aac3dbec4ad8f3eee2e3ec6f4061623a48', 'pokuneva@example.org', '386420661704');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('92', 'Frida', 'Volkman', 'f5e50249cad2c5d3ccb2c0b1cdeb3b68ca77b5eb', 'abernathy.alysha@example.org', '382503258627');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('93', 'Everett', 'Rodriguez', '262c4aabb5d09374d4e59db23e487d76c03788ec', 'heaven.borer@example.org', '387990180095');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('94', 'Lester', 'Zemlak', 'b6fe6015ab007e6ed40070f2ee95866159f6f218', 'bryce.jenkins@example.net', '386956617920');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('95', 'Jordon', 'Dickinson', '69d4bd558d05d263be33283a0b486a548c10870b', 'casper.gus@example.com', '385683276695');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('96', 'Hester', 'McLaughlin', 'a61b6d02abe8e4c4fc79f208e2cce70fe18d143f', 'fwatsica@example.org', '388726012050');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('97', 'Samanta', 'Rowe', 'b82c2dd8578e73ed9724c9b99064dfbd3411f728', 'greenholt.roel@example.org', '386301787993');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('98', 'Golden', 'Roberts', '74d9bb2947d1620274eb60881452a731efc383af', 'reynolds.lauriane@example.net', '381418346962');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('99', 'Vita', 'Cassin', 'eabd69bbbfeee5ef4c5025d8b72ad575f5795e0d', 'maxine.connelly@example.org', '388753736969');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `password_hash`, `email`, `phone`) VALUES ('100', 'Cordia', 'Monahan', 'e09e7ea5a036c825dc0742d5c19f767b26aab36c', 'frami.gloria@example.com', '381127839293');

INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('1', 'veritatis', 201, '1', 'Reiciendis et cumque architecto qui sequi quis illum. Ut vero totam ut voluptates ut tempora. Maxime laboriosam voluptatem molestiae. Aut voluptatem labore dolorem id voluptatem iure.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('2', 'qui', 202, '2', 'Sed voluptas optio vel libero sunt amet. Quod voluptate quisquam ullam sapiente corrupti ad cum repellendus. Aspernatur tempora aut molestiae pariatur dolor. Nihil adipisci tempore deleniti temporibus illo qui veritatis.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('3', 'adipisci', 203, '3', 'Enim rem consequatur accusantium et iste unde. Excepturi non qui dolor.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('4', 'eum', 204, '4', 'Aut non ea sunt fugiat. Ut incidunt qui accusantium.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('5', 'impedit', 205, '5', 'Et dolorem rerum exercitationem rem. Commodi facilis et reiciendis maxime vel tenetur. Maxime eos sit est vel qui repellat rem. Voluptas voluptatibus rerum mollitia et aut perspiciatis odit tenetur. Non inventore ut excepturi tenetur.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('6', 'dolores', 206, '6', 'Dolore dolor molestiae laudantium. Et dolorem consequatur libero eos. Eius non velit est sint sed asperiores qui omnis.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('7', 'eligendi', 207, '7', 'Asperiores placeat consequatur omnis quis. Corporis libero error repudiandae optio qui consectetur. Voluptatibus non ut atque consequatur. Rerum earum alias eveniet vitae omnis.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('8', 'eveniet', 209, '8', 'Provident consequatur aut perspiciatis beatae. Accusantium magnam voluptatem deleniti modi nam omnis officia deleniti. Quae esse non tempora placeat sed voluptatum. Non ad dolore debitis aut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('9', 'ea', 211, '9', 'Mollitia qui ea quis consequuntur quasi asperiores. Animi mollitia officia quae. Saepe consectetur sit officia tenetur est voluptatum et occaecati. Vel vel et qui voluptas esse est aperiam.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('10', 'labore', 212, '10', 'Aut et corporis non consectetur. Inventore amet a ut harum est. Id neque atque aut. Consectetur nemo voluptate quis eaque asperiores accusamus eveniet quo.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('11', 'rem', 214, '11', 'Nihil quo quaerat quia delectus. Veniam pariatur dolores ex magni quia fugiat nihil. Molestiae qui dolor rem in repudiandae animi. Ut delectus nesciunt illo culpa dolore.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('12', 'ut', 215, '12', 'Odit quae id quia. Consectetur quidem voluptatem omnis totam dolorem. Quas et aut voluptatem omnis et dolorem est.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('13', 'ipsum', 219, '13', 'Voluptatem qui et culpa non perferendis. Qui impedit maxime quia aliquid et. Sit quam sit asperiores voluptas provident repellat quia.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('14', 'quibusdam', 220, '14', 'Est error deleniti et nobis similique dolores voluptas. Ea provident adipisci cupiditate suscipit quasi. Vel expedita tempore nihil at possimus repudiandae.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('15', 'laudantium', 224, '15', 'Praesentium doloremque non et nostrum et illo sit officia. Eaque sit tenetur aliquam quam dolor eaque nihil. Dicta autem itaque reiciendis non ea eligendi in aut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('16', 'laborum', 225, '16', 'Nobis aut ut facilis. Suscipit soluta ipsum numquam sit ab. Dolor hic dolor numquam facilis dolores facilis natus. Laudantium alias dolorum doloribus esse.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('17', 'neque', 233, '17', 'Qui eum neque nulla incidunt neque sunt adipisci. Ea et dolorum necessitatibus illo expedita expedita. Asperiores sit aut beatae. Cum rerum autem id.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('18', 'est', 234, '18', 'Sed nemo dolores ullam modi hic aut aut. Quod corrupti sed maiores voluptatem.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('19', 'omnis', 235, '19', 'Laudantium nesciunt quia odit ex quibusdam aliquam voluptas. Quaerat at qui eius nisi porro et. Voluptates dolor rerum cupiditate nam rerum deleniti. Omnis consequuntur dolores ipsum accusantium illo dicta ipsam architecto.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('20', 'quasi', 237, '20', 'Vitae nobis dolores ullam quaerat debitis totam. Voluptas non ducimus mollitia earum. Facilis nemo illo quis corrupti aut quasi quisquam. Possimus consequatur dolor velit nihil dolore debitis qui odit. Voluptatem nulla quia nulla qui incidunt veritatis alias.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('21', 'dolor', 238, '21', 'Deleniti distinctio minima repellendus consequatur. Ipsum autem recusandae nihil vel doloribus tempore.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('22', 'et', 239, '22', 'Praesentium perspiciatis quia laboriosam quia modi accusantium unde. Dolor numquam nostrum tenetur consectetur labore suscipit est. Nam ducimus maxime facilis consequuntur recusandae ut. Atque quis esse omnis.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('23', 'alias', 241, '23', 'Id dolorem ea delectus nam qui aut sapiente. Quod error id qui rerum. Omnis sequi consequatur voluptates eos sapiente qui. Rerum adipisci omnis ex illum eos sequi incidunt.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('24', 'maxime', 243, '24', 'Placeat numquam beatae reiciendis ut totam. Unde et nihil non omnis est enim nihil. Sed atque porro eum sequi.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('25', 'quis', 244, '25', 'Natus perspiciatis eius accusantium voluptatem aut aperiam. Maiores earum aperiam nihil consequatur nulla. Ipsa maxime et voluptas sint suscipit eveniet.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('26', 'nisi', 252, '26', 'Cum fugit delectus cupiditate omnis laudantium exercitationem rerum. Ipsam molestias inventore neque odit provident rerum. Sit accusantium quae similique rerum.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('27', 'voluptatem', 254, '27', 'Reprehenderit eaque cum non autem qui soluta. Et esse voluptas consequuntur reprehenderit qui dolor. Ratione qui veritatis neque pariatur animi. Qui repellendus ab dolorem porro repellat. Est id molestiae minima quos.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('28', 'non', 263, '28', 'A esse aut aut eum. Mollitia sed qui reiciendis nam ducimus vero. Id officiis sunt velit nulla et ratione molestiae. Natus eaque ducimus eligendi omnis nesciunt laboriosam ex voluptatem.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('29', 'sint', 266, '29', 'Qui rerum nostrum quia. Quia distinctio pariatur ab non placeat repudiandae. Voluptatum aut aut ipsa. Excepturi itaque id at dolor.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('30', 'quia', 268, '30', 'Quam et fugit iure omnis ad exercitationem. Ut ad cum veritatis atque amet et cumque.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('31', 'necessitatibus', 270, '31', 'Quia libero blanditiis aut molestias molestias quasi at. Laborum vero porro a itaque rerum cupiditate. Cumque quidem quas laudantium iusto doloribus. Dolor doloremque sequi voluptates quam commodi sint.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('32', 'dignissimos', 276, '32', 'Saepe illo minus et. Ut non totam adipisci est. Quidem veritatis quaerat iste aliquid iure sint. Explicabo vel consequatur repudiandae quam.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('33', 'reprehenderit', 283, '33', 'Aut ut odit occaecati doloremque fuga. Porro et dolores quia repellat doloribus magni nisi. Aspernatur velit voluptas voluptatem ut. Nihil corporis autem aliquid porro aperiam sit laborum.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('34', 'sed', 284, '34', 'Et quas qui fugiat neque. Cum aut quo rem ipsa rem aspernatur non omnis. Officiis culpa voluptatem qui voluptas sunt temporibus. Nemo qui incidunt sequi fugiat enim excepturi excepturi.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('35', 'minus', 285, '35', 'Ad consequatur ut officia perferendis ex iusto aliquid. Dolores maxime eaque voluptatum qui suscipit. Vel id soluta ipsam. Et iusto iure sed sit.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('36', 'sit', 293, '36', 'Voluptates sapiente enim aut dolorum perspiciatis ipsa ut. Earum iusto quia vitae corrupti blanditiis deleniti qui. Voluptas inventore et eligendi reiciendis repellendus odit suscipit. Explicabo dolores alias quia modi rerum ad.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('37', 'dolore', 294, '37', 'Reprehenderit molestiae non qui similique. Saepe doloremque optio aut quasi quas recusandae rerum aperiam.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('38', 'commodi', 298, '38', 'Ea voluptatum hic voluptates quo rerum harum harum. Perspiciatis voluptates vel fuga ipsam dolorem beatae tempora. Sed maxime est vel pariatur non.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('39', 'voluptates', 301, '39', 'Esse qui perferendis numquam labore inventore laboriosam. Sint qui explicabo quis fuga quis consectetur. Quod vero in qui. Harum aut quos libero repellendus quo.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('40', 'consectetur', 302, '40', 'Quasi sed fugit veritatis in. Ut cumque enim aut dolor qui aperiam temporibus. Consequatur nesciunt sapiente cupiditate est adipisci ut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('41', 'aut', 304, '41', 'Consequatur nihil est voluptas et eum corporis. At optio aliquam labore doloremque. Distinctio et tempore blanditiis voluptas velit.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('42', 'deleniti', 305, '42', 'Repellat deserunt sunt alias quis. Nisi molestiae rerum illum quia aut. Doloribus eos est architecto facilis.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('43', 'dolorem', 308, '43', 'Doloribus voluptate placeat autem sit. Non dignissimos qui tempore architecto facere.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('44', 'officiis', 311, '44', 'Labore minima sunt laborum possimus. Quae deserunt odio itaque sequi. Optio corporis quia ut quis. Nam sequi non atque ex dolore. Quis qui quas aut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('45', 'velit', 312, '45', 'Repudiandae reprehenderit eos quidem quod et. Placeat fugit est maxime nihil id. Quis nisi porro esse et dolore quod architecto. Error voluptate eius autem est beatae quibusdam quas aut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('46', 'mollitia', 316, '46', 'Quaerat necessitatibus mollitia nam dignissimos labore veniam. Incidunt odio officia voluptates quia soluta. Iusto facilis ducimus minus eum incidunt. Quia harum numquam minus sunt et repudiandae autem. Autem voluptatibus doloribus quos itaque aspernatur.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('47', 'at', 325, '47', 'Praesentium a atque cumque sit non vel dolores. Ea quasi ab ut ut. Voluptas tempore autem ut et.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('48', 'ex', 326, '48', 'Quisquam ipsam quis aperiam nesciunt ut nulla voluptatem. Quia reiciendis neque ipsam rem ipsam. Expedita quia id assumenda et eos ipsam. Labore aspernatur perferendis mollitia et.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('49', 'dicta', 329, '49', 'Commodi ad est voluptatem dolores molestiae et omnis. Totam ut aut consequatur temporibus. Sit iusto quos qui recusandae dolores cupiditate repellendus.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('50', 'nostrum', 333, '50', 'Incidunt dolores dolore ipsa nesciunt velit facere est. Repellat ad soluta accusantium voluptatum illum. Velit ex optio et similique perspiciatis.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('51', 'accusamus', 334, '51', 'Ipsam illo hic qui earum et assumenda voluptas. At consequuntur dolor similique earum. Possimus ut exercitationem ducimus voluptates et corporis. Ad occaecati fugit iusto temporibus nam soluta vitae.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('52', 'fugit', 336, '52', 'Debitis est debitis dolorem velit iusto qui fugiat. Possimus unde similique sed non. Aperiam et delectus iste consequatur deleniti. Error qui distinctio dolore nobis nemo consequatur.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('53', 'fugiat', 338, '53', 'Dolores labore et impedit vitae. Et aliquid qui maxime veritatis et. Eos enim omnis dolore laborum.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('54', 'accusantium', 340, '54', 'Qui voluptatem enim et pariatur recusandae adipisci veniam. Quis et tempora minus et totam a sunt deserunt. Quo deserunt consequatur voluptatem voluptas sequi non.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('55', 'nam', 343, '55', 'Et possimus quia sit. Odio quo reprehenderit dolorem alias nemo. Veniam sint ut molestiae sapiente provident. Magni sed consequatur voluptas vel.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('56', 'repellat', 344, '56', 'Eum iusto nam molestiae et eos soluta. Natus minus repudiandae tempora consectetur veritatis quia nemo aut. In autem repellat incidunt eaque quia dolorem. Ad nostrum quia quia tempora in eum nesciunt. Corrupti quia delectus et error inventore maxime aliquam.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('57', 'perferendis', 346, '57', 'Ipsum quia qui dolores nihil. Non facilis iste neque eius totam ea. In nulla eum ut ut aut rerum.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('58', 'in', 351, '58', 'Possimus sint culpa qui consequuntur doloribus velit. Qui voluptatem optio sit temporibus. Consequatur perspiciatis laboriosam soluta qui. Voluptate earum amet sint.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('59', 'voluptas', 353, '59', 'Illum repudiandae vitae optio debitis. Vel vero quia qui quia. Officiis inventore ratione vel quo facilis est nulla.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('60', 'sequi', 361, '60', 'Et consequuntur nulla cupiditate veniam ea. Et aut quisquam id. Voluptas totam eum dolor quae.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('61', 'ullam', 364, '61', 'Omnis quo architecto necessitatibus voluptatem deserunt quis. Nam quo sint rerum at animi molestiae. Consectetur molestiae molestiae nulla.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('62', 'molestias', 365, '62', 'Neque quia consectetur magni nulla tenetur. Est accusantium debitis vel nisi ipsum molestiae laborum eaque. Veritatis iste exercitationem et voluptatibus et.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('63', 'saepe', 375, '63', 'Eaque iure aut voluptatem tempora. Ut quis aliquam et veniam dolor harum. Mollitia nulla facere suscipit repellat. Sequi possimus qui eligendi et. Eius facere ut libero et molestiae voluptas vitae.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('64', 'cumque', 385, '64', 'Blanditiis dolores temporibus fugit laborum odio accusantium quasi. Reprehenderit ducimus quo ut recusandae cum. Ut mollitia quidem molestiae et. Deleniti eum harum accusamus sunt.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('65', 'vitae', 386, '65', 'Magni est omnis eaque perspiciatis. Excepturi velit minima voluptatem ipsa. Modi nulla assumenda fuga quo aliquid est et.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('66', 'natus', 388, '66', 'Aliquam nisi suscipit corporis qui recusandae iusto. Maxime aspernatur qui alias. Ipsam quia qui similique occaecati nam ut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('67', 'hic', 390, '67', 'Sed veritatis aliquam quis incidunt ut magni neque. Ullam quia laudantium illo et. Voluptas totam totam et qui hic.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('69', 'voluptate', 394, '69', 'Consectetur animi facilis rerum nostrum soluta quas perspiciatis. Aliquam odio velit mollitia consectetur. Suscipit voluptatibus quidem eaque voluptatem ex culpa.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('70', 'beatae', 397, '70', 'Similique illo libero et fugiat ut sunt adipisci laudantium. Deleniti sapiente ab rem adipisci aut fugit. Iure qui voluptatibus ea nisi hic libero. Itaque facere aut sed.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('71', 'eaque', 201, '71', 'Est nobis nisi corporis debitis ut. Vel ea tenetur neque qui molestiae. Ut pariatur dolore quis consequatur.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('72', 'ad', 202, '72', 'Unde deserunt ipsum enim atque. Error et consequatur sed velit aspernatur sint. Ducimus sapiente nam aliquid commodi consequatur nesciunt eos. Explicabo ad deleniti aspernatur temporibus.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('73', 'quod', 203, '73', 'Qui officia maxime et aut tenetur. Non temporibus nemo dolore quaerat omnis culpa ut hic. Fugiat repudiandae ut quisquam debitis. Quod voluptatum non quo sed aperiam.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('74', 'corrupti', 204, '74', 'Qui corporis officia vitae aliquid. Blanditiis in aut explicabo veritatis qui dolor fuga. Fuga eos ut blanditiis aliquam. Dolores nisi quo nostrum sapiente ullam quae voluptas.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('75', 'quaerat', 205, '75', 'Non enim quia consequatur ut distinctio est. Quia corrupti ut velit debitis ut cupiditate qui facere. Cumque ipsa est ut magni nisi eos adipisci.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('76', 'atque', 206, '76', 'Sunt vel suscipit ut ratione in similique. Recusandae tempora quia odit id. Eligendi numquam non in omnis. Aut aperiam nobis dolores nesciunt esse eligendi.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('77', 'assumenda', 207, '77', 'Eius laborum corporis nemo voluptatem illo. Facere porro delectus sed ut explicabo et. Dolorum laudantium quia facere explicabo.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('78', 'nihil', 209, '78', 'Ut perferendis est aspernatur ipsam provident. Sapiente quos eaque harum iure et. Voluptatem fugiat magni pariatur et dolores vel distinctio. Et sed ut et voluptatem facilis. Hic voluptatibus totam omnis rem minima et et.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('79', 'eos', 211, '79', 'Aliquam aliquam dolore maiores reprehenderit harum facilis. Est ut autem omnis explicabo possimus. Vitae unde et est mollitia esse dolorem. Nihil sequi laboriosam quae sit.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('80', 'quo', 212, '80', 'Voluptatem provident quasi amet odio fuga debitis id ea. Cupiditate modi et qui ipsam aspernatur nemo sed. Quia cupiditate sed quae sint.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('81', 'enim', 214, '81', 'Facere voluptas nulla assumenda aut vel ducimus qui. Ut tenetur quia facilis saepe. Numquam quia quia molestiae vel.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('82', 'maiores', 215, '82', 'Fuga autem dolorum quia et non non et minima. Nihil enim perspiciatis quia doloremque suscipit.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('83', 'aspernatur', 219, '83', 'Quis voluptas voluptatem et facere iusto et harum. Magni provident voluptas aut occaecati quo dolores unde. Est placeat et quis eaque dolorem consequuntur illum. Eos accusamus et corrupti maiores et temporibus.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('84', 'officia', 220, '84', 'Exercitationem expedita mollitia cum adipisci tenetur voluptates. Similique sapiente doloribus odit totam quisquam eum omnis vel. Sit at ea deleniti sapiente. Quae consequatur accusantium qui fugiat.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('85', 'animi', 224, '85', 'Reiciendis laborum magni odio. Molestiae deserunt quo molestiae doloremque reprehenderit. Explicabo occaecati qui vero sunt.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('86', 'expedita', 225, '86', 'Ex voluptatem ut dolorum aut. Inventore vel sint voluptatibus. Dicta nihil asperiores nam qui perferendis autem.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('87', 'doloribus', 233, '87', 'In perferendis sunt voluptatum blanditiis. Consequuntur nobis libero tempore voluptas. Est debitis qui modi sed. Sed quia inventore sapiente exercitationem.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('88', 'id', 234, '88', 'Omnis ut ratione suscipit perferendis iste molestias harum. Asperiores maiores qui aut fugit. Aut maiores consequatur nihil quisquam sed aliquam nemo. Explicabo earum perferendis et illum voluptatum corrupti alias provident.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('89', 'unde', 235, '89', 'Fugiat officia quibusdam placeat modi fugit dignissimos. Asperiores rem nihil corrupti quo. Placeat odit necessitatibus ut inventore sit magni.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('90', 'architecto', 237, '90', 'Blanditiis culpa eligendi repudiandae non aliquid incidunt suscipit. Iste sapiente ut ut. Cum quod reiciendis quia quo delectus. Doloremque qui quasi quo quia voluptatem. Voluptatem non ut autem ratione autem.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('91', 'debitis', 238, '91', 'Quia delectus optio beatae dolor fuga excepturi iure. Soluta quidem quidem magni enim et magni. Molestiae accusantium nesciunt deleniti iste non similique veritatis. Nesciunt doloremque quia dolorem ullam commodi eum magnam.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('92', 'recusandae', 239, '92', 'Fugiat quas dolores doloribus dolorum. Dolore velit laboriosam commodi error eos sint quaerat. Nam pariatur fugiat voluptatibus nesciunt voluptatem sed.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('93', 'asperiores', 241, '93', 'Ratione dolores dignissimos magni est nam qui corporis. Numquam error officiis eius voluptas. Voluptatum id non molestiae ad. Maxime sunt id nisi non.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('94', 'autem', 243, '94', 'Labore repellat a est ut eos nihil. Omnis aperiam quibusdam ex. Quia nihil saepe rerum ut ut similique.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('95', 'voluptatibus', 244, '95', 'Quidem libero et quasi. Excepturi saepe laborum assumenda aut cumque repellat veniam sequi. Possimus sunt soluta dolorem.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('96', 'tempore', 252, '96', 'Vitae praesentium commodi quod sequi reprehenderit labore. Dolorem repellat rem alias inventore maxime iste qui. Placeat omnis blanditiis quia voluptatibus rerum. Alias qui officiis omnis sit non voluptatibus maiores. Rem debitis autem eligendi aliquam.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('97', 'amet', 254, '97', 'Eum ut quisquam alias. Veniam sit cumque et quibusdam perferendis. Laboriosam qui dolores excepturi voluptatem occaecati maxime. Alias beatae soluta ut ad molestiae ut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('98', 'iste', 263, '98', 'Fugit ut mollitia deserunt nihil error ea. Est quo minima est eius mollitia voluptas accusantium cum. Consequuntur minus ipsam repellat doloribus vitae est ratione et.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('99', 'repellendus', 266, '99', 'Quis iste quam non magnam voluptate tempore iure. Omnis ut est laborum molestiae ea iusto quisquam. Consequatur quasi velit et voluptas. Est cupiditate molestias perspiciatis quae blanditiis. Mollitia incidunt enim libero minus amet ut.');
INSERT INTO `artists` (`id`, `artist_name`, `artist_country_id`, `artist_photo_id`, `description_artist`) VALUES ('100', 'libero', 268, '100', 'Iusto incidunt quod quam quos quia rerum non. Voluptas mollitia reprehenderit pariatur facilis eaque. Quas dolores architecto veritatis quibusdam numquam veniam non.');



INSERT INTO `genres` (`id`, `genre_name`) VALUES ('12', 'Art Punk');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('33', 'Alternative Rock');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('2', 'Grunge');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('39', 'Hard Rock');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('40', 'Indie Rock');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('5', 'Progressive Rock');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('16', 'Acoustic Blues');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('3', 'Blues Rock');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('34', 'Jazz');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('14', 'Piano Blues');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('11', 'Ballet');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('43', 'Classical');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('37', 'Symphony');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('49', 'Country');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('20', 'Christian Country');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('9', 'Progressive');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('8', 'Club Dance');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('29', 'Breakcore');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('18', 'Dubstep');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('47', 'Speedcore');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('38', 'Hard Dance');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('15', 'House');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('6', 'Electro House');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('17', 'Rave Music');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('22', 'Vocal House');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('27', 'Detroit Techno');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('23', 'Technopop');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('26', 'Trance');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('1', 'Lounge');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('45', 'Swing');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('24', 'Ambient');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('42', 'Drumfunk');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('10', 'Drumstep');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('50', 'Electro');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('7', 'Acousmatic Music');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('13', 'Electroacoustic Improvisation');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('46', 'Live Electronics');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('41', 'Freestyle Music');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('32', 'Electronic Rock');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('31', 'Alternative Dance');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('36', 'Dance-Rock');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('25', 'Dance-Punk');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('48', 'New Bea');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('30', 'Trip Hop');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('28', 'British Folk Revival');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('44', 'Industrial Folk');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('35', 'Techno-Folk');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('4', 'Christian Hip Hop');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('19', 'Christmas: Pop');
INSERT INTO `genres` (`id`, `genre_name`) VALUES ('21', 'J-Rock');

INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('1', 'Deserunt ut ea necessitatibus voluptatum qui eos a', '1', '1');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('2', 'Voluptatem perferendis reiciendis et sapiente in q', '2', '2');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('3', 'Accusantium rem dolor corporis eveniet repellat.', '3', '3');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('4', 'Optio minima omnis facere tenetur et.', '4', '4');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('5', 'Delectus non quos ratione.', '5', '5');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('6', 'Amet voluptate minima libero et voluptatem aut vol', '6', '6');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('7', 'Et voluptatum tenetur sapiente expedita.', '7', '7');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('8', 'Libero consequatur odit possimus itaque beatae vol', '8', '8');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('9', 'Doloremque possimus sed ab.', '9', '9');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('10', 'Id est animi quas numquam ad eos.', '10', '10');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('11', 'Nisi in sapiente non ipsam amet.', '11', '11');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('12', 'Fuga eius et libero corporis.', '12', '12');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('13', 'Et ut esse hic et.', '13', '13');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('14', 'Ullam eius optio molestiae repudiandae dolorem.', '14', '14');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('15', 'Qui in explicabo quia voluptatem earum aut.', '15', '15');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('16', 'Aliquid similique velit impedit illo alias fuga no', '16', '16');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('17', 'At numquam quae voluptas debitis quibusdam ut quia', '17', '17');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('18', 'Nesciunt velit explicabo laboriosam aperiam explic', '18', '18');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('19', 'Ut et et doloremque neque earum consectetur quibus', '19', '19');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('20', 'Nemo et voluptas libero recusandae.', '20', '20');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('21', 'Consequatur ut autem placeat ex id tempora sint.', '21', '21');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('22', 'Eum voluptatem debitis dolorem nihil.', '22', '22');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('23', 'In veniam rem explicabo reprehenderit et voluptas ', '23', '23');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('24', 'Magni tempore animi atque dolores aut est aut.', '24', '24');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('25', 'Amet alias dolor error illum sapiente ducimus.', '25', '25');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('26', 'Rem aut accusamus rerum doloremque temporibus.', '26', '26');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('27', 'Odio qui sequi voluptatibus voluptas voluptatum do', '27', '27');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('28', 'Possimus voluptatem quasi quidem.', '28', '28');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('29', 'Esse non odit repellendus nemo.', '29', '29');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('30', 'Et in autem nisi accusantium.', '30', '30');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('31', 'Voluptatum laboriosam neque consectetur explicabo.', '31', '31');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('32', 'Quas quis voluptas labore et magnam.', '32', '32');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('33', 'Et nam asperiores et aut nostrum eum assumenda mag', '33', '33');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('34', 'Aspernatur quisquam non ut aut.', '34', '34');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('35', 'Harum sunt consectetur fugiat corrupti occaecati.', '35', '35');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('36', 'Vitae minima voluptates perspiciatis ut ut veniam.', '36', '36');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('37', 'Alias dicta doloremque ad eos et unde aut.', '37', '37');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('38', 'Autem consequatur consectetur alias delectus.', '38', '38');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('39', 'Eius quam qui expedita reiciendis architecto autem', '39', '39');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('40', 'Dolorem non aliquam commodi laborum expedita vel.', '40', '40');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('41', 'Quia fugiat velit fugiat dignissimos provident ess', '41', '41');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('42', 'Dolorem voluptas debitis asperiores rerum.', '42', '42');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('43', 'Eum sequi et et enim.', '43', '43');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('44', 'Neque explicabo commodi id deleniti.', '44', '44');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('45', 'Et aliquam est quisquam.', '45', '45');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('46', 'Modi accusamus alias ut sit sed quidem vel.', '46', '46');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('47', 'Provident eum aut veritatis animi repudiandae.', '47', '47');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('48', 'Magni nostrum in et vitae rerum consequuntur volup', '48', '48');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('49', 'Magnam itaque adipisci aperiam voluptatum ut non.', '49', '49');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('50', 'Adipisci totam perferendis nisi quas.', '50', '50');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('51', 'Vero eaque rerum consequatur officiis ea praesenti', '51', '51');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('52', 'Molestias non qui tempora in dolorum quod libero i', '52', '52');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('53', 'Dolorem officiis eligendi dolores deleniti amet se', '53', '53');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('54', 'Eligendi eveniet illo molestiae ipsam eum in beata', '54', '54');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('55', 'Quos nihil sed eum inventore.', '55', '55');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('56', 'Maxime soluta quam labore.', '56', '56');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('57', 'Corporis enim adipisci tempora minima.', '57', '57');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('58', 'Dolore ut est nihil sunt.', '58', '58');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('59', 'Est et impedit tempore sed neque vero quaerat ipsa', '59', '59');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('60', 'Ab et voluptas omnis saepe iste omnis.', '60', '60');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('61', 'Sit at sed ullam tenetur aut.', '61', '61');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('62', 'Nisi vero animi quia.', '62', '62');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('63', 'Officia commodi ipsa est ratione maiores amet quis', '63', '63');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('64', 'Quis placeat cum exercitationem sequi sequi molest', '64', '64');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('65', 'Hic placeat fuga mollitia porro sit odio enim.', '65', '65');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('66', 'Labore quam id laboriosam.', '66', '66');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('67', 'Vel delectus molestias optio occaecati ratione ut ', '67', '67');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('69', 'Reprehenderit dolores dolore laborum quae ea.', '69', '69');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('70', 'Consequatur ab vero cupiditate rerum.', '70', '70');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('71', 'Maxime quia voluptatum maiores voluptas et repelle', '71', '71');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('72', 'Aut ipsum quasi odio mollitia aliquid.', '72', '72');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('73', 'Sed adipisci recusandae voluptatem non repudiandae', '73', '73');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('74', 'Qui aut dolor labore ut velit.', '74', '74');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('75', 'Est unde nihil odio qui eum modi et.', '75', '75');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('76', 'Voluptatum quae voluptatem iure minus fugiat unde ', '76', '76');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('77', 'Et rem sed id et ducimus.', '77', '77');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('78', 'Magni qui qui voluptatem perspiciatis aut.', '78', '78');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('79', 'Et mollitia ea molestiae nihil voluptate soluta di', '79', '79');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('80', 'Laboriosam placeat dolorem ullam.', '80', '80');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('81', 'Harum dolor facere consequatur non veritatis fuga ', '81', '81');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('82', 'Nam saepe voluptatem facilis ipsam odit at.', '82', '82');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('83', 'Qui repellat eos aut voluptatem ipsam id accusamus', '83', '83');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('84', 'Omnis illum sit itaque odit ullam provident.', '84', '84');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('85', 'Qui sed neque itaque delectus quia ipsa eveniet.', '85', '85');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('86', 'Dolor odit quia cum laborum quia.', '86', '86');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('87', 'Molestiae cumque eligendi omnis modi.', '87', '87');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('88', 'Placeat dolore soluta facilis.', '88', '88');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('89', 'Rerum et vel voluptatibus provident.', '89', '89');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('90', 'Sed facilis est saepe et officia.', '90', '90');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('91', 'Reprehenderit at incidunt nulla mollitia.', '91', '91');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('92', 'Eveniet ipsum quae dolorem ipsam quae itaque ipsa.', '92', '92');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('93', 'Natus aperiam est molestiae qui itaque itaque aut.', '93', '93');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('94', 'Velit molestiae enim dicta sunt et.', '94', '94');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('95', 'Nam et ut voluptas iusto error quibusdam molestiae', '95', '95');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('96', 'Ab tempore occaecati et ut magnam ducimus qui.', '96', '96');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('97', 'Ut delectus repudiandae voluptates repellendus sap', '97', '97');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('98', 'Vitae ullam aspernatur a.', '98', '98');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('99', 'Incidunt consequuntur sapiente doloribus exercitat', '99', '99');
INSERT INTO `albums` (`id`, `album_title`, `artist_id`, `almum_photo_id`) VALUES ('100', 'Voluptatem et omnis repellat sit aut.', '100', '100');



INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('1', 'm', '1', 1, '1990-07-24 01:53:19');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('2', 'm', '2', 0, '2001-11-11 13:00:50');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('3', 'm', '3', 0, '2020-07-04 15:09:50');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('4', 'f', '4', 0, '2013-07-17 10:56:58');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('5', 'm', '5', 0, '2020-05-21 05:25:50');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('6', 'f', '6', 0, '1978-12-26 00:15:30');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('7', 'm', '7', 1, '1986-08-19 12:04:42');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('8', 'm', '8', 0, '1995-05-20 16:59:20');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('9', 'm', '9', 0, '1972-09-10 22:19:30');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('10', 'm', '10', 0, '1976-01-29 19:24:54');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('11', 'm', '11', 0, '2020-08-01 10:28:20');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('12', 'm', '12', 0, '2007-09-26 22:40:05');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('13', 'f', '13', 0, '2002-12-05 04:41:26');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('14', 'm', '14', 0, '1996-07-08 21:04:19');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('15', 'm', '15', 0, '1994-07-12 05:49:42');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('16', 'm', '16', 1, '1972-06-20 14:20:00');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('17', 'f', '17', 0, '1985-06-30 22:29:48');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('18', 'f', '18', 0, '1997-04-17 04:10:15');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('19', 'm', '19', 0, '2017-07-17 07:16:38');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('20', 'f', '20', 0, '2018-06-15 03:53:43');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('21', 'm', '21', 0, '1989-09-25 07:41:33');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('22', 'f', '22', 0, '1987-02-28 05:31:05');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('23', 'f', '23', 1, '1979-09-02 17:43:15');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('24', 'f', '24', 1, '1971-07-24 08:46:53');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('25', 'f', '25', 1, '1991-11-07 14:54:54');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('26', 'm', '26', 0, '1998-04-05 18:45:49');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('27', 'm', '27', 1, '2014-02-20 18:12:24');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('28', 'm', '28', 0, '2003-01-27 21:06:08');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('29', 'f', '29', 1, '2005-10-04 07:15:02');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('30', 'f', '30', 1, '1984-08-07 01:33:51');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('31', 'm', '31', 1, '1996-11-05 04:08:10');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('32', 'm', '32', 1, '1975-03-31 22:46:08');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('33', 'm', '33', 1, '1983-11-01 02:59:39');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('34', 'f', '34', 1, '1985-04-21 11:13:06');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('35', 'm', '35', 1, '1997-06-10 22:10:07');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('36', 'm', '36', 0, '1978-08-14 07:43:34');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('37', 'm', '37', 0, '1972-03-29 13:55:04');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('38', 'm', '38', 1, '1988-12-28 19:52:40');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('39', 'm', '39', 1, '1976-11-30 09:35:38');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('40', 'f', '40', 0, '2005-04-11 11:10:56');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('41', 'f', '41', 0, '2000-09-02 07:19:29');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('42', 'm', '42', 1, '1977-10-12 22:21:12');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('43', 'm', '43', 1, '2009-09-27 21:57:14');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('44', 'm', '44', 0, '1999-09-24 15:49:10');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('45', 'm', '45', 1, '1977-01-28 08:52:26');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('46', 'f', '46', 0, '1984-09-05 03:02:38');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('47', 'm', '47', 0, '1989-11-13 04:20:52');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('48', 'f', '48', 0, '1971-12-11 19:03:24');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('49', 'f', '49', 1, '2007-10-05 03:43:51');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('50', 'm', '50', 1, '1989-04-04 19:32:47');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('51', 'm', '51', 0, '1975-07-15 02:16:19');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('52', 'm', '52', 1, '2000-08-19 22:56:46');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('53', 'm', '53', 0, '1985-02-09 05:23:07');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('54', 'm', '54', 0, '2017-08-15 08:56:53');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('55', 'f', '55', 1, '2012-03-15 11:39:02');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('56', 'm', '56', 0, '2005-03-15 00:26:12');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('57', 'm', '57', 1, '1996-08-27 14:35:43');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('58', 'm', '58', 1, '2018-05-22 23:19:26');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('59', 'm', '59', 1, '2000-11-11 09:59:58');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('60', 'f', '60', 0, '1977-02-19 20:17:37');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('61', 'm', '61', 0, '2018-05-22 23:35:06');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('62', 'f', '62', 0, '1998-09-27 16:44:48');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('63', 'm', '63', 0, '1980-08-28 20:45:09');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('64', 'm', '64', 1, '2020-03-29 19:39:14');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('65', 'm', '65', 1, '2003-09-18 00:14:02');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('66', 'm', '66', 0, '1974-04-22 12:24:48');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('67', 'm', '67', 1, '2013-03-20 17:08:37');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('68', 'm', '68', 1, '1995-04-12 03:27:37');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('69', 'f', '69', 1, '1980-02-11 01:50:54');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('70', 'f', '70', 1, '1995-02-08 15:00:55');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('71', 'f', '71', 1, '1991-01-10 05:44:40');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('72', 'm', '72', 1, '1986-02-19 08:51:54');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('73', 'f', '73', 1, '1984-07-18 20:49:34');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('74', 'm', '74', 0, '1998-03-10 22:46:24');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('75', 'f', '75', 0, '1982-03-18 20:01:50');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('76', 'm', '76', 1, '2012-05-31 08:33:13');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('77', 'f', '77', 1, '2011-11-14 01:59:44');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('78', 'm', '78', 0, '2013-05-19 06:31:38');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('79', 'f', '79', 0, '2011-09-02 22:07:57');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('80', 'f', '80', 0, '1996-06-08 10:48:42');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('81', 'f', '81', 0, '1985-02-13 18:49:00');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('82', 'f', '82', 1, '1988-02-26 22:35:19');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('83', 'm', '83', 0, '1994-05-26 09:24:11');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('84', 'f', '84', 0, '2017-09-11 05:45:41');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('85', 'm', '85', 0, '1987-09-02 01:18:44');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('86', 'm', '86', 0, '1988-12-11 21:09:08');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('87', 'f', '87', 1, '1972-08-07 09:05:45');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('88', 'm', '88', 1, '1973-09-28 23:36:51');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('89', 'f', '89', 1, '1990-12-17 05:31:33');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('90', 'm', '90', 1, '1991-02-26 12:49:41');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('91', 'm', '91', 1, '2002-01-09 05:44:29');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('92', 'm', '92', 0, '2008-04-19 19:22:53');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('93', 'm', '93', 1, '2016-09-12 18:35:30');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('94', 'm', '94', 1, '1986-07-23 01:53:43');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('95', 'm', '95', 1, '2012-10-18 13:03:14');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('96', 'f', '96', 0, '2017-09-07 02:12:00');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('97', 'f', '97', 1, '2002-10-16 09:01:22');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('98', 'f', '98', 1, '2003-12-24 12:30:33');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('99', 'f', '99', 1, '1986-12-24 17:19:19');
INSERT INTO `profiles` (`user_id`, `gender`, `user_avatar_id`, `is_active`, `created_at`) VALUES ('100', 'f', '100', 0, '1994-04-05 18:06:12');


INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('1', 'http://www.streich.com/', 'Officiis hic cupiditate libero necessitatibus numq', '1', '1', '1', 201, '10:43:50', '1973-07-22 07:03:20', 'Impedit aspernatur accusantium doloribus illum et quaerat placeat omnis.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('2', 'http://www.lynch.biz/', 'Voluptatem pariatur ea magni consequatur.', '2', '2', '2', 202, '05:14:11', '2013-04-28 04:45:44', 'Autem quo sint praesentium distinctio assumenda.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('3', 'http://www.sawayn.info/', 'Laborum ratione non corporis fugiat consequatur fu', '3', '3', '3', 203, '12:27:23', '2016-09-13 18:04:47', 'Assumenda est cumque veniam occaecati.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('4', 'http://dickinson.com/', 'Optio illum quidem voluptatum impedit.', '4', '4', '4', 204, '06:37:52', '1981-03-31 03:32:45', 'Rem ex suscipit voluptates culpa est dignissimos.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('5', 'http://www.turner.com/', 'Ipsa qui ratione ab dolores.', '5', '5', '5', 205, '01:28:13', '1976-06-04 06:13:02', 'Nulla dignissimos temporibus consequatur quasi delectus quasi nemo corrupti.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('6', 'http://www.klein.com/', 'Ut consequatur mollitia rerum similique nobis volu', '6', '6', '6', 206, '14:41:11', '2016-10-15 05:48:27', 'Voluptatem sed soluta consequatur soluta.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('7', 'http://kris.com/', 'Autem et sint sint quia ut inventore.', '7', '7', '7', 207, '00:41:31', '1994-12-02 22:40:22', 'Pariatur vel molestiae explicabo aut molestiae libero optio.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('8', 'http://www.rippin.com/', 'Excepturi illum voluptatem sed necessitatibus quam', '8', '8', '8', 209, '04:39:33', '1997-01-14 19:28:14', 'Dignissimos natus in vitae quaerat perspiciatis.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('9', 'http://www.farrellboyer.biz/', 'Facilis ab sit et ut est eligendi.', '9', '9', '9', 211, '23:31:49', '2003-04-01 09:03:42', 'Ut omnis sunt sed aut.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('10', 'http://leffler.info/', 'Quod quos eaque quasi harum rerum placeat.', '10', '10', '10', 212, '09:35:09', '2015-12-07 09:09:03', 'Ipsam voluptas eligendi facere.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('11', 'http://fahey.com/', 'Dolorem sit reprehenderit quisquam est dolorum sed', '11', '11', '11', 214, '14:35:55', '2014-01-16 01:23:02', 'Impedit quo aut asperiores rem consequatur non.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('12', 'http://casper.com/', 'Est inventore magni maxime unde non at.', '12', '12', '12', 215, '21:27:53', '2014-10-21 18:03:53', 'Officiis unde facere blanditiis.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('13', 'http://www.ritchie.biz/', 'Et quidem quidem exercitationem sit.', '13', '13', '13', 219, '09:33:31', '1984-11-19 01:06:03', 'Nam placeat voluptates quis qui consequatur molestiae.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('14', 'http://morissette.com/', 'Dolores velit aperiam alias porro.', '14', '14', '14', 220, '03:42:00', '2005-01-22 10:48:29', 'Corrupti et quaerat aut tempore qui.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('15', 'http://heaney.org/', 'Libero veritatis illo deleniti aut.', '15', '15', '15', 224, '13:42:26', '1975-03-10 03:07:16', 'Sunt quo adipisci et dignissimos sed suscipit nemo nesciunt.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('16', 'http://www.adamskiehn.net/', 'Pariatur sunt qui quos eum.', '16', '16', '16', 225, '16:14:41', '2020-01-20 05:57:07', 'Cupiditate alias et qui laboriosam ut.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('17', 'http://www.barrows.com/', 'Blanditiis velit necessitatibus consectetur evenie', '17', '17', '17', 233, '16:13:29', '1986-06-13 08:06:14', 'Deleniti velit ut labore itaque non aut.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('18', 'http://www.nitzsche.com/', 'Placeat voluptatem fuga quas corporis sunt officia', '18', '18', '18', 234, '23:29:13', '2009-07-20 04:04:46', 'Quae eos exercitationem voluptatem odio.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('19', 'http://torproberts.com/', 'Harum adipisci consequatur reprehenderit repellend', '19', '19', '19', 235, '03:37:10', '2000-08-09 21:57:58', 'Non doloribus sit laboriosam ut eum.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('20', 'http://homenickernser.org/', 'Distinctio voluptates repellendus iusto.', '20', '20', '20', 237, '17:30:11', '1981-07-25 09:29:05', 'Necessitatibus occaecati eius error cum.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('21', 'http://murphy.biz/', 'In error quis fugit sed quo repudiandae ut amet.', '21', '21', '21', 238, '23:50:16', '1997-07-21 00:33:47', 'Ut expedita omnis cupiditate quos aperiam.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('22', 'http://gerhold.com/', 'Quo earum molestias beatae quidem.', '22', '22', '22', 239, '10:25:57', '1993-08-05 16:46:19', 'Nam sapiente repellendus ratione sequi rerum assumenda fugiat.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('23', 'http://framimarquardt.com/', 'Aut deserunt eveniet voluptatum quis aspernatur.', '23', '23', '23', 241, '03:26:30', '1996-11-01 20:23:47', 'Quis voluptatem consequuntur odit et.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('24', 'http://www.thompson.com/', 'Consequatur beatae quisquam non ea amet omnis.', '24', '24', '24', 243, '14:14:36', '2001-11-23 22:34:29', 'Dicta est et tenetur laudantium quaerat.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('25', 'http://www.sanfordmuller.com/', 'Placeat et fuga sit aut modi sequi.', '25', '25', '25', 244, '01:10:25', '2019-05-17 04:40:46', 'Accusantium non illo animi itaque possimus illum numquam quia.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('26', 'http://hettinger.com/', 'Quia qui laboriosam asperiores et fuga.', '26', '26', '26', 252, '08:10:54', '1977-08-06 14:15:49', 'Ut et voluptatum sed.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('27', 'http://howellkutch.com/', 'Voluptatem repellat enim blanditiis omnis placeat ', '27', '27', '27', 254, '21:01:18', '1973-11-20 03:14:07', 'Vel quaerat dignissimos minus officia.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('28', 'http://www.herzogborer.com/', 'Magni eum ipsa velit corporis adipisci recusandae ', '28', '28', '28', 263, '20:06:39', '1998-02-03 01:32:49', 'Expedita sequi quia cum earum voluptas.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('29', 'http://www.goodwinhammes.com/', 'Nobis amet et nemo aperiam.', '29', '29', '29', 266, '20:13:28', '2007-10-07 10:11:33', 'Veniam quos et velit et deleniti et dolor.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('30', 'http://wehner.net/', 'Vero iusto aliquid autem est veniam et at dolorum.', '30', '30', '30', 268, '02:54:32', '1987-09-18 15:24:33', 'Atque ex in tempora neque qui sint.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('31', 'http://blanda.biz/', 'Id quo est non aut.', '31', '31', '31', 270, '14:12:44', '2017-07-16 20:24:11', 'Debitis id esse sapiente omnis est.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('32', 'http://buckridge.com/', 'Magni velit omnis culpa veritatis qui ut magni aut', '32', '32', '32', 276, '16:57:42', '2002-04-01 03:47:19', 'Magnam maiores quibusdam eum nisi sed.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('33', 'http://green.com/', 'Atque voluptas qui voluptatem porro nihil rerum po', '33', '33', '33', 283, '03:23:19', '1989-08-13 00:54:12', 'Sequi optio maiores eos beatae eius.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('34', 'http://ward.org/', 'Dolor assumenda laborum adipisci voluptates fuga s', '34', '34', '34', 284, '16:49:06', '2001-09-25 05:30:32', 'Vel ut labore voluptatibus amet alias doloribus repellat.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('35', 'http://www.effertz.org/', 'Est quaerat aut impedit quisquam beatae quo.', '35', '35', '35', 285, '16:46:16', '1988-03-24 17:08:28', 'Cumque eaque dolorem repellat voluptatibus magnam quas atque.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('36', 'http://www.gaylordrutherford.net/', 'Sunt nam nisi repellat aut delectus.', '36', '36', '36', 293, '00:00:13', '1982-06-21 16:10:46', 'Recusandae earum sed id perferendis.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('37', 'http://www.quitzon.biz/', 'Recusandae dolores nemo ipsa ea.', '37', '37', '37', 294, '00:39:21', '1977-02-05 11:58:29', 'Similique voluptas voluptas esse et autem.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('38', 'http://www.glovergleason.com/', 'Non suscipit quasi hic non dignissimos sunt quam.', '38', '38', '38', 298, '19:58:26', '1970-11-23 20:34:29', 'Praesentium labore nam non.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('39', 'http://www.herman.com/', 'Mollitia nemo sed sint quam aut totam asperiores.', '39', '39', '39', 301, '23:24:44', '2008-01-14 05:08:24', 'Non atque et et et odit recusandae.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('40', 'http://www.krajcik.com/', 'Doloribus delectus tenetur deserunt exercitationem', '40', '40', '40', 302, '17:36:45', '1986-07-17 04:10:41', 'Rerum ex sint est et.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('41', 'http://bode.org/', 'Necessitatibus et eum totam quia ducimus.', '41', '41', '41', 304, '13:23:16', '2004-07-23 16:20:33', 'Maiores consectetur quasi id sed tempora perspiciatis voluptatem.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('42', 'http://carrollaltenwerth.com/', 'Veniam omnis iste id ipsam.', '42', '42', '42', 305, '07:14:31', '1994-01-27 16:14:09', 'Sed vitae minima ut maxime ducimus fugit occaecati commodi.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('43', 'http://hintz.com/', 'Ex ullam corrupti sit aut eligendi perferendis rep', '43', '43', '43', 308, '10:11:17', '2015-02-15 14:12:18', 'Aut a perspiciatis eius laboriosam expedita.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('44', 'http://hermann.info/', 'Quasi rerum sunt rerum omnis impedit iusto.', '44', '44', '44', 311, '11:44:15', '1974-01-12 04:47:05', 'Hic ducimus explicabo atque laudantium ut eos.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('45', 'http://www.koss.biz/', 'Corporis impedit tenetur qui dolorem officiis dign', '45', '45', '45', 312, '23:29:48', '1975-05-06 16:58:05', 'Saepe ratione dolor reiciendis est est harum quo.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('46', 'http://lang.com/', 'Amet laudantium alias explicabo error eos incidunt', '46', '46', '46', 316, '18:17:17', '2015-05-23 07:43:18', 'In eveniet est in enim tempora ut.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('47', 'http://maggioarmstrong.net/', 'Asperiores id corporis aut qui architecto.', '47', '47', '47', 325, '15:18:11', '1980-04-28 01:56:37', 'Quibusdam ut praesentium voluptas error.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('48', 'http://reinger.biz/', 'Qui dolores voluptatibus qui impedit et est.', '48', '48', '48', 326, '11:48:53', '2016-10-10 02:58:25', 'Nihil sunt qui dicta corporis dolorum.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('49', 'http://www.friesenmurphy.com/', 'Consequatur est voluptas quo.', '49', '49', '49', 329, '07:36:03', '2001-09-11 03:00:10', 'Neque et et expedita mollitia aut.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('50', 'http://www.haley.com/', 'Culpa assumenda hic distinctio ea cumque laboriosa', '50', '50', '50', 333, '22:22:03', '1998-03-22 00:07:28', 'Quo distinctio corporis incidunt a tempora est maiores.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('51', 'http://www.hermiston.com/', 'In ut occaecati corporis placeat pariatur.', '1', '51', '51', 334, '19:20:34', '2003-12-20 12:12:43', 'Illum optio perferendis delectus blanditiis eos autem illum.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('52', 'http://corwinrohan.com/', 'Quia aspernatur voluptas reprehenderit.', '2', '52', '52', 336, '20:59:37', '2015-12-06 06:11:44', 'Enim sapiente quo dolor est maxime temporibus ex.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('53', 'http://jenkins.info/', 'Unde voluptatem ullam accusantium.', '3', '53', '53', 338, '12:09:33', '1991-04-29 07:51:24', 'Excepturi hic expedita consectetur deserunt cumque nam.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('54', 'http://welch.info/', 'Perferendis minus esse ea ipsam aliquam nam tenetu', '4', '54', '54', 340, '02:41:26', '1990-11-23 09:10:12', 'Debitis et doloribus velit alias iusto soluta veritatis amet.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('55', 'http://www.mitchelljohns.com/', 'Consectetur doloremque laborum facere perspiciatis', '5', '55', '55', 343, '02:10:35', '1973-03-27 00:44:16', 'Ad perspiciatis incidunt qui facilis.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('56', 'http://littel.info/', 'Natus id sunt error repellat sit.', '6', '56', '56', 344, '20:56:09', '1977-10-13 22:31:13', 'Eum voluptas cum assumenda et dolorem.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('57', 'http://kassulkerippin.com/', 'Maxime aut ut voluptatem et eaque.', '7', '57', '57', 346, '03:23:30', '1992-08-16 00:03:58', 'Deserunt consequuntur nam reprehenderit pariatur minima sed.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('58', 'http://kutch.org/', 'Deserunt labore reprehenderit facilis fugiat quis.', '8', '58', '58', 351, '12:35:38', '2018-04-10 00:40:08', 'Ullam facere voluptate ut facilis ad.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('59', 'http://www.quitzon.net/', 'In omnis omnis vero minima dolor deserunt in.', '9', '59', '59', 353, '10:53:36', '2014-09-10 09:58:50', 'Fuga qui consequatur numquam doloribus quo voluptas pariatur.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('60', 'http://www.hand.com/', 'Neque natus eaque alias.', '10', '60', '60', 361, '11:20:51', '1974-03-20 03:33:46', 'Quaerat animi similique iste sapiente voluptatem ab.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('61', 'http://www.moore.net/', 'Incidunt aut est vero in veritatis.', '11', '61', '61', 364, '14:08:44', '2005-06-25 07:18:36', 'Et molestiae quis placeat voluptates accusantium debitis.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('62', 'http://jerde.com/', 'Omnis sint nesciunt velit est.', '12', '62', '62', 365, '10:56:47', '1988-06-09 01:30:39', 'Ut reprehenderit quia quia qui qui libero velit.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('63', 'http://ebertpacocha.com/', 'Quae quia cum rerum consequatur.', '13', '63', '63', 375, '14:42:07', '1981-05-25 22:51:53', 'Accusamus vel mollitia itaque quia ut.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('64', 'http://schaden.com/', 'Quos occaecati aut voluptatem cumque voluptatibus.', '14', '64', '64', 385, '09:34:59', '1980-03-04 12:25:01', 'Doloremque ratione inventore est atque.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('65', 'http://www.watersvolkman.org/', 'Cum repellat labore aperiam quas iure laboriosam.', '15', '65', '65', 386, '05:45:17', '1982-07-05 09:53:29', 'Officia consequatur quo cumque voluptas.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('66', 'http://gottliebdeckow.biz/', 'Consectetur dolor nulla quo neque.', '16', '66', '66', 388, '10:12:11', '1999-10-03 10:27:50', 'Necessitatibus sed porro aut quos quasi accusantium quae vero.');
INSERT INTO `songs` (`id`, `link_to_file_song`, `song_title`, `genre_id`, `artist_id`, `album_id`, `language_country_id`, `song_duration`, `created_at`, `song_lyrics`) VALUES ('67', 'http://hahn.biz/', 'Ipsam eum corrupti voluptatem ab nesciunt laborum ', '17', '67', '67', 390, '16:23:24', '1996-09-24 19:20:58', 'Rerum saepe facere accusantium repellendus id fuga eius.');

INSERT INTO `playlist_songs_list` (`playlist_id`, `song_id`, `album_id`, `genre_id`) VALUES 
('1', '61', '1', '11'),
('1', '67', '27', '17'),
('1', '66', '20', '16'),
('4', '14', '60', '14'),
('5', '35', '25', '35'),
('6', '12', '22', '12'),
('7', '18', '28', '18'),
('8', '1', '29', '1'),
('9', '38', '38', '38'),
('10', '28', '28', '28'),
('11', '51', '51', '1'),
('12', '25', '15', '25'),
('13', '39', '39', '39'),
('14', '57', '37' , '7'),
('15', '43', '29', '43'),
('16', '20', '40' , '20'),
('17', '21', '11', '21'),
('18', '48', '18', '48'),
('19', '60', '10', '10'),
('20', '54', '40', '4'),
('21', '52', '29', '2'),
('22', '58', '25', '8'),
('23', '50', '6', '50'),
('24', '56', '64', '6'),
('25', '17', '17', '17'),
('26', '3', '20', '3'),
('27', '45', '45', '45'),
('28', '35', '35', '35'),
('29', '49', '24', '49'),
('30', '31', '11', '31'),
('31', '12', '26', '12'),
('32', '60', '10', '10'),
('33', '45', '35', '45'),
('34', '67', '48', '17'),
('35', '61', '31', '11'),
('36', '66', '26', '16'),
('37', '59', '39', '9'),
('38', '59', '59', '9'),
('39', '57', '18', '7'),
('40', '31', '18', '31'),
('41', '37', '27', '37'),
('42', '32', '42', '32'),
('43', '21', '11', '21'),
('44', '55', '58', '5'),
('45', '29', '13', '29'),
('46', '18', '18', '18'),
('47', '16', '64', '16'),
('48', '10', '20', '10'),
('49', '55', '5', '5'),
('50', '34', '34', '34'),
('51', '10', '3', '10'),
('52', '33', '63', '33'),
('53', '49', '29', '49'),
('54', '34', '04', '34'),
('55', '44', '45', '44'),
('56', '27', '28', '27'),
('57', '59', '29', '9'),
('58', '33', '33', '33'),
('59', '32', '12', '32'),
('60', '24', '44', '24'),
('61', '14', '04', '14'),
('62', '44', '44', '44'),
('63', '56', '26', '6'),
('64', '38', '33', '38'),
('65', '56', '35', '6'),
('66', '32', '33', '32'),
('67', '54', '54', '4'),
('68', '10', '10', '10'),
('69', '21', '10', '21'),
('70', '1', '11', '1'),
('72', '19', '19', '19'),
('71', '3', '3', '3'),
('73', '11', '21', '11'),
('74', '11', '19', '11'),
('75', '6', '66', '6'),
('76', '25', '32', '25'),
('77', '5', '5', '5'),
('78', '17', '17', '17'),
('79', '41', '41', '41'),
('80', '33', '10', '33'),
('81', '13', '53', '13'),
('82', '55', '35', '5'),
('83', '56', '25', '6'),
('84', '22', '22', '22'),
('85', '23', '23', '23'),
('86', '34', '62', '34'),
('87', '30', '38', '30'),
('88', '19', '13', '19'),
('89', '40', '40', '40'),
('90', '43', '63', '43'),
('91', '20', '20', '20'),
('92', '33', '13', '33'),
('93', '57', '57', '7'),
('94', '61', '41', '11'),
('95', '65', '34', '15'),
('96', '43', '53', '43'),
('97', '26', '26', '26'),
('98', '52', '52', '2'),
('99', '09', '09', '09'),
('100', '38', '55', '38'),
('101', '35', '15', '35'),
('102', '49', '37', '49'),
('103', '55', '55', '5'),
('104', '56', '60', '6'),
('105', '12', '32', '12'),
('106', '15', '15', '15'),
('107', '66', '61', '16'),
('108', '7', '7', '7'),
('109', '28', '13', '28'),
('110', '40', '30', '40'),
('111', '02', '02', '02'),
('112', '24', '24', '24'),
('113', '57', '57', '7'),
('114', '48', '48', '48'),
('115', '67', '67', '17'),
('116', '67', '67', '17'),
('117', '24', '24', '24'),
('118', '18', '18', '18'),
('119', '14', '14', '14'),
('120', '59', '59', '9'),
('121', '25', '15', '25'),
('122', '22', '42', '22'),
('123', '12', '12', '12'),
('124', '29', '29', '29'),
('125', '27', '27', '27'),
('126', '37', '37', '37'),
('127', '46', '46', '46'),
('128', '38', '19', '38'),
('129', '51', '14', '1'),
('130', '22', '22', '22'),
('131', '56', '56', '6'),
('132', '24', '24', '24'),
('133', '45', '25', '45'),
('134', '44', '24', '44'),
('135', '60', '60', '10'),
('136', '51', '51', '1'),
('137', '18', '18', '18'),
('138', '45', '45', '45'),
('139', '43', '43', '43'),
('140', '53', '53', '3'),
('141', '36', '36', '36'),
('142', '66', '66', '16'),
('143', '44', '44', '44'),
('144', '61', '61', '11'),
('145', '46', '46', '46'),
('146', '08', '08', '08'),
('147', '38', '18', '38'),
('148', '16', '36', '16'),
('149', '29', '29', '29'),
('150', '16', '26', '16'),
('3', '11', '11', '11'),
('3', '18', '18', '18'),
('3', '27', '27', '27'),
('4', '34', '34', '34'),
('5', '12', '22', '12'),
('150', '13', '63', '13'),
('150', '62', '33', '12'),
('150', '15', '33', '15'),
('150', '34', '34', '34'),
('13', '39', '39', '39'),
('16', '53', '53', '3'),
('16', '60', '60', '10'),
('16', '49', '49', '49'),
('16', '40', '40', '40'),
('16', '43', '43', '43'),
('16', '40', '40', '40'),
('16', '24', '24', '24'),
('68', '21', '21', '21'),
('69', '43', '43', '43'),
('70', '19', '19', '19'),
('71', '62', '62', '12'),
('72', '20', '20', '20'),
('17', '49', '49', '49'),
('14', '13', '13', '13'),
('75', '49', '49', '49'),
('76', '51', '29', '1'),
('17', '14', '14', '14'),
('17', '64', '64', '14'),
('79', '55', '55', '5'),
('80', '17', '16', '17'),
('81', '02', '02', '02'),
('12', '10', '21', '10'),
('100', '45', '25', '45'),
('11', '27', '27', '27'),
('12', '48', '48', '48'),
('18', '64', '64', '14'),
('139', '49', '49', '49'),
('120', '29', '29', '29'),
('111', '25', '12', '25'),
('67', '46', '46', '46'),
('11', '1', '1', '1'),
('92', '50', '50', '50'),
('93', '55', '55', '5'),
('94', '43', '61', '43'),
('95', '38', '18', '38'),
('96', '47', '37', '47'),
('97', '9', '9', '9'),
('19', '30', '30', '30'),
('19', '15', '15', '15'),
('20', '62', '62', '12');


INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('1', 'et', '1', '1', '1983-10-12 11:49:43', '1990-06-14 06:05:25');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('2', 'aut', '1', '1', '1995-10-24 00:31:33', '1987-10-30 13:55:15');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('3', 'ratione', '1', '1', '2010-04-28 20:05:50', '1990-12-02 19:33:13');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('4', 'quis', '4', '1', '1979-12-17 09:18:34', '1984-07-26 03:47:06');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('5', 'sunt', '5', '5', '1977-12-19 01:04:20', '1978-07-07 19:07:25');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('6', 'delectus', '6', '6', '1992-12-26 08:32:41', '1983-09-08 09:04:04');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('7', 'qui', '7', '7', '1981-06-08 10:45:52', '1988-08-16 08:43:54');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('8', 'explicabo', '8', '8', '2003-07-07 09:21:49', '1995-03-26 12:58:29');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('9', 'similique', '9', '9', '1987-12-01 08:37:37', '2018-01-04 21:21:35');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('10', 'debitis', '10', '10', '2008-06-29 20:29:01', '1977-09-04 05:04:58');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('11', 'perferendis', '11', '11', '1981-06-21 01:41:10', '1994-11-27 11:40:28');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('12', 'ut', '12', '12', '2012-06-03 11:18:15', '1989-04-19 09:26:34');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('13', 'eaque', '13', '13', '2019-08-17 07:27:28', '1981-12-25 22:36:53');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('14', 'iure', '14', '14', '2008-09-02 06:23:06', '1994-06-18 02:24:35');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('15', 'nesciunt', '15', '15', '2013-01-23 20:38:39', '2012-11-25 15:48:22');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('16', 'doloremque', '16', '16', '1977-08-01 04:46:48', '2006-07-25 16:37:45');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('17', 'sint', '17', '17', '1975-02-07 18:48:40', '2011-10-04 02:47:18');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('18', 'ex', '18', '18', '2019-02-19 11:23:24', '1994-07-14 18:01:24');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('19', 'voluptas', '19', '19', '1984-02-25 17:35:50', '1976-12-29 23:49:17');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('20', 'voluptatum', '20', '20', '2004-05-07 13:18:21', '1999-01-13 20:29:11');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('21', 'perferendis', '21', '21', '1987-02-07 00:47:42', '1985-04-26 07:55:51');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('22', 'deleniti', '22', '22', '1996-02-15 08:05:13', '1978-01-13 01:17:05');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('23', 'occaecati', '23', '23', '1984-06-18 13:11:16', '1971-07-16 21:15:37');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('24', 'dolore', '24', '24', '2017-11-29 00:46:00', '2011-11-21 22:30:52');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('25', 'veniam', '25', '25', '1991-01-16 10:56:24', '1992-03-20 16:31:09');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('26', 'voluptatem', '26', '26', '1997-04-29 05:24:57', '1987-01-11 02:39:04');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('27', 'architecto', '27', '27', '1989-02-16 18:13:03', '1976-11-15 00:24:55');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('28', 'atque', '28', '28', '1971-10-29 16:20:16', '1997-02-03 23:01:36');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('29', 'occaecati', '29', '29', '2009-07-29 11:37:29', '2016-04-12 16:30:13');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('30', 'recusandae', '30', '30', '2017-10-07 10:05:09', '2000-02-01 13:17:09');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('31', 'et', '31', '31', '1997-11-12 12:01:11', '1974-03-21 05:20:44');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('32', 'aut', '32', '32', '1990-07-24 14:08:47', '1977-05-13 08:50:23');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('33', 'eos', '33', '33', '1990-08-25 01:16:14', '1985-08-26 22:13:43');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('34', 'velit', '34', '34', '2011-05-19 14:38:30', '1979-06-06 03:14:12');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('35', 'tenetur', '35', '35', '1983-07-21 23:11:45', '2012-05-11 06:05:20');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('36', 'optio', '36', '36', '2011-06-20 15:09:23', '1974-02-08 02:01:50');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('37', 'ipsam', '37', '37', '2016-06-23 18:54:19', '1972-11-21 15:37:36');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('38', 'neque', '38', '38', '1976-01-26 00:26:16', '2004-04-11 09:41:22');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('39', 'sint', '39', '39', '2008-10-03 03:49:02', '1972-06-08 23:04:50');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('40', 'quos', '40', '40', '2016-07-27 23:28:39', '1970-04-28 21:15:40');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('41', 'sit', '41', '41', '2003-01-29 16:22:39', '1994-04-17 02:52:52');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('42', 'nostrum', '42', '42', '1975-12-04 02:26:49', '1985-11-07 03:28:04');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('43', 'in', '43', '43', '2006-10-19 03:58:42', '2013-04-09 18:50:57');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('44', 'nihil', '44', '44', '1999-07-27 17:05:58', '1978-06-16 14:56:09');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('45', 'sapiente', '45', '45', '1974-08-15 06:27:15', '1997-08-22 01:22:33');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('46', 'sit', '46', '46', '1977-06-14 04:33:08', '2003-05-04 00:20:31');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('47', 'amet', '47', '47', '2011-08-19 09:58:46', '2019-12-18 14:50:20');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('48', 'minima', '48', '48', '2020-08-25 10:01:09', '1991-05-05 03:11:12');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('49', 'cumque', '49', '49', '1996-01-22 23:47:05', '1991-10-19 15:42:35');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('50', 'sit', '50', '50', '1993-03-09 06:04:05', '1976-01-14 09:07:41');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('51', 'laudantium', '51', '51', '1992-11-13 14:49:39', '2008-11-30 15:57:30');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('52', 'nostrum', '52', '52', '2008-04-20 09:12:15', '1985-12-05 23:34:20');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('53', 'necessitatibus', '53', '53', '2019-07-25 10:56:44', '1976-11-08 05:15:11');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('54', 'nesciunt', '54', '54', '1996-11-29 10:34:46', '2016-05-17 16:16:24');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('55', 'magni', '55', '55', '2015-04-20 22:12:22', '1997-07-18 10:56:46');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('56', 'incidunt', '56', '56', '1996-05-24 11:44:32', '1991-10-11 13:27:22');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('57', 'iure', '57', '57', '1983-12-29 10:52:07', '2015-10-11 11:34:37');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('58', 'et', '58', '58', '1990-07-03 18:14:51', '1984-03-05 14:05:21');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('59', 'eos', '59', '59', '1992-07-30 16:01:06', '2014-09-23 16:11:28');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('60', 'incidunt', '60', '60', '1982-04-21 14:22:42', '2002-11-13 21:54:24');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('61', 'sint', '61', '61', '2013-09-04 07:05:51', '2018-07-20 22:57:35');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('62', 'voluptatem', '62', '62', '1973-03-05 09:51:37', '2007-06-17 20:37:49');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('63', 'earum', '63', '63', '1998-01-28 20:05:58', '1990-07-18 16:40:10');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('64', 'sunt', '64', '64', '1981-08-07 15:50:09', '2019-08-10 15:28:18');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('65', 'vero', '65', '65', '1985-04-19 04:15:20', '1974-06-08 09:42:48');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('66', 'non', '66', '66', '2020-06-17 06:03:08', '1986-06-03 17:23:15');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('67', 'ut', '67', '67', '1980-05-10 07:43:57', '2006-12-13 16:40:08');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('68', 'commodi', '68', '68', '1979-01-03 04:15:38', '1990-07-10 15:13:53');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('69', 'velit', '69', '69', '2010-01-16 12:06:58', '1995-01-19 00:05:07');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('70', 'maxime', '70', '70', '2016-05-26 08:50:15', '1995-05-18 05:20:11');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('71', 'suscipit', '71', '71', '1997-05-12 04:42:40', '2002-05-26 17:59:44');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('72', 'totam', '72', '72', '2003-10-26 15:23:29', '2000-03-12 10:59:20');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('73', 'sit', '73', '73', '1977-06-05 00:02:31', '1985-09-15 20:04:09');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('74', 'voluptatibus', '74', '74', '1983-07-14 07:53:34', '1972-05-04 08:07:15');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('75', 'impedit', '75', '75', '2008-09-16 03:57:05', '2006-03-10 18:40:59');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('76', 'necessitatibus', '76', '76', '1971-07-15 21:09:00', '1987-05-02 19:28:41');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('77', 'sit', '77', '77', '1997-05-30 08:34:09', '1995-04-27 18:20:50');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('78', 'aut', '78', '78', '2010-01-21 16:27:10', '2009-12-11 10:25:39');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('79', 'rem', '79', '79', '1978-04-28 14:13:03', '1991-05-02 00:16:10');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('80', 'temporibus', '80', '80', '1970-09-01 05:29:04', '1983-02-20 22:36:19');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('81', 'at', '81', '81', '1980-04-10 20:48:01', '2000-05-16 18:11:42');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('82', 'illo', '82', '82', '1983-11-23 11:47:33', '2003-04-22 22:35:45');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('83', 'laudantium', '83', '83', '2008-10-12 05:50:59', '1986-04-06 03:46:49');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('84', 'accusamus', '84', '84', '1990-10-13 04:32:11', '1987-07-05 12:01:35');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('85', 'qui', '85', '85', '2008-07-16 13:03:08', '1989-11-05 07:49:51');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('86', 'inventore', '86', '86', '1994-02-20 21:15:03', '1972-10-31 02:28:27');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('87', 'et', '87', '87', '2000-07-29 05:15:13', '1985-11-06 11:48:04');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('88', 'molestias', '88', '88', '1980-11-30 17:32:00', '2005-08-24 13:17:56');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('89', 'aut', '89', '89', '2002-11-03 21:58:42', '2013-11-22 10:12:01');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('90', 'et', '90', '90', '1994-09-03 04:06:39', '2016-03-09 02:24:31');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('91', 'suscipit', '91', '91', '2011-08-14 17:35:17', '1989-04-12 19:12:36');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('92', 'voluptate', '92', '92', '1975-07-22 14:03:33', '2013-10-12 22:14:19');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('93', 'ab', '93', '93', '1977-09-02 17:51:33', '1999-07-31 07:33:05');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('94', 'ipsum', '94', '94', '1978-11-04 19:55:56', '1980-04-22 00:46:22');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('95', 'omnis', '95', '95', '1976-12-02 09:29:17', '2014-08-15 08:50:46');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('96', 'ut', '96', '96', '1988-05-11 07:22:04', '1996-02-23 02:54:42');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('97', 'neque', '97', '97', '2006-12-27 11:54:43', '1970-07-18 02:15:28');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('98', 'ipsam', '98', '98', '1970-09-04 18:47:48', '2020-08-25 04:51:56');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('99', 'officiis', '99', '99', '1993-11-21 08:45:23', '2002-10-09 02:49:45');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('100', 'voluptatem', '100', '100', '2012-03-26 10:13:08', '1998-12-21 15:09:57');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('101', 'nihil', '101', '1', '1971-11-26 02:29:16', '1978-07-23 18:19:42');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('102', 'praesentium', '102', '2', '1996-12-23 15:07:27', '1972-09-19 18:02:24');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('103', 'ut', '103', '3', '1989-04-17 06:45:13', '1993-01-10 02:14:08');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('104', 'dolorem', '104', '4', '1982-05-10 08:45:29', '2002-04-20 16:35:51');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('105', 'quo', '105', '5', '1996-12-16 05:58:57', '1983-09-07 00:50:29');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('106', 'et', '106', '6', '1995-05-28 01:22:02', '2006-08-06 13:00:45');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('107', 'odit', '107', '7', '2018-10-01 15:00:47', '1994-02-18 10:15:47');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('108', 'officia', '108', '8', '2007-12-17 04:27:26', '1971-12-24 17:42:47');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('109', 'maiores', '109', '9', '2006-05-23 07:02:39', '2011-07-15 05:55:10');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('110', 'cum', '110', '10', '1985-12-09 16:32:07', '2013-02-23 18:45:40');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('111', 'aut', '111', '11', '1985-08-07 14:33:44', '1978-08-11 19:00:44');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('112', 'dolor', '112', '12', '1998-09-21 07:31:39', '2010-05-17 14:53:06');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('113', 'corrupti', '113', '13', '2013-10-05 16:24:21', '2016-01-23 23:34:26');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('114', 'fugit', '114', '14', '1999-07-07 06:58:36', '2019-03-16 07:08:07');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('115', 'dicta', '115', '15', '2006-09-07 08:43:06', '1998-08-29 22:16:54');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('116', 'aliquam', '116', '16', '1979-08-25 22:57:27', '1995-10-01 16:51:34');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('117', 'fuga', '117', '17', '1975-04-04 07:27:40', '2011-02-05 23:00:35');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('118', 'repellat', '118', '18', '1971-12-25 10:48:10', '2003-04-05 05:41:29');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('119', 'consequuntur', '119', '19', '1990-12-05 05:13:13', '2011-02-02 16:35:01');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('120', 'neque', '120', '20', '2001-07-12 10:27:38', '1989-08-29 09:17:38');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('121', 'hic', '121', '21', '2001-07-27 06:39:29', '1994-12-31 15:27:21');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('122', 'adipisci', '122', '22', '2009-01-27 13:23:57', '1998-08-14 02:56:38');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('123', 'corrupti', '123', '23', '1992-05-19 16:37:42', '2011-11-12 03:02:25');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('124', 'provident', '124', '24', '1983-10-09 09:05:43', '2017-12-21 08:12:09');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('125', 'consectetur', '125', '25', '2006-12-09 12:26:59', '2005-04-25 19:06:30');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('126', 'atque', '126', '26', '2008-07-11 10:04:42', '1978-07-16 02:01:59');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('127', 'qui', '127', '27', '1972-06-26 18:49:07', '1988-02-26 08:35:44');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('128', 'pariatur', '128', '28', '1976-01-24 13:20:39', '2001-02-02 16:04:51');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('129', 'voluptate', '129', '29', '1970-03-28 06:51:24', '2000-01-06 06:22:41');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('130', 'sed', '130', '30', '2014-12-25 12:18:40', '1992-10-06 06:08:32');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('131', 'ratione', '131', '31', '2018-08-07 05:22:39', '1993-08-29 12:04:36');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('132', 'dolorem', '132', '32', '1978-11-18 15:09:20', '2015-05-11 05:42:22');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('133', 'ullam', '133', '33', '2009-06-23 18:37:21', '2013-06-25 12:08:24');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('134', 'rem', '134', '34', '1971-06-17 00:22:02', '1986-08-11 21:39:55');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('135', 'qui', '135', '35', '1995-09-22 03:25:52', '2019-04-23 04:54:09');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('136', 'sint', '136', '36', '1973-05-25 15:55:11', '2002-09-14 13:52:38');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('137', 'consectetur', '137', '37', '2014-01-09 05:24:51', '2015-10-17 09:05:25');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('138', 'quas', '138', '38', '1971-03-04 08:58:38', '2016-09-02 05:33:25');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('139', 'odio', '139', '39', '2002-09-30 19:02:52', '1992-07-24 09:14:28');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('140', 'aliquid', '140', '40', '2002-12-22 11:00:51', '2008-01-01 20:32:20');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('141', 'inventore', '141', '41', '1996-08-19 13:56:13', '1975-10-24 05:37:29');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('142', 'quia', '142', '42', '1976-01-11 12:14:31', '1972-12-17 08:51:46');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('143', 'corrupti', '143', '43', '2009-01-04 14:44:20', '1991-10-21 09:00:49');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('144', 'sequi', '144', '44', '1997-12-30 02:43:44', '2002-02-11 03:12:33');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('145', 'numquam', '145', '45', '2010-08-11 22:47:30', '1999-11-24 15:00:48');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('146', 'reprehenderit', '146', '46', '1980-08-01 23:20:46', '2014-04-11 14:40:01');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('147', 'quo', '147', '47', '2011-07-07 12:22:31', '2016-05-17 01:27:19');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('148', 'recusandae', '148', '48', '1971-11-13 23:04:38', '2013-09-03 01:02:43');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('149', 'omnis', '149', '49', '1994-12-09 10:51:38', '2017-12-05 23:42:06');
INSERT INTO `playlists` (`id`, `playlist_name`, `songs_list_id`, `created_by_user_id`, `created_at`, `updated_at`) VALUES ('150', 'et', '150', '50', '1993-09-01 03:57:29', '2008-11-02 13:20:21');
