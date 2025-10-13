-- schema.sql
-- Database: Lost and Found Management System
-- Created by: Suraj Singh Bisht

-- Create USERS table
CREATE TABLE users (
 user_id NUMBER PRIMARY KEY,    
  name VARCHAR2(100) NOT NULL,
  email VARCHAR2(150) UNIQUE,
  phone VARCHAR2(15),
  role VARCHAR2(20) CHECK (role IN ('student','staff','admin')),
  password VARCHAR2(100)
);



-- Lost Item Table
CREATE TABLE lostitem (
  lost_id NUMBER PRIMARY KEY,
  user_id NUMBER NOT NULL,
  item_name VARCHAR2(100),
  category VARCHAR2(50),
  description VARCHAR2(200),
  location_lost VARCHAR2(100),
  date_lost DATE,
  status VARCHAR2(20) DEFAULT 'unfound',
  CONSTRAINT fk_user_lost FOREIGN KEY (user_id)
      REFERENCES users(user_id) ON DELETE CASCADE
);


CREATE SEQUENCE lostitem_seq
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER lostitem_trigger
BEFORE INSERT ON lostitem
FOR EACH ROW
BEGIN
  IF :new.lost_id IS NULL THEN
    SELECT lostitem_seq.NEXTVAL INTO :new.lost_id FROM dual;
  END IF;
END;
/


-- ============================================
-- Table: FoundItem
-- ============================================

CREATE TABLE founditem (
    found_id NUMBER PRIMARY KEY,
    user_id NUMBER REFERENCES users(user_id),
    item_name VARCHAR2(100),
    category VARCHAR2(50),
    description VARCHAR2(255),
    location_found VARCHAR2(100),
    date_found DATE,
    status VARCHAR2(20)
);
-- Sequence for FoundItem table
CREATE SEQUENCE found_seq
START WITH 1
INCREMENT BY 1;

-- Trigger to auto-assign found_id
CREATE OR REPLACE TRIGGER found_trigger
BEFORE INSERT ON founditem
FOR EACH ROW
BEGIN
  IF :new.found_id IS NULL THEN
    SELECT found_seq.NEXTVAL INTO :new.found_id FROM dual;
  END IF;
END;
/


-- ============================================
-- Table: Match
-- ============================================

CREATE TABLE match_table (
    match_id NUMBER PRIMARY KEY,
    lost_id NUMBER REFERENCES lostitem(lost_id),
    found_id NUMBER REFERENCES founditem(found_id),
    match_score NUMBER(5,2),
    date_matched DATE
);
/*
8️⃣ What This Table Does

Each row represents a potential match between a lost item and a found item.

match_score = how close they are (for example, based on category, date, and location).

Later, the backend can automatically calculate this score.
*/

-- Sequence for Match table
CREATE SEQUENCE match_seq
START WITH 1
INCREMENT BY 1;

-- Trigger to auto-assign match_id
CREATE OR REPLACE TRIGGER match_trigger
BEFORE INSERT ON match_table
FOR EACH ROW
BEGIN
  IF :new.match_id IS NULL THEN
    SELECT match_seq.NEXTVAL INTO :new.match_id FROM dual;
  END IF;
END;
/


-- ============================================
-- Table: Notification
-- ============================================

CREATE TABLE notification (
    notif_id NUMBER PRIMARY KEY,
    user_id NUMBER REFERENCES users(user_id),
    message VARCHAR2(255),
    created_at DATE
);

-- Sequence for Notification table
CREATE SEQUENCE notif_seq
START WITH 1
INCREMENT BY 1;

-- Trigger to auto-assign notif_id
CREATE OR REPLACE TRIGGER notif_trigger
BEFORE INSERT ON notification
FOR EACH ROW
BEGIN
  IF :new.notif_id IS NULL THEN
    SELECT notif_seq.NEXTVAL INTO :new.notif_id FROM dual;
  END IF;
END;
/
