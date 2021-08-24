DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	firstname VARCHAR(100),
	lastname VARCHAR(100),
	email VARCHAR(200) UNIQUE,
	password VARCHAR(255),
	phone BIGINT UNSIGNED UNIQUE,
	INDEX idx_users_username(firstname, lastname)
);

# расширение функционала - домашка
# 1 - расширили функционал городов
DROP TABLE IF EXISTS towns;
CREATE TABLE towns(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	town_name VARCHAR(255)
);

# 2 - добавили желания desires, это нечто типа товаров
DROP TABLE IF EXISTS desires;
CREATE TABLE desires(
	id SERIAL,
	name VARCHAR(255),
	description VARCHAR(255)
);
# расширение функционала - домашка

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles(
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender VARCHAR(1),
	# расширение функционала - домашка
	town_id BIGINT UNSIGNED NOT NULL,
	# расширение функционала - домашка
	created_at DATETIME DEFAULT NOW()
);

ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id
FOREIGN KEY (user_id) REFERENCES users(id);

# расширение фунционала - домашка
ALTER TABLE profiles ADD CONSTRAINT fk_users_towns
FOREIGN KEY (town_id) REFERENCES towns(id);
# расширение фунционала - домашка

#один ко многим 1 x M
DROP TABLE IF EXISTS messages;
CREATE TABLE messages(
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests(
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('requested', 'approved', 'declined', 'unfriended'),
	
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
	PRIMARY KEY (initiator_user_id, target_user_id),
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
	FOREIGN KEY (target_user_id) REFERENCES users(id),
	
	CHECK (initiator_user_id != target_user_id)
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(255),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX(name),
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
	name VARCHAR(255)

);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	media_type_id BIGINT UNSIGNED NOT NULL,
	body VARCHAR(255),
	#file BLOB,
	filename VARCHAR(255),
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
	
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (media_id) REFERENCES vk.media(id),
	FOREIGN KEY (user_id) REFERENCES vk.users(id)
);

#ALTER TABLE vk.likes ADD CONSTRAINT likes_FK FOREIGN KEY (media_id) REFERENCES vk.media(id);
#ALTER TABLE vk.likes ADD CONSTRAINT likes_FK_1 FOREIGN KEY (user_id) REFERENCES vk.users(id);

# расширение функционала - домашка
# связь между пользователем и городом.
DROP TABLE IF EXISTS users_towns;
CREATE TABLE users_towns(
	user_id BIGINT UNSIGNED NOT NULL,
	town_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (town_id) REFERENCES towns(id)
);
# связь между пользователем и желанием.
DROP TABLE IF EXISTS users_desires;
CREATE TABLE users_desires(
	user_id BIGINT UNSIGNED NOT NULL,
	desire_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (desire_id) REFERENCES desires(id)
);
# расширение функционала - домашка
# 3 - чаты. Структура чатов похожа на структуру групп,
# дополненную сообщениями юзер - чат
DROP TABLE IF EXISTS chats;
CREATE TABLE chats(
	id SERIAL,
	name VARCHAR(255),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS chat_messages;
CREATE TABLE chat_messages(
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_chat_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_chat_id) REFERENCES chats(id)
);

DROP TABLE IF EXISTS users_chats;
CREATE TABLE users_chats(
	user_id BIGINT UNSIGNED NOT NULL,
	chat_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (chat_id) REFERENCES chats(id)
);

# расширение функционала - домашка
