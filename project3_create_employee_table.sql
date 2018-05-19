USE moviedb;
drop table employees;
CREATE TABLE IF NOT EXISTS employees(
    email VARCHAR(50) NOT NULL,
    password VARCHAR(128) NOT NULL ,
    fullname VARCHAR(100) ,
    PRIMARY KEY(email)
    );

INSERT INTO employees VALUES('classta@email.edu','f0CxC17nisnj/BBBpyM3i+j0v+k3sFk0iRyti/tnd0JuaYjIKmDOo8gWz1kOGbAA','TA CS122B');

INSERT INTO stars(name) VALUES('yyklz');