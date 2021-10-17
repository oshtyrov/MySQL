-- таблица посты пользователей, пост может выложить любой пользователь
-- столбцы: id поста, id автора, id пользователя, на чьей стене размещен пост,
-- время создания, id медиа из таблицы медиа, тип медиа, текст (необязательное поле) 
DROP TABLE IF EXISTS user_posts;
CREATE TABLE user_posts(
	id SERIAL,
	author_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	media_id BIGINT UNSIGNED NOT NULL,
	media_type_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	
	FOREIGN KEY (author_user_id) REFERENCES users(id),
	FOREIGN KEY (target_user_id) REFERENCES users(id),
	FOREIGN KEY (media_type_id) REFERENCES media_types(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

-- условная подтаблица браузерных игор с названием жанра (стратегии, спортивные, гонки, обучающие и тп)
DROP TABLE IF EXISTS game_classification;
CREATE TABLE game_classification(
	id SERIAL,
	name VARCHAR(255)
);

-- таблица браузерных игор, вмещает колонки: id, название игры, разработчика, id класификации,
-- время создания, id пользователей, которые установили и удалили игру
DROP TABLE IF EXISTS browser_games;
CREATE TABLE browser_games(
	game_id BIGINT unsigned not null auto_increment primary key,
	name VARCHAR(200),
	created_by VARCHAR(200),
	INDEX (name),
	game_classification_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	added_by_user_id BIGINT UNSIGNED NOT NULL,
	deleted_by_user_id BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (added_by_user_id) REFERENCES users(id),
	FOREIGN KEY (deleted_by_user_id) REFERENCES users(id),
	FOREIGN KEY (game_classification_id) REFERENCES game_classification(id)
);
