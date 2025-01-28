

DROP TABLE IF EXISTS `Должность`;
CREATE TABLE `Должность` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Код` CHAR(10) NOT NULL UNIQUE KEY
,   `Название` VARCHAR (50) NOT NULL
,    PRIMARY KEY (`Ид`)
);
INSERT INTO `Должность` VALUES 
    (DEFAULT,"001", "Директор"), 
    (DEFAULT,"002", "Чертежник"),
    (DEFAULT,"003", "Техник"),
    (DEFAULT,"004", "Рабочий");

SELECT * FROM `Должность`;


DROP TABLE IF EXISTS `Сотрудник%ПЕРС`;
CREATE TABLE `Сотрудник%ПЕРС` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Код` CHAR (10) NOT NULL UNIQUE KEY
,   `ФИО` VARCHAR (50) NOT NULL
,    PRIMARY KEY (`Ид`) 
);
INSERT INTO `Сотрудник%ПЕРС` VALUES 
    (DEFAULT,"011", "Петров А. А."), 
    (DEFAULT,"022", "Боширов Р. Р."),
    (DEFAULT,"088", "Исаев М. М."),
    (DEFAULT,"097", "Акбашев М. М.");

SELECT * FROM `Сотрудник%ПЕРС`;


DROP TABLE IF EXISTS `Клиент%ПЕРС`;
CREATE TABLE `Клиент%ПЕРС` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Код` CHAR (10) NOT NULL UNIQUE KEY
,   `ФИО` VARCHAR (50) NOT NULL   
,   `Адрес квартиры клиента` VARCHAR (150) NOT NULL
,    PRIMARY KEY (`Ид`)    
);
INSERT INTO `Клиент%ПЕРС` VALUES 
    (DEFAULT,"001", "Иванов И. И.", "ул. Пугачева"), 
    (DEFAULT,"002", "Сидоров С. С.", "ул. Пушкина");

SELECT * FROM `Клиент%ПЕРС`;


DROP TABLE IF EXISTS `Оформитель заказов:СОТР`;
CREATE TABLE `Оформитель заказов:СОТР` 
(   `Ид\ОФЗ^СОТР` BIGINT NOT NULL PRIMARY KEY
,   `Ид\ОФЗ^ДОЛЖ` BIGINT NOT NULL
,   CONSTRAINT `Ид\ОФЗ^СОТР` FOREIGN KEY (`Ид\ОФЗ^СОТР`) REFERENCES `Сотрудник%ПЕРС` (`Ид`)
,   CONSTRAINT `Ид\ОФЗ^ДОЛЖ` FOREIGN KEY (`Ид\ОФЗ^ДОЛЖ`) REFERENCES `Должность` (`Ид`)
);
INSERT INTO `Оформитель заказов:СОТР` SET 
    `Ид\ОФЗ^СОТР` = (SELECT `Ид` FROM `Сотрудник%ПЕРС` WHERE `Код`="011"),
    `Ид\ОФЗ^ДОЛЖ` = (SELECT `Ид` FROM `Должность` WHERE `Код`="001");

SELECT * FROM `Оформитель заказов:СОТР`;


DROP TABLE IF EXISTS `Заказ`;
CREATE TABLE `Заказ` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Регномер заказа` CHAR (10) NOT NULL UNIQUE KEY
,   `Дата оформления заказа` VARCHAR (150) NOT NULL
,   `Ид\ЗАК^КЛТ` BIGINT NOT NULL
,   `Ид\ЗАК^ОФЗ` BIGINT NOT NULL 
,    PRIMARY KEY (`Ид`)   
,   CONSTRAINT `Ид\ЗАК^КЛТ` FOREIGN KEY (`Ид\ЗАК^КЛТ`) REFERENCES `Клиент%ПЕРС` (`Ид`) 
,   CONSTRAINT `Ид\ЗАК^ОФЗ` FOREIGN KEY (`Ид\ЗАК^ОФЗ`) REFERENCES `Оформитель заказов:СОТР` (`Ид\ОФЗ^СОТР`) 

);
INSERT INTO `Заказ` SET
    `Ид` = DEFAULT,
    `Регномер заказа` = "001",
    `Дата оформления заказа` = "01.02.2003",
    `Ид\ЗАК^КЛТ` = (SELECT `Ид` FROM `Клиент%ПЕРС` WHERE `Код`="001"),
    `Ид\ЗАК^ОФЗ` = 1; #ISPRAV: У оформителя заказа нет натуральных ключей

