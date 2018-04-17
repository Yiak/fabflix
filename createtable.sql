DROP DATABASE IF EXISTS moviedb;
CREATE DATABASE moviedb;
USE moviedb;

CREATE TABLE IF NOT EXISTS movies(
    id VARCHAR(10) NOT NULL DEFAULT '',
    title VARCHAR(100) NOT NULL DEFAULT '',
    year INT NOT NULL,
    director VARCHAR(100) NOT NULL DEFAULT '',
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS stars(
    id VARCHAR(10) NOT NULL DEFAULT '',
    name VARCHAR(100) NOT NULL DEFAULT '',
    birthYear INT DEFAULT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS stars_in_movies(
    starId VARCHAR(10) NOT NULL DEFAULT '',
    movieId VARCHAR(10) NOT NULL DEFAULT '',
    FOREIGN KEY (starId) REFERENCES stars(id),
    FOREIGN KEY (movieId) REFERENCES movies(id)
);

CREATE TABLE IF NOT EXISTS genres(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL DEFAULT '',
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS genres_in_movies(
    genreId INT NOT NULL,
    movieId VARCHAR(10) NOT NULL DEFAULT '',
    FOREIGN KEY (genreId) REFERENCES genres(id),
    FOREIGN KEY (movieId) REFERENCES movies(id)
);

CREATE TABLE IF NOT EXISTS creditcards(
    id VARCHAR(20) NOT NULL DEFAULT '',
    firstName VARCHAR(50) NOT NULL DEFAULT '',
    lastName VARCHAR(50) NOT NULL DEFAULT '',
    expiration DATE NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS customers(
    id INT NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL DEFAULT '',
    lastName VARCHAR(50) NOT NULL DEFAULT '',
    ccId VARCHAR(20) NOT NULL DEFAULT '',
    address VARCHAR(200) NOT NULL DEFAULT '',
    email VARCHAR(50) NOT NULL DEFAULT '',
    password VARCHAR(20) NOT NULL DEFAULT '',
    PRIMARY KEY(id),
    FOREIGN KEY(ccId) REFERENCES creditcards(id)
);

CREATE TABLE IF NOT EXISTS sales(
    id INT NOT NULL AUTO_INCREMENT,
    customerId INT NOT NULL,
    movieId VARCHAR(10) NOT NULL DEFAULT '',
    saleDate DATE NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(customerId) REFERENCES customers(id),
    FOREIGN KEY(movieId) REFERENCES movies(id)
);

CREATE TABLE IF NOT EXISTS ratings(
    movieId VARCHAR(10) NOT NULL DEFAULT '',
    rating FLOAT NOT NULL,
    numVotes INT NOT NULL
);