/*
    Test data for the Recordly app.
*/

INSERT  INTO USER (login, passwd)
VALUES  ('george',
         "$2a$10$V/3bBbctmvfNnhXN06kogOpM1hwzgLkYQ.0jg0LefETMysoS4tIkS");

-- guest/recordly
INSERT  INTO USER (login, passwd)
VALUES  ('guest',
         "$2a$10$HOl21y4jjyCTfuL23DhNO.H7MOEhWYGyLFOhuLmCMDTKct7NsJPAm");

-------------

INSERT  INTO ARTIST (name)
VALUES  ('U2');

-------------

INSERT  INTO ALBUM (artist_id, title)
SELECT  r.id,
        'Zooropa'
FROM    ARTIST      r
WHERE   r.name      = 'U2';

-------------

DROP TABLE IF EXISTS _SONG;
CREATE  TEMP TABLE _SONG (name varchar(128) NOT NULL);
INSERT  INTO _SONG VALUES ('Zooropa');
INSERT  INTO _SONG VALUES ('Babyface');
INSERT  INTO _SONG VALUES ('Numb');
INSERT  INTO _SONG VALUES ('Lemon');
INSERT  INTO _SONG VALUES ('Stay (Faraway, So Close!)');
INSERT  INTO _SONG VALUES ('Daddy''s Gonna Pay For Your Crashed Car');
INSERT  INTO _SONG VALUES ('Some Days Are Better Than Others');
INSERT  INTO _SONG VALUES ('The First Time');
INSERT  INTO _SONG VALUES ('Dirty Day');
INSERT  INTO _SONG VALUES ('The Wanderer');

INSERT  INTO SONG (album_id, name)
SELECT  a.id,
        x.name
FROM    ALBUM       a
JOIN    ARTIST      r   ON  a.artist_id     = r.id  AND r.name  = 'U2'
JOIN    _SONG       x
WHERE   a.title     = 'Zooropa';

-------------

INSERT  INTO FAVORITE (user_id, object_id, object_type)
SELECT  u.id,
        s.id,
        'S'
FROM    USER        u
JOIN    ALBUM       a   ON  a.title         = 'Zooropa'
JOIN    ARTIST      r   ON  a.artist_id     = r.id  AND r.name  = 'U2'
JOIN    SONG        s   ON  s.album_id      = a.id  AND s.name  = 'Numb'
WHERE   u.login     = 'george';

-------------

INSERT  INTO USER_ALBUM
SELECT  u.id,
        a.id
FROM    USER        u
JOIN    ALBUM       a   ON  a.title     = 'Zooropa'
WHERE   u.login     IN ('george', 'guest');

