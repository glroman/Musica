/*
    Schema for: Recordly.
    Database:   SQLite3.
*/

DROP   TABLE IF EXISTS USER;
CREATE TABLE           USER
(
    id          integer         PRIMARY KEY,
    login       varchar(32)     NOT NULL UNIQUE,
    passwd      varchar(32)     -- Encrypted
);


DROP   TABLE IF EXISTS ARTIST;
CREATE TABLE           ARTIST
(
    id          integer         PRIMARY KEY,
    name        varchar(128)    NOT NULL UNIQUE
);


DROP   TABLE IF EXISTS ALBUM;
CREATE TABLE           ALBUM
(
    id          integer         PRIMARY KEY,
    artist_id   integer         NOT NULL,
    title       varchar(128)    NOT NULL
);

DROP    INDEX IF EXISTS ALBUM_IDX_ART_TTL;
CREATE  UNIQUE INDEX    ALBUM_IDX_ART_TTL
ON      ALBUM (artist_id, title);


DROP   TABLE IF EXISTS SONG;
CREATE TABLE           SONG
(
    id          integer         PRIMARY KEY,
    album_id    integer         NOT NULL,
    name        varchar(128)    NOT NULL
);

DROP    INDEX IF EXISTS SONG_IDX_ALB_NAM;
CREATE  UNIQUE INDEX    SONG_IDX_ALB_NAM
ON      SONG (album_id, name);


DROP   TABLE IF EXISTS FAVORITE;
CREATE TABLE           FAVORITE
(
    id          integer         PRIMARY KEY,
    user_id     integer         NOT NULL,
    object_id   integer         NOT NULL,
    object_type char(1)         CHECK (object_type IN ('A', 'S', 'R'))
                                -- '[A]lbum/[S]ong/a[R]tist'
);

DROP    INDEX IF EXISTS FAVORITE_IDX_USR_OBJ_TYP;
CREATE  UNIQUE INDEX    FAVORITE_IDX_USR_OBJ_TYP
ON      FAVORITE (user_id, object_id, object_type);


-- Intersection entity
DROP   TABLE IF EXISTS USER_ALBUM;
CREATE TABLE           USER_ALBUM
(
    user_id     integer         NOT NULL,
    album_id    int             NOT NULL
);

DROP    INDEX IF EXISTS USER_ALBUM_IDX_US_ALB;
CREATE  UNIQUE INDEX    USER_ALBUM_IDX_US_ALB
ON      USER_ALBUM (user_id, album_id);