SELECT * FROM `Заказ`;



DROP TABLE IF EXISTS `Справка`;
CREATE TABLE `Справка` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Слк` CHAR (4) NOT NULL
,   `Код` CHAR (3) NOT NULL
,   `Название` VARCHAR (50) NOT NULL
,    PRIMARY KEY (`Ид`)   
,    CONSTRAINT `Ун1\СПР` UNIQUE KEY (`Слк`, `Код`)
);
INSERT INTO `Справка` VALUES 
    (DEFAULT,"ВИДЗ", "стн", "ремонт стен"), 
    (DEFAULT,"ВИДР",  "пок", "покраска"), 
    (DEFAULT,"ВИДО", "пот", "потолок"), 
    (DEFAULT,"ВИДМ", "кра", "краска"), 
    (DEFAULT,"ВЗАМ", "нек", "некритичное замечание"), 
    (DEFAULT,"ВЗАТ", "мал", "малая"), 
    (DEFAULT,"ВИДУ", "про", "профессионально")
;

SELECT * FROM `Справка`;


DROP TABLE IF EXISTS `Плановик:СОТР`;
CREATE TABLE `Плановик:СОТР` 
(   `Ид\ПЛК^СОТР` BIGINT NOT NULL PRIMARY KEY
,   `Ид\ПЛК^ДОЛЖ` BIGINT NOT NULL
,   CONSTRAINT `Ид\ПЛК^СОТР` FOREIGN KEY (`Ид\ПЛК^СОТР`) REFERENCES `Сотрудник%ПЕРС` (`Ид`)
,   CONSTRAINT `Ид\ПЛК^ДОЛЖ` FOREIGN KEY (`Ид\ПЛК^ДОЛЖ`) REFERENCES `Должность` (`Ид`)
);
INSERT INTO `Плановик:СОТР`  SET 
    `Ид\ПЛК^СОТР` = (SELECT `Ид` FROM `Сотрудник%ПЕРС` WHERE `Код`="022"),
    `Ид\ПЛК^ДОЛЖ` = (SELECT `Ид` FROM `Должность` WHERE `Код`="002");

SELECT * FROM `Плановик:СОТР`;


DROP TABLE IF EXISTS `Задание`;
CREATE TABLE `Задание` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Регномер задания` CHAR (10) NOT NULL UNIQUE  KEY
,   `Ид\ЗАД^ЗАК` BIGINT NOT NULL
,   `Ид\ЗАД^ПЛК` BIGINT NOT NULL   
,   `Ид_ВИДЗ\ЗАД^СПР` BIGINT NOT NULL
,   `Содержание задания` CHAR (200) NOT NULL
,   `Цена задания` CHAR (100) NOT NULL
,    PRIMARY KEY (`Ид`)   
,   CONSTRAINT `Ид\ЗАД^ЗАК` FOREIGN KEY (`Ид\ЗАД^ЗАК`) REFERENCES `Заказ` (`Ид`)
,   CONSTRAINT `Ид\ЗАД^ПЛК` FOREIGN KEY (`Ид\ЗАД^ПЛК`) REFERENCES `Плановик:СОТР` (`Ид\ПЛК^СОТР`)
,   CONSTRAINT `Ид_ВИДЗ\ЗАД^СПР` FOREIGN KEY (`Ид_ВИДЗ\ЗАД^СПР`) REFERENCES `Справка` (`Ид`)
);
INSERT INTO `Задание` SET 
    `Ид` = DEFAULT,
    `Регномер задания` = "001",
    `Содержание задания` = "Ремонт стен",
    `Цена задания` = "10000 руб.",
    `Ид\ЗАД^ЗАК` = (SELECT `Ид` FROM `Заказ` WHERE `Регномер заказа`="001"),
    `Ид\ЗАД^ПЛК` = 2,  #ISPRAV: У плановика нет натуральных ключей
    `Ид_ВИДЗ\ЗАД^СПР` = (SELECT `Ид` FROM `Справка` WHERE `Слк`="ВИДЗ" AND `Код`="стн");

SELECT * FROM `Задание`;


DROP TABLE IF EXISTS `Менеджер:СОТР`;
CREATE TABLE `Менеджер:СОТР` 
(   `Ид\МДЖ^СОТР` BIGINT NOT NULL PRIMARY KEY
,   `Ид\МДЖ^ДОЛЖ` BIGINT NOT NULL
,   CONSTRAINT `Ид\МДЖ^СОТР` FOREIGN KEY (`Ид\МДЖ^СОТР`) REFERENCES `Сотрудник%ПЕРС` (`Ид`)
,   CONSTRAINT `Ид\МДЖ^ДОЛЖ` FOREIGN KEY (`Ид\МДЖ^ДОЛЖ`) REFERENCES `Должность` (`Ид`)
);
INSERT INTO `Менеджер:СОТР` SET 
    `Ид\МДЖ^СОТР` = (SELECT `Ид` FROM `Сотрудник%ПЕРС` WHERE `Код`="088"),
    `Ид\МДЖ^ДОЛЖ` = (SELECT `Ид` FROM `Должность` WHERE `Код`="003");

SELECT * FROM `Менеджер:СОТР`;


DROP TABLE IF EXISTS `Работа\ЗАД`;
CREATE TABLE `Работа\ЗАД` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Номер работы` CHAR (10) NOT NULL
,   `Ид\РАБ^ЗАД` BIGINT NOT NULL 
,   `Даты начала/окончания` CHAR (50) NOT NULL
,   `Ид\РАБ^МДЖ` BIGINT NOT NULL
,   `Ид_ВИДР\РАБ^СПР` BIGINT NOT NULL
,    PRIMARY KEY (`Ид`)   
,    CONSTRAINT `Ун1\РАБ` UNIQUE KEY (`Номер работы`, `Ид\РАБ^ЗАД`) 
,    CONSTRAINT `Ид\РАБ^ЗАД` FOREIGN KEY (`Ид\РАБ^ЗАД`) REFERENCES `Задание` (`Ид`)  
,    CONSTRAINT `Ид\РАБ^МДЖ` FOREIGN KEY (`Ид\РАБ^МДЖ`) REFERENCES `Менеджер:СОТР` (`Ид\МДЖ^СОТР`)
,    CONSTRAINT `Ид_ВИДР\РАБ^СПР` FOREIGN KEY (`Ид_ВИДР\РАБ^СПР`) REFERENCES `Справка` (`Ид`)
);
INSERT INTO `Работа\ЗАД` SET
    `Ид` = DEFAULT,
    `Номер работы` = "001",
    `Ид\РАБ^ЗАД` = (SELECT `Ид` FROM `Задание` WHERE `Регномер задания`="001"),
    `Даты начала/окончания` = "01.01.2023/04.01.2023",
    `Ид\РАБ^МДЖ` = 3,#ISPRAV: У менеджера нет натуральных ключей
    `Ид_ВИДР\РАБ^СПР` = (SELECT `Ид` FROM `Справка` WHERE `Слк`="ВИДР" AND `Код`="пок");

SELECT * FROM `Работа\ЗАД`;


DROP TABLE IF EXISTS `Особенность работы\РАБ`;
CREATE TABLE `Особенность работы\РАБ` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Нпп особенности` VARCHAR (10) NOT NULL
,   `Ид\ОСР^РАБ`  BIGINT (10) NOT NULL 
,   `Содержание особенности` CHAR (150) NOT NULL
,   `Ид_ВИДО\ОСР^СПР` BIGINT NOT NULL
,    PRIMARY KEY (`Ид`)   
,    CONSTRAINT `Ун1\РАБ` UNIQUE KEY (`Нпп особенности`, `Ид\ОСР^РАБ`) 
,    CONSTRAINT `Ид\ОСР^РАБ` FOREIGN KEY (`Ид\ОСР^РАБ`) REFERENCES `Работа\ЗАД` (`Ид`)
,    CONSTRAINT `Ид_ВИДО\ОСР^СПР` FOREIGN KEY (`Ид_ВИДО\ОСР^СПР`) REFERENCES `Справка` (`Ид`)
);
INSERT INTO `Особенность работы\РАБ` SET
    `Ид` = DEFAULT,
    `Нпп особенности` = "1", 
    `Ид\ОСР^РАБ` = (SELECT `Ид` FROM `Работа\ЗАД` WHERE `Номер работы`="001"),
    `Содержание особенности`="Красить до потолка",
    `Ид_ВИДО\ОСР^СПР` = (SELECT `Ид` FROM `Справка` WHERE `Слк`="ВИДО" AND `Код`="пот");

SELECT * FROM `Особенность работы\РАБ`;


DROP TABLE IF EXISTS `Мастер:СОТР`;
CREATE TABLE `Мастер:СОТР` 
(
    `Ид\МСР^СОТР` BIGINT NOT NULL PRIMARY KEY
,   `Ид\МСР^ДОЛЖ` BIGINT NOT NULL
,   CONSTRAINT `Ид\МСР^СОТР` FOREIGN KEY (`Ид\МСР^СОТР`) REFERENCES `Сотрудник%ПЕРС` (`Ид`)
,   CONSTRAINT `Ид\МСР^ДОЛЖ` FOREIGN KEY (`Ид\МСР^ДОЛЖ`) REFERENCES `Должность` (`Ид`)
);
INSERT INTO `Мастер:СОТР`  SET 
    `Ид\МСР^СОТР` = (SELECT `Ид` FROM `Сотрудник%ПЕРС` WHERE `Код`="097"),
    `Ид\МСР^ДОЛЖ` = (SELECT `Ид` FROM `Должность` WHERE `Код`="004");

SELECT * FROM `Мастер:СОТР`;


DROP TABLE IF EXISTS `Исполнитель работы:РАБ*МСР`;
CREATE TABLE `Исполнитель работы:РАБ*МСР` 
(   
    `Ид\ИСР^РАБ` BIGINT NOT NULL 
,   `Ид\ИСР^МСР` BIGINT NOT NULL
,   `Роль рабочего` CHAR (50) NULL
,    PRIMARY KEY ( `Ид\ИСР^РАБ`, `Ид\ИСР^МСР`)
,    CONSTRAINT `Ид\ИСР^МСР` FOREIGN KEY (`Ид\ИСР^МСР`) REFERENCES `Мастер:СОТР` (`Ид\МСР^СОТР`)
,    CONSTRAINT `Ид\ИСР^РАБ` FOREIGN KEY (`Ид\ИСР^РАБ`) REFERENCES `Работа\ЗАД` (`Ид`)
);
INSERT INTO `Исполнитель работы:РАБ*МСР` SET 
    `Ид\ИСР^РАБ` = (SELECT `Ид` FROM `Работа\ЗАД` WHERE `Номер работы`="001"),
    `Ид\ИСР^МСР` = 4, #ISPRAV: У мастера нет натуральных ключей
    `Роль рабочего` = "Маляр";

SELECT * FROM `Исполнитель работы:РАБ*МСР`;


DROP TABLE IF EXISTS `Расход материала\ИСР`;
CREATE TABLE `Расход материала\ИСР` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Нпп материала` CHAR (10) NOT NULL
,   `Ид\РХМ^ИСР` BIGINT NOT NULL 
,   `Марка материала` CHAR (150) NULL
,   `Количество материала` CHAR (150) NOT NULL
,   `Ид_ВИДМ\ОСР^СПР` BIGINT NOT NULL
,    PRIMARY KEY (`Ид`)   
,    CONSTRAINT `Ун1\РХМ` UNIQUE KEY (`Нпп материала`, `Ид\РХМ^ИСР`) 
,    CONSTRAINT `Ид\РХМ^ИСР` FOREIGN KEY (`Ид\РХМ^ИСР`) REFERENCES `Исполнитель работы:РАБ*МСР` (`Ид\ИСР^РАБ`)
,    CONSTRAINT `Ид_ВИДМ\РХМ^СПР` FOREIGN KEY (`Ид_ВИДМ\ОСР^СПР`) REFERENCES `Справка` (`Ид`)
);
INSERT INTO `Расход материала\ИСР` SET
    `Ид` = DEFAULT,
    `Нпп материала` = "1",
    `Ид\РХМ^ИСР` = (SELECT `Ид\ИСР^РАБ` FROM `Исполнитель работы:РАБ*МСР` WHERE `Роль рабочего`="Маляр"),
    `Марка материала` = "ЦАРСКАЯ КРАСКА",
    `Количество материала` = "2" ,
    `Ид_ВИДМ\ОСР^СПР` = (SELECT `Ид` FROM `Справка` WHERE `Слк`="ВИДМ" AND `Код`="кра");

SELECT * FROM `Расход материала\ИСР`;


DROP TABLE IF EXISTS `Замечания по исполнению\ИСР`;
CREATE TABLE `Замечания по исполнению\ИСР` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Нпп замечания` CHAR (10) NOT NULL
,   `Ид\ЗМИ^ИСР` BIGINT NOT NULL
,   `Содержание замечания` CHAR (150) NOT NULL
,   `Устранение замечания` CHAR (150) NULL
,   `Ид_ВЗАМ\ЗМИ^СПР` BIGINT NOT NULL
,    PRIMARY KEY (`Ид`)   
,    CONSTRAINT `Ун1\ЗМИ` UNIQUE KEY (`Нпп замечания`, `Ид\ЗМИ^ИСР`) 
,    CONSTRAINT `Ид\ЗМИ^ИСР` FOREIGN KEY (`Ид\ЗМИ^ИСР`) REFERENCES `Исполнитель работы:РАБ*МСР` (`Ид\ИСР^РАБ`)
,    CONSTRAINT `Ид_ВЗАМ\ЗМИ^СПР` FOREIGN KEY (`Ид_ВЗАМ\ЗМИ^СПР`) REFERENCES `Справка` (`Ид`)
);
INSERT INTO `Замечания по исполнению\ИСР` SET
    `Ид` = DEFAULT,
    `Нпп замечания` = "1",
    `Ид\ЗМИ^ИСР` = (SELECT `Ид\ИСР^РАБ` FROM `Исполнитель работы:РАБ*МСР` WHERE `Роль рабочего`="Маляр"),
    `Содержание замечания` = "Не докрашены углы",
    `Устранение замечания` = NULL ,
    `Ид_ВЗАМ\ЗМИ^СПР` = (SELECT `Ид` FROM `Справка` WHERE `Слк`="ВЗАМ" AND `Код`="нек");

