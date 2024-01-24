/*---- General Rules ----
   *Use underscore_names instead of camelCase
   *Table names should be plural
   *Spell out id fields (item_id instead of id)
   *don't use ambiguous column names
   *name foreign key columns the same as the columns they refer to
   *use caps for all sql queries
   */
CREATE SCHEMA IF NOT EXISTS securecapira;

SET NAMES 'UTF8MB4';
SET TIME_ZONE = 'GMT';
SET TIME_ZONE = '+1:00' ;

USE securecapira;

DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           varchar(100) NOT NULL,
    password        VARCHAR(255) default null,
    address         VARCHAR(255) DEFAULT null,
    phone           VARCHAR(30) DEFAULT NULL,
    title           VARCHAR(50) default null,
    bio             VARCHAR(255) default null,
    enabled         BOOLEAN DEFAULT FALSE,
    non_locked      BOOLEAN DEFAULT FALSE,
    usinq_mfa       BOOLEAN default FALSE,
    created_date    DATETIME DEFAULT CURRENT_TIMESTAMP,
    image_url       varchar(255) default 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    constraint UQ_Users_Email unique (email)
    );

DROP TABLE IF EXISTS Roles;

CREATE TABLE Roles (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(50) NOT NULL,
    permission      VARCHAR(255) NOT NULL,
    constraint UQ_Roles_Name unique (name)
);

DROP TABLE IF EXISTS UserRoles;

CREATE TABLE UserRoles (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    role_id         BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE ,
    FOREIGN KEY (role_id) REFERENCES Roles (id) ON DELETE RESTRICT ON UPDATE CASCADE ,
    constraint UQ_UserRoles_User_id UNIQUE (user_id)
);

DROP TABLE IF EXISTS Events;

CREATE TABLE Events (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type           varchar(50) NOT NULL CHECK ( type IN ('LOGIN_ATTEMPT' ,'LOGIN_ATTEMPT_FAILURE' ,' LOGIN-ATTEMPT-SUCCESS ' ,'PROFILE_UPDATE' ,'PROFILE_PICTURE_UPDATE' ,'ROLE_UPDATE' ,'ACCOUNT_SETTINGS_UPDATE' ,'PASSWORD_UPDATE' ,'MFA_UPDATE')),
    description    varchar(255) NOT NULL,
    constraint UQ_Events_type UNIQUE (type)
);

DROP TABLE IF EXISTS UserEvents;

CREATE TABLE UserEvents (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id        BIGINT UNSIGNED NOT NULL,
    event_id       BIGINT UNSIGNED NOT NULL,
    device         varchar(100) default null,
    ip_address     varchar(100) default null,
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE ,
    FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS AccountVerifications;

CREATE TABLE AccountVerifications
(
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id        BIGINT UNSIGNED NOT NULL,
    url            VARCHAR(255) NOT NULL,
    -- date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_AccountVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_AccountVerifications_Url UNIQUE (url)
);

DROP TABLE IF EXISTS ResetPasswordVerifications;

CREATE TABLE ResetPasswordVerifications
(
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    url             VARCHAR(255) NOT NULL,
    expiration_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_ResetPasswordVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_ResetPasswordVerifications_Url UNIQUE (url)
);

DROP TABLE IF EXISTS TwoFactorVerifications;

CREATE TABLE TwoFactorVerifications
(
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    code            VARCHAR(10) NOT NULL,
    expiration_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_TwoFactorVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_TwoFactorVerifications_code UNIQUE (code)
);