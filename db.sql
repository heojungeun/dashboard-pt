SET @tables = NULL;
SELECT
    GROUP_CONCAT(table_schema, '.', table_name)
INTO @tables FROM
    information_schema.tables
WHERE
    table_schema = 'YOURDATABSE'; -- specify DB name here.

SET @tables = CONCAT('DROP TABLE ', @tables);
PREPARE stmt FROM @tables;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

#Patient Table
CREATE TABLE Patient(                             /*환자 초기 정보*/
    PID int(5) NOT NULL AUTO_INCREMENT,               /*환자 아이디*/
    name char(4) NOT NULL,                            /*환자 이름*/
    telecom CHAR(13),                                  /*환자 전화번호*/
    address varchar(50);                              /*환자 주소*/
    gender enum('F','M') NOT NULL,                    /*환자 성별*/
    birthDate DATE NOT NULL,                        /*환자 생년월일*/
    generalPractitioner INT(5),                      /*배정된 주치의*/
    bloodtype enum('A','B','O','AB'),                 /*환자 혈액형*/
    PRIMARY KEY(PID),
    FOREIGN KEY (generalPractitioner)
        REFERENCES Doctor (DID)
);

#Doctor Table
CREATE TABLE Doctor(                              /*의사 초기 정보*/
    DID int(5) NOT NULL AUTO_INCREMENT,               /*의사 아이디*/
    name char(4) NOT NULL,                            /*의사 이름*/
    elecom CHAR(13),                                  /*의사 전화번호*/
    address varchar(50);                              /*의사 주소*/
    gender enum('F','M') NOT NULL,                    /*의사 성별*/
    birthDate DATE NOT NULL,                         /*의사 생년월일*/
    qualification int(5) NOT NULL,                    /*의사 면허번호*/
    department varchar(30),                           /*의사 진료과목*/
    PW VARCHAR(15),                                   /*의사 비밀번호*/
    PRIMARY KEY(DID)
);

#Nurse Table
CREATE TABLE Nurse(                               /*간호사 초기 정보*/
    NID int(5) NOT NULL AUTO_INCREMENT,               /*간호사 아이디*/
    name char(4) NOT NULL,                            /*간호사 이름*/
    telecom CHAR(13),                                  /*간호사 전화번호*/
    address varchar(50),                              /*간호사 주소*/
    gender enum('F','M') NOT NULL,                    /*간호사 성별*/
    birthDate DATE NOT NULL,                        /*간호사 생년월일*/
    qualification int(5) NOT NULL,                    /*간호사 면허번호*/
    department VARCHAR(30),                        /*간호사 진료과목*/
    PW VARCHAR(15),                                  /*의사 비밀번호*/
    PRIMARY KEY (NID)
);

#Examination Table
CREATE TABLE Examination(                             /*문진 목록*/
    ExNo INT(5) NOT NULL AUTO_INCREMENT,               /*문진 번호*/
    PID int(5), NOT NULL,                             /*환자 번호*/
    DID INT(5) NOT NULL,                             /*의사 번호*/
    Edate TIMESTAMP DEFAULT NOW(),                    /*일시*/
    imp varchar(20),                                  /*진단명*/
    weight int,                                       /*체중*/
    height int,                                       /*신장*/
    Disability boolean,                               /*장애유무*/
    Drug boolean,                                     /*투약 or 복용약물 유무*/
    family boolean,                                   /*가족병력 유무*/
    PH varchar(50),                                   /*과거력*/
    opinion VARCHAR(500),                             /*의사 소견*/
    PRIMARY KEY (ExNo),
    FOREIGN KEY (PID)
        REFERENCES Patient (PID),
    FOREIGN KEY (DID)
        REFERENCES Doctor (DID)
);

#DocInput Table
CREATE TABLE DocInput (
    DINo INT(5) NOT NULL AUTO_INCREMENT,               /*일반진료 번호*/
    PID INT(5) NOT NULL,                               /*환자 번호*/
    DID INT(5) NOT NULL,                               /*의사 번호*/
    Ddate TIMESTAMP DEFAULT NOW(),                     /*일시*/
    opinion VARCHAR(500),                              /*의사 소견*/
    prescription VARCHAR(500),                         /*의사 처방*/
    PRIMARY KEY (DINo),
    FOREIGN KEY (PID)
        REFERENCES Patient (PID),
    FOREIGN KEY (DID)
        REFERENCES Doctor (DID)
);

#NurInput Table
CREATE TABLE NurInput (
    NINo INT(5) NOT NULL AUTO_INCREMENT,               /*바이탈 체크 번호*/
    PID INT(5) NOT NULL,                               /*환자 번호*/
    NID INT(5) NOT NULL,                               /*간호사 번호*/
    Ndate TIMESTAMP DEFAULT NOW(),                     /*일시*/
    BP INT,                                            /*혈압*/
    RR INT,                                            /*호흡수*/
    BT DECIMAL(3 , 1 ),                                /*체온*/
    PR INT,                                            /*맥박*/
    BS INT,                                            /*혈당량*/
    IT INT,                                            /*섭취량*/
    OP INT,                                            /*배설량*/
    SpO2 DECIMAL(3 , 1 ),                              /*산소 포화도*/
    PRIMARY KEY (NINo),
    FOREIGN KEY (PID)
        REFERENCES Patient (PID),
    FOREIGN KEY (NID)
        REFERENCES Nurse (NID)
);

#임계치
INSERT INTO Doctor VALUES (11901, '이드리', '010-2650-7448', '대구광역시 북구 침산동 400-7',  'F', '1980-09-06', 18467, 'Acute Care Surgery', '1234');
INSERT INTO Doctor VALUES (11902, '이루리', '010-3807-5891', '대구광역시 북구 침산동 400-7',  'F', '1983-09-30', 26500, 'Allergy', '1234');
INSERT INTO Doctor VALUES (11903, '이모아', '010-6729-4372', '대구광역시 북구 침산동 420-7',  'F', '2006-07-25', 19169, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Doctor VALUES (11904, '이보예', '010-5351-5007', '대구광역시 북구 침산동 420-7',  'F', '2001-07-20', 15724, 'Breast Surgery', '1234');
INSERT INTO Doctor VALUES (11905, '이소유', '010-1104-4395', '대구광역시 북구 침산동 420-7',  'F', '2002-09-05', 11478, 'Cardiology', '1234');
INSERT INTO Doctor VALUES (11906, '이아린', '010-3548-9630', '대구광역시 북구 침산동 420-7',  'F', '1997-05-02', 29358, 'Otorhinolaryngology', '1234');
INSERT INTO Doctor VALUES (11907, '이윤슬', '010-2624-4086', '대구광역시 북구 침산동 420-7',  'F', '1984-10-28', 26962, 'Gastroenterology', '1234');
INSERT INTO Doctor VALUES (11908, '이주비', '010-9955-8757', '대구광역시 북구 침산동 420-7',  'F', '1997-02-04', 24464, 'Orthopedic Surgery', '1234');
INSERT INTO Doctor VALUES (11909, '이채라', '010-1841-4966', '대구광역시 북구 침산동 420-7',  'F', '1966-05-13', 28145, 'Acute Care Surgery', '1234');
INSERT INTO Doctor VALUES (11910, '이하담', '010-7376-3932', '대구광역시 북구 침산동 423-5',  'F', '1980-06-04', 23281, 'Allergy', '1234');
INSERT INTO Doctor VALUES (11911, '이태라', '010-6310-6945', '대구광역시 북구 침산동 423-5',  'F', '1985-06-25', 16827, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Doctor VALUES (11912, '이설리', '010-2442-4628', '대구광역시 북구 칠성동 403-5',  'F', '1966-12-23', 11942, 'Breast Surgery', '1234');
INSERT INTO Doctor VALUES (11913, '이예승', '010-1324-5537', '대구광역시 북구 칠성동 403-5',  'F', '2003-07-09', 32391, 'Cardiology', '1234');
INSERT INTO Doctor VALUES (11914, '이윤비', '010-1540-6119', '대구광역시 북구 칠성동 503-5',  'F', '1986-10-26', 14604, 'Otorhinolaryngology', '1234');
INSERT INTO Doctor VALUES (11915, '이주하', '010-2082-2931', '대구광역시 북구 칠성동 303-5',  'F', '2002-02-21', 12382, 'Gastroenterology', '1234');
INSERT INTO Doctor VALUES (11916, '이채린', '010-6542-4833', '대구광역시 북구 칠성동 103-5',  'F', '1996-03-22', 17421, 'Orthopedic Surgery', '1234');
INSERT INTO Doctor VALUES (11917, '이태린', '010-1118-4639', '대구광역시 북구 칠성동 203-5',  'F', '1960-07-13', 18716, 'Acute Care Surgery', '1234');
INSERT INTO Doctor VALUES (11918, '이하윤', '010-9660-2706', '대구광역시 북구 칠성동 103-5',  'F', '1988-02-29', 19718, 'Allergy', '1234');
INSERT INTO Doctor VALUES (11919, '이설하', '010-9930-3978', '대구광역시 북구 칠성동 403-5',  'F', '1978-03-07', 19895, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Doctor VALUES (11920, '이예온', '010-2306-1676', '대구광역시 북구 칠성동 203-5',  'F', '1980-05-02', 21726, 'Breast Surgery', '1234');
INSERT INTO Doctor VALUES (11921, '이윤솔', '010-2388-5021', '대구광역시 북구 칠성동 423-5',  'F', '1966-05-12', 14771, 'Cardiology', '1234');
INSERT INTO Doctor VALUES (11922, '이지안', '010-8747-6926', '대구광역시 북구 침산동 303-5',  'F', '1981-11-02', 11538, 'Otorhinolaryngology', '1234');
INSERT INTO Doctor VALUES (11923, '이채아', '010-9073-6270', '대구광역시 북구 침산동 403-7',  'F', '2007-09-12', 19912, 'Gastroenterology', '1234');
INSERT INTO Doctor VALUES (11924, '이태아', '010-5829-6779', '대구광역시 북구 산격동 230-7',  'F', '2002-12-07', 25667, 'Orthopedic Surgery', '1234');
INSERT INTO Doctor VALUES (11925, '이하율', '010-5574-5097', '대구광역시 북구 산격동 138-5',  'M', '1988-10-21', 26299, 'Acute Care Surgery', '1234');
INSERT INTO Doctor VALUES (11926, '이세인', '010-6513-3988', '대구광역시 북구 산격동 410-7',  'M', '1968-07-05', 17035, 'Allergy', '1234');
INSERT INTO Doctor VALUES (11927, '이예인', '010-3291-9161', '대구광역시 북구 산격동 138-5',  'M', '2000-05-25', 28703, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Doctor VALUES (11928, '이은유', '010-8637-2357', '대전광역시 서구 내동 152-11',   'M', '1960-09-01', 23811,' Breast Surgery', '1234');
INSERT INTO Doctor VALUES (11929, '이지담', '010-4769-3657', '서울특별시 종로구 종로5가 85-5', 'M', '1986-12-14', 31322, 'Cardiology', '1234');
INSERT INTO Doctor VALUES (11930, '이채원', '010-5575-4031', '대구광역시 북구 산격동 138-5',  'M', '1977-07-18', 30333, 'Otorhinolaryngology', '1234');

INSERT INTO Nurse VALUES (21901, '박태이', '010-2053-7352', '서울특별시 종로구 종로5가 85-5', 'F', '1966-04-18', 17673, 'Orthopedic Surgery', '1234');
INSERT INTO Nurse VALUES (21902, '박해온', '010-1150-6942', '서울특별시 종로구 종로5가 85-5', 'F', '2005-06-25', 15141, 'Acute Care Surgery', '1234');
INSERT INTO Nurse VALUES (21903, '박소예', '010-1726-3967', '대구광역시 북구 산격동 138-5',   'F', '1991-12-17', 28253, 'Allergy', '1234');
INSERT INTO Nurse VALUES (21904, '박예주', '010-3430-1110', '대전광역시 서구 내동 152-11',    'F', '1998-05-09', 25547, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Nurse VALUES (21905, '박은설', '010-8008-1338', '서울특별시 종로구 종로5가 85-5', 'F', '1966-05-08', 27644, 'Breast Surgery', '1234');
INSERT INTO Nurse VALUES (21906, '박진솔', '010-5458-2288', '대전광역시 서구 내동 152-11',    'F', '1990-08-11', 32662, 'Cardiology', '1234');
INSERT INTO Nurse VALUES (21907, '박채영', '010-7755-4946', '서울특별시 종로구 종로5가 85-5', 'F', '1970-11-16', 32757, 'Otorhinolaryngology', '1234');
INSERT INTO Nurse VALUES (21908, '박태인', '010-8909-2212', '대전광역시 서구 내동 152-11',    'F', '1990-07-27', 20037, 'Gastroenterology', '1234');
INSERT INTO Nurse VALUES (21909, '박혜솔', '010-9758-4223', '서울특별시 종로구 종로5가 85-5', 'F', '1976-03-09', 12859, 'Orthopedic Surgery', '1234');
INSERT INTO Nurse VALUES (21910, '박솔리', '010-8589-6422', '대전광역시 서구 내동 152-11',    'F', '2008-11-10', 27529, 'Acute Care Surgery', '1234');
INSERT INTO Nurse VALUES (21911, '박예하', '010-4948-7508', '서울특별시 종로구 종로5가 85-5', 'F', '1963-03-11', 12316, 'Allergy', '1234');
INSERT INTO Nurse VALUES (21912, '박은율', '010-3031-6414', '서울특별시 종로구 종로5가 85-5', 'F', '2003-02-23', 22190, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Nurse VALUES (21913, '박진유', '010-9170-2594', '서울특별시 종로구 종로5가 85-5', 'F', '2003-05-13', 30106, 'Breast Surgery', '1234');
INSERT INTO Nurse VALUES (21914, '박채이', '010-8763-1655', '대구광역시 북구 산격동 138-5',   'F', '1997-12-28', 19264, 'Cardiology', '1234');
INSERT INTO Nurse VALUES (21915, '박혜슬', '010-7411-6359', '대전광역시 서구 내동 152-11',    'F', '1970-10-09', 22648, 'Otorhinolaryngology', '1234');
INSERT INTO Nurse VALUES (21916, '박슬비', '010-7626-1550', '서울특별시 종로구 종로5가 85-5', 'F', '1977-11-15', 27446, 'Gastroenterology', '1234');
INSERT INTO Nurse VALUES (21917, '박유담', '010-6483-7597', '대전광역시 서구 내동 152-11',    'F', '1989-08-30', 23805, 'Orthopedic Surgery', '1234');
INSERT INTO Nurse VALUES (21918, '박은효', '010-4041-3602', '서울특별시 종로구 종로5가 85-5', 'F', '1984-01-22', 15890, 'Acute Care Surgery', '1234');
INSERT INTO Nurse VALUES (21919, '박초율', '010-4352-9374', '대전광역시 서구 내동 152-11',    'F', '1985-01-12', 24370, 'Allergy', '1234');
INSERT INTO Nurse VALUES (21920, '박혜음', '010-1021-4596', '서울특별시 종로구 종로5가 85-5', 'F', '2000-10-11', 15350, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Nurse VALUES (21921, '박슬리', '010-4023-7350', '대전광역시 서구 내동 152-11',    'F', '1965-07-17', 15006, 'Breast Surgery', '1234');
INSERT INTO Nurse VALUES (21922, '박유이', '010-3201-9669', '서울특별시 종로구 종로5가 85-5', 'F', '1971-07-07', 31101, 'Cardiology', '1234');
INSERT INTO Nurse VALUES (21923, '박이원', '010-4486-8281', '서울특별시 종로구 종로5가 85-5', 'F', '1970-08-10', 24393, 'Otorhinolaryngology', '1234');
INSERT INTO Nurse VALUES (21924, '박초이', '010-4734-1999', '서울특별시 종로구 종로5가 85-5', 'F', '1976-07-25', 19629, 'Gastroenterology', '1234');
INSERT INTO Nurse VALUES (21925, '박효인', '010-6420-7940', '대구광역시 북구 산격동 138-5',   'M', '1962-08-07', 12623, 'Orthopedic Surgery', '1234');
INSERT INTO Nurse VALUES (21926, '박이솔', '010-6900-3788', '대전광역시 서구 내동 152-11',    'M', '1964-05-02', 24084, 'Acute Care Surgery', '1234');
INSERT INTO Nurse VALUES (21927, '박가이', '010-8128-3728', '서울특별시 종로구 종로5가 85-5', 'M', '2007-12-02', 19954, 'Allergy', '1234');
INSERT INTO Nurse VALUES (21928, '박려온', '010-4894-4650', '대전광역시 서구 내동 152-11',    'M', '1993-12-19', 18756, 'Anesthesiology&Pain Medicine', '1234');
INSERT INTO Nurse VALUES (21929, '박보늬', '010-2485-7808', '서울특별시 종로구 종로5가 85-5', 'M', '1962-01-03', 11840, 'Breast Surgery', '1234');
INSERT INTO Nurse VALUES (21930, '박모아', '010-2421-4311', '대전광역시 서구 내동 152-11',    'M', '1973-02-28', 13931, 'Cardiology', '1234');

INSERT INTO Patient VALUES (31901, '김나린', '010-8468-6334', '대전광역시 서구 내동 152-11', 'F', '1980-05-03', 11901, 'A');
INSERT INTO Patient VALUES (31902, '김다슬', '010-6502-9170', '서울특별시 종로구 종로5가 85-5', 'F', '1985-11-07', 11902, 'O');
INSERT INTO Patient VALUES (31903, '김라나', '010-5725-1479', '대전광역시 서구 내동 152-11', 'F', '2007-03-11', 11903, 'B');
INSERT INTO Patient VALUES (31904, '김마루', '010-9360-6964', '서울특별시 종로구 종로5가 85-5', 'F', '1999-07-09', 11904, 'B');
INSERT INTO Patient VALUES (31905, '김별솔', '010-4466-5705', '대전광역시 서구 내동 152-11', 'F', '1974-01-27', 11905, 'A');
INSERT INTO Patient VALUES (31906, '김가인', '010-8147-3283', '서울특별시 종로구 종로5가 85-5', 'F', '1985-12-18', 11906, 'B');
INSERT INTO Patient VALUES (31907, '김나샘', '010-6828-9961', '대전광역시 서구 내동 152-11', 'F', '1988-11-04', 11907, 'B');
INSERT INTO Patient VALUES (31908, '김다온', '010-2995-1943', '서울특별시 종로구 종로5가 85-5', 'F', '1972-01-09', 11908, 'O');
INSERT INTO Patient VALUES (31909, '김라윤', '010-4827-5436', '서울특별시 종로구 종로5가 85-5', 'F', '1999-12-13', 11909, 'B');
INSERT INTO Patient VALUES (31910, '김민슬', '010-2394-4605', '서울특별시 종로구 종로5가 85-5', 'F', '1964-08-06', 11910, 'A');
INSERT INTO Patient VALUES (31911, '김별하', '010-3902-2383', '대구광역시 북구 산격동 138-5', 'F', '1998-07-25', 11911, 'B');
INSERT INTO Patient VALUES (31912, '김규비', '010-7422-8717', '대전광역시 서구 내동 152-11', 'F', '2008-07-15', 11912, 'O');
INSERT INTO Patient VALUES (31913, '김나예', '010-9719-9896', '서울특별시 종로구 종로5가 85-5', 'F', '1993-01-26', 11913,'B');
INSERT INTO Patient VALUES (31914, '김다하', '010-5447-1728', '대전광역시 서구 내동 152-11', 'F', '2004-02-06', 11914, 'A');
INSERT INTO Patient VALUES (31915, '김민솔', '010-4772-1539', '서울특별시 종로구 종로5가 85-5', 'F', '1991-03-11', 11915, 'A');
INSERT INTO Patient VALUES (31916, '김보나', '010-1869-9913', '대전광역시 서구 내동 152-11', 'F', '1995-12-30', 11916, 'B');
INSERT INTO Patient VALUES (31917, '김규아', '010-5669-6301', '서울특별시 종로구 종로5가 85-5', 'F', '1979-06-07', 11917, 'A');
INSERT INTO Patient VALUES (31918, '김나슬', '010-7036-9894', '대전광역시 서구 내동 152-11', 'F', '1961-10-29', 11918, 'O');
INSERT INTO Patient VALUES (31919, '김다히', '010-8705-3813', '서울특별시 종로구 종로5가 85-5', 'F', '1963-07-06', 11919, 'B');
INSERT INTO Patient VALUES (31920, '김려온', '010-1325-7674', '서울특별시 종로구 종로5가 85-5', 'F', '1967-06-17', 11920, 'B');
INSERT INTO Patient VALUES (31921, '김민하', '010-4664-5142', '서울특별시 종로구 종로5가 85-5', 'F', '1976-01-23', 11921, 'B');
INSERT INTO Patient VALUES (31922, '김보늬', '010-7711-8255', '대구광역시 북구 산격동 138-5', 'F', '1965-11-06', 11922, 'B');
INSERT INTO Patient VALUES (31923, '김규하', '010-6868-5549', '대전광역시 서구 내동 152-11', 'F', '2005-01-12', 11923, 'B');
INSERT INTO Patient VALUES (31924, '김늘봄', '010-7646-2665', '서울특별시 종로구 종로5가 85-5', 'F', '2003-11-22', 11924, 'A');
INSERT INTO Patient VALUES (31925, '김다흰', '010-2760-2860', '대전광역시 서구 내동 152-11', 'M', '1988-12-09', 11925, 'A');
INSERT INTO Patient VALUES (31926, '김리원', '010-8723-9741', '서울특별시 종로구 종로5가 85-5', 'M', '1977-07-03', 11926, 'B');
INSERT INTO Patient VALUES (31927, '김민예', '010-7531-2317', '대전광역시 서구 내동 152-11', 'M', '1968-06-14', 11927, 'O');
INSERT INTO Patient VALUES (31928, '김보담', '010-3035-2192', '서울특별시 종로구 종로5가 85-5', 'M', '1996-08-06', 11928, 'A');
INSERT INTO Patient VALUES (31929, '김그리', '010-1842-9040', '대전광역시 서구 내동 152-11', 'M', '1997-03-13', 11929, 'B');
INSERT INTO Patient VALUES (31930, '김늘솜', '010-8942-9265', '서울특별시 종로구 종로5가 85-5', 'M', '1982-08-09', 11930, 'A');