SELECT * FROM `Замечания по исполнению\ИСР`;


DROP TABLE IF EXISTS `Затрата:ЗАД*СПР`;
CREATE TABLE `Затрата:ЗАД*СПР` 
(  `Ид\ЗРТ^ЗАД` BIGINT NOT NULL
,  `Ид_ВЗАТ\ЗРТ^СПР` BIGINT NOT NULL
,   `Объем затраты` CHAR (150) NOT NULL
,    PRIMARY KEY (`Ид\ЗРТ^ЗАД`, `Ид_ВЗАТ\ЗРТ^СПР`)
,    CONSTRAINT `Ид\ЗРТ^ЗАД` FOREIGN KEY (`Ид\ЗРТ^ЗАД`) REFERENCES `Задание` (`Ид`)
,    CONSTRAINT `Ид_ВЗАТ\ЗРТ^СПР` FOREIGN KEY (`Ид_ВЗАТ\ЗРТ^СПР`) REFERENCES `Справка` (`Ид`)
);
INSERT INTO `Затрата:ЗАД*СПР` SET 
    `Ид\ЗРТ^ЗАД` = (SELECT `Ид` FROM `Задание` WHERE `Регномер задания`="001"), 
    `Ид_ВЗАТ\ЗРТ^СПР` = (SELECT `Ид` FROM `Справка` WHERE `Слк`="ВЗАТ" AND `Код`="мал"),
    `Объем затраты` = "576 руб.";

SELECT * FROM `Затрата:ЗАД*СПР`;


DROP TABLE IF EXISTS `Особое условие клиента\ЗАД`;
CREATE TABLE `Особое условие клиента\ЗАД` 
(   `Ид` BIGINT NOT NULL AUTO_INCREMENT
,   `Нпп условия` CHAR (10) NOT NULL
,    `Ид\ОУК^ЗАД` BIGINT NOT NULL 
,   `Ид_ВИДУ\ОУК^СПР` BIGINT NOT NULL
,   `Содержание условия` CHAR (150) NOT NULL
,    PRIMARY KEY (`Ид`)   
,    CONSTRAINT `Ун1\ОУК` UNIQUE KEY (`Нпп условия`, `Ид\ОУК^ЗАД`)
,    CONSTRAINT `Ид\ОУК^ЗАД` FOREIGN KEY (`Ид\ОУК^ЗАД`) REFERENCES `Задание` (`Ид`)
,    CONSTRAINT `Ид_ВИДУ\ОУК^СПР` FOREIGN KEY (`Ид_ВИДУ\ОУК^СПР`) REFERENCES  `Справка` (`Ид`)
);
INSERT INTO `Особое условие клиента\ЗАД` SET 
    `Ид` = DEFAULT, 
    `Нпп условия` = "1", 
    `Ид\ОУК^ЗАД` = (SELECT `Ид` FROM `Задание` WHERE `Регномер задания`="001"), 
    `Ид_ВИДУ\ОУК^СПР` = (SELECT `Ид` FROM `Справка` WHERE `Слк`="ВИДУ" AND `Код`="про"),
    `Содержание условия` = "Сделать всё качественно";

SELECT * FROM `Особое условие клиента\ЗАД`;


