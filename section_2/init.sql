DROP SCHEMA IF EXISTS "ASSESSMENT" CASCADE;
CREATE SCHEMA "ASSESSMENT";

-- Table: ASSESSMENT.TB_ITEM

DROP TABLE IF EXISTS "ASSESSMENT"."TB_ITEM" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_ITEM"
(
    "ITEM_ID_NO" SERIAL PRIMARY KEY,
    "ITEM_NAME" VARCHAR(100) NOT NULL,
    "MANUFACTURER_NAME" VARCHAR(100),
    "COST_NO" NUMERIC(10,2) NOT NULL,
    "WEIGHT_KG" NUMERIC(10,2) NOT NULL,
    -- Audit columns
    "CREATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "UPDATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "CREATED_BY_ID_NO" INT NOT NULL,
    "UPDATED_BY_ID_NO" INT NOT NULL
);

COMMENT ON TABLE "ASSESSMENT"."TB_ITEM"
    IS 'Stores all items available for sale on the e-commerce platform.';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."ITEM_ID_NO"
    IS 'Primary key: unique identifier for each item.';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."ITEM_NAME"
    IS 'Name of the item';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."MANUFACTURER_NAME"
    IS 'Manufacturer or brand of the item';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."COST_NO"
    IS 'Cost (price) of one unit of the item';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."WEIGHT_KG"
    IS 'Weight of one unit of the item (in kilograms)';
	
COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."CREATED_DTTM" IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."UPDATED_DTTM" IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."CREATED_BY_ID_NO" IS 'Numeric ID of the user or process that created this record.';
COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."UPDATED_BY_ID_NO" IS 'Numeric ID of the user or process that last updated this record.';	

-- ================================
-- Table: ASSESSMENT.TB_MEMBERSHIP
-- ================================

DROP TABLE IF EXISTS "ASSESSMENT"."TB_MEMBERSHIP" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_MEMBERSHIP"
(
    "MEMBERSHIP_ID_TXT" VARCHAR(100) PRIMARY KEY,
    "FIRST_NAME" VARCHAR(100) NOT NULL,
    "LAST_NAME" VARCHAR(100),
    "EMAIL_ADDR" VARCHAR(100) UNIQUE NOT NULL,	
	"MOBILE_NO" VARCHAR(15) NOT NULL,
	"BIRTH_DT" DATE NOT NULL,
	"ABOVE_18_IND" BOOLEAN NOT NULL,
    -- Audit columns
    "CREATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "UPDATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "CREATED_BY_ID_NO" INT NOT NULL,
    "UPDATED_BY_ID_NO" INT NOT NULL
);

COMMENT ON TABLE "ASSESSMENT"."TB_MEMBERSHIP"
    IS 'Stores information about all members (successful applications).';

COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."MEMBERSHIP_ID_TXT"
    IS 'Primary key. Auto-generated in the format <last_name>_<first5chars_of_SHA256(birthday)>. Example: tan_a1b2c';

COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."FIRST_NAME"
    IS 'Member first name';
	
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."LAST_NAME"
    IS 'Member last name';	

COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."EMAIL_ADDR"
    IS 'Unique email address of the member';
	
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."MOBILE_NO"
    IS '8-digit mobile number of the member.';	
	
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."BIRTH_DT"
    IS 'Date of birth of the member.';		
	
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."ABOVE_18_IND"
    IS 'Boolean flag indicating if member was at least 18 years old as of 1 Jan 2022.';	

COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."CREATED_DTTM" IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."UPDATED_DTTM" IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."CREATED_BY_ID_NO" IS 'Numeric ID of the user or process that created this record.';
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."UPDATED_BY_ID_NO" IS 'Numeric ID of the user or process that last updated this record.';
	
-- ================================
-- Table: ASSESSMENT.TB_TRANSACTION
-- ================================

DROP TABLE IF EXISTS "ASSESSMENT"."TB_TRANSACTION" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_TRANSACTION"
(
    "TRANSACTION_ID_NO" SERIAL PRIMARY KEY,
    "MEMBERSHIP_ID_TXT" VARCHAR(100) NOT NULL,
    "TOTAL_PRICE_NO" NUMERIC(12,2),
    "TOTAL_WEIGHT_KG" NUMERIC(12,2),
	"TRANSACTION_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Audit columns
    "CREATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "UPDATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "CREATED_BY_ID_NO" INT NOT NULL,
    "UPDATED_BY_ID_NO" INT NOT NULL,
    CONSTRAINT "FK_MEMBERSHIP_ID_TXT" FOREIGN KEY ("MEMBERSHIP_ID_TXT")
        REFERENCES "ASSESSMENT"."TB_MEMBERSHIP" ("MEMBERSHIP_ID_TXT") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION		
);

COMMENT ON TABLE "ASSESSMENT"."TB_TRANSACTION"
    IS 'Stores all purchase transactions made by members.';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TRANSACTION_ID_NO"
    IS 'Primary key: unique identifier for each transaction.';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."MEMBERSHIP_ID_TXT"
    IS 'Links the transaction to the member who made it. References TB_MEMBERSHIP(MEMBERSHIP_ID_NO)';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TOTAL_PRICE_NO"
    IS 'Total item price for this transaction';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TOTAL_WEIGHT_KG"
    IS 'Total item weight for this transaction';
	
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TRANSACTION_DTTM"
    IS 'Date and time when the transaction occurred. Defaults to current timestamp.';	

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."CREATED_DTTM" IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."UPDATED_DTTM" IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."CREATED_BY_ID_NO" IS 'Numeric ID of the user or process that created this record.';
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."UPDATED_BY_ID_NO" IS 'Numeric ID of the user or process that last updated this record.';

	
-- =============================================
-- Table: ASSESSMENT.TB_TRANSACTION_ITEM_MAPPING
-- =============================================

DROP TABLE IF EXISTS "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"
(
	"TRANSACTION_ID_NO" INT NOT NULL,
    "ITEM_ID_NO" INT NOT NULL,
    "QUANTITY_NO" INT NOT NULL CHECK ("QUANTITY_NO" > 0),
    -- Audit columns
    "CREATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "UPDATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "CREATED_BY_ID_NO" INT NOT NULL,
    "UPDATED_BY_ID_NO" INT NOT NULL,
	CONSTRAINT "TB_TRANSACTION_ITEM_MAPPING_pkey" PRIMARY KEY ("TRANSACTION_ID_NO", "ITEM_ID_NO"),
    CONSTRAINT "fk_transaction" FOREIGN KEY ("TRANSACTION_ID_NO") 
        REFERENCES "ASSESSMENT"."TB_TRANSACTION" ("TRANSACTION_ID_NO")
        ON DELETE CASCADE,
    CONSTRAINT "fk_item" FOREIGN KEY ("ITEM_ID_NO") 
        REFERENCES "ASSESSMENT"."TB_ITEM" ("ITEM_ID_NO")
        ON DELETE RESTRICT	
);	

COMMENT ON TABLE "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"
    IS 'Associates transactions with items purchased (many-to-many relationship).';
	
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"."TRANSACTION_ID_NO"
    IS 'The transaction in which the item was purchased. References transactions(transaction_id)';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"."ITEM_ID_NO"
    IS 'The item purchased. References TB_ITEM(ITEM_ID_NO)';		
	
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"."QUANTITY_NO"
    IS 'Number of units of the item bought in this transaction. Must be > 0.';	
	
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"."CREATED_DTTM" IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"."UPDATED_DTTM" IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"."CREATED_BY_ID_NO" IS 'Numeric ID of the user or process that created this record.';
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"."UPDATED_BY_ID_NO" IS 'Numeric ID of the user or process that last updated this record.';	

-- ==========================================
-- Table: ASSESSMENT.TB_REJECTED_APPLICATION
-- =========================================
CREATE TABLE "ASSESSMENT"."TB_REJECTED_APPLICATION" (
    "APPLICATION_ID_NO" SERIAL PRIMARY KEY,
    "RAW_NAME" VARCHAR(255),        
    "EMAIL_ADDR" VARCHAR(100),	
    "MOBILE_NO" VARCHAR(15),
	"BIRTH_DT" DATE,
    "REJECT_REASON_TXT" TEXT NOT NULL,
    -- Audit columns
    "CREATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "UPDATED_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "CREATED_BY_ID_NO" INT NOT NULL,
    "UPDATED_BY_ID_NO" INT NOT NULL
);

COMMENT ON TABLE "ASSESSMENT"."TB_REJECTED_APPLICATION" IS 'Stores all applications that failed validation, including reason for rejection.';

COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."APPLICATION_ID_NO" IS 'Unique surrogate key for the rejected application.';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."RAW_NAME" IS 'Original raw name string submitted by applicant (may be empty or invalid).';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."EMAIL_ADDR" IS 'Email provided by applicant (may be invalid).';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."MOBILE_NO" IS 'Mobile number provided by applicant (may be invalid or missing).';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."BIRTH_DT" IS 'Birthday provided by applicant (may be invalid or NULL).';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."REJECT_REASON_TXT" IS 'Reason why the application was rejected (e.g., invalid email, underage, missing name).';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."CREATED_DTTM" IS 'Timestamp when the record was created.';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."UPDATED_DTTM" IS 'Timestamp when the record was last updated.';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."CREATED_BY_ID_NO" IS 'Numeric ID of the user or process that created this record.';
COMMENT ON COLUMN "ASSESSMENT"."TB_REJECTED_APPLICATION"."UPDATED_BY_ID_NO" IS 'Numeric ID of the user or process that last updated this record.';

	
-- Test Data

TRUNCATE TABLE "ASSESSMENT"."TB_MEMBERSHIP" CASCADE;

INSERT INTO "ASSESSMENT"."TB_MEMBERSHIP" ("MEMBERSHIP_ID_TXT", "FIRST_NAME", "LAST_NAME", "EMAIL_ADDR", "MOBILE_NO", "BIRTH_DT", "ABOVE_18_IND", "CREATED_BY_ID_NO", "UPDATED_BY_ID_NO")
VALUES
('smith_a1b2c', 'John', 'Smith', 'john.smith@emailprovider.com', '91234567', '1990-05-15', TRUE, 1, 1),
('lee_d3e4f', 'Alice', 'Lee', 'alice.lee@emailprovider.net', '92345678', '1985-09-20', TRUE, 1, 1),
('tan_g7h8i', 'David', 'Tan', 'david.tan@emailprovider.com', '93456789', '2000-01-10', TRUE, 1, 1),
('ong_j9k0l', 'Sarah', 'Ong', 'sarah.ong@emailprovider.net', '94567890', '1999-11-30', TRUE, 1, 1),
('wong_m1n2o', 'Michael', 'Wong', 'michael.wong@emailprovider.com', '95678901', '1992-03-25', TRUE, 1, 1),
('ng_p3q4r', 'Rachel', 'Ng', 'rachel.ng@emailprovider.net', '96789012', '1995-07-12', TRUE, 1, 1),
('lim_s5t6u', 'Benjamin', 'Lim', 'ben.lim@emailprovider.com', '97890123', '1988-02-18', TRUE, 1, 1),
('koh_v7w8x', 'Cheryl', 'Koh', 'cheryl.koh@emailprovider.net', '98901234', '1991-06-07', TRUE, 1, 1),
('goh_y9z0a', 'Daniel', 'Goh', 'daniel.goh@emailprovider.com', '99012345', '1993-04-11', TRUE, 1, 1),
('chan_b2c3d', 'Grace', 'Chan', 'grace.chan@emailprovider.net', '90123456', '1997-08-14', TRUE, 1, 1),
('foo_e4f5g', 'Henry', 'Foo', 'henry.foo@emailprovider.com', '91239876', '1989-12-02', TRUE, 1, 1),
('chua_h6i7j', 'Isabel', 'Chua', 'isabel.chua@emailprovider.net', '92348765', '1994-01-21', TRUE, 1, 1),
('teo_k8l9m', 'Jason', 'Teo', 'jason.teo@emailprovider.com', '93457654', '1996-09-09', TRUE, 1, 1),
('yap_n0o1p', 'Kelly', 'Yap', 'kelly.yap@emailprovider.net', '94566543', '1990-11-01', TRUE, 1, 1),
('loh_q2r3s', 'Leon', 'Loh', 'leon.loh@emailprovider.com', '95675432', '1987-03-18', TRUE, 1, 1),
('phua_t4u5v', 'Megan', 'Phua', 'megan.phua@emailprovider.net', '96784321', '1992-07-24', TRUE, 1, 1),
('sim_w6x7y', 'Nicholas', 'Sim', 'nicholas.sim@emailprovider.com', '97893210', '1991-05-30', TRUE, 1, 1),
('chia_z8a9b', 'Olivia', 'Chia', 'olivia.chia@emailprovider.net', '98902109', '1993-02-05', TRUE, 1, 1),
('ang_c1d2e', 'Peter', 'Ang', 'peter.ang@emailprovider.com', '99011098', '1998-06-17', TRUE, 1, 1),
('heng_f3g4h', 'Queenie', 'Heng', 'queenie.heng@emailprovider.net', '90120987', '1995-10-22', TRUE, 1, 1);

TRUNCATE TABLE "ASSESSMENT"."TB_ITEM" CASCADE;

INSERT INTO "ASSESSMENT"."TB_ITEM" ("ITEM_NAME", "MANUFACTURER_NAME", "COST_NO", "WEIGHT_KG", "CREATED_BY_ID_NO", "UPDATED_BY_ID_NO")
VALUES
('Laptop', 'TechCorp', 1200.00, 2.5, 1, 1),
('Smartphone', 'MobileMakers', 800.00, 0.5, 1, 1),
('Headphones', 'SoundWave', 150.00, 0.3, 1, 1),
('Tablet', 'TechCorp', 600.00, 0.8, 1, 1),
('Camera', 'PhotoPro', 1000.00, 1.2, 1, 1),
('Monitor', 'ViewMax', 300.00, 4.0, 1, 1),
('Keyboard', 'KeyPro', 100.00, 0.7, 1, 1),
('Mouse', 'ClickTech', 50.00, 0.2, 1, 1),
('Printer', 'PrintCo', 400.00, 6.0, 1, 1),
('Speaker', 'SoundWave', 250.00, 2.0, 1, 1),
('Router', 'NetLink', 120.00, 1.0, 1, 1),
('External HDD', 'DataStore', 200.00, 0.5, 1, 1),
('Power Bank', 'ChargeIt', 60.00, 0.4, 1, 1),
('Smartwatch', 'TimeTech', 180.00, 0.3, 1, 1),
('Drone', 'FlyHigh', 1500.00, 3.0, 1, 1),
('Gaming Console', 'GameBox', 500.00, 2.8, 1, 1),
('VR Headset', 'VisionNext', 700.00, 1.5, 1, 1),
('Projector', 'ViewMax', 850.00, 3.2, 1, 1),
('Mic', 'SoundWave', 120.00, 0.6, 1, 1),
('SSD Drive', 'DataStore', 250.00, 0.4, 1, 1);

TRUNCATE TABLE "ASSESSMENT"."TB_TRANSACTION" CASCADE;

INSERT INTO "ASSESSMENT"."TB_TRANSACTION" ("MEMBERSHIP_ID_TXT", "TOTAL_PRICE_NO", "TOTAL_WEIGHT_KG", "CREATED_BY_ID_NO", "UPDATED_BY_ID_NO")
VALUES
('smith_a1b2c', 1950.00, 3.3, 1, 1),
('lee_d3e4f', 1600.00, 1.0, 1, 1),
('tan_g7h8i', 2150.00, 3.0, 1, 1),
('ong_j9k0l', 1200.00, 2.5, 1, 1),
('wong_m1n2o', 2400.00, 3.6, 1, 1),
('ng_p3q4r', 300.00, 4.0, 1, 1),
('lim_s5t6u', 180.00, 0.6, 1, 1),
('koh_v7w8x', 2200.00, 4.5, 1, 1),
('goh_y9z0a', 400.00, 6.0, 1, 1),
('chan_b2c3d', 250.00, 0.9, 1, 1),
('foo_e4f5g', 500.00, 2.8, 1, 1),
('chua_h6i7j', 700.00, 1.5, 1, 1),
('teo_k8l9m', 1800.00, 2.0, 1, 1),
('yap_n0o1p', 850.00, 3.2, 1, 1),
('loh_q2r3s', 360.00, 1.0, 1, 1),
('phua_t4u5v', 2500.00, 3.5, 1, 1),
('sim_w6x7y', 200.00, 0.5, 1, 1),
('chia_z8a9b', 950.00, 2.2, 1, 1),
('ang_c1d2e', 3000.00, 4.2, 1, 1),
('heng_f3g4h', 120.00, 0.6, 1, 1);

TRUNCATE TABLE "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING" CASCADE;

INSERT INTO "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING" ("TRANSACTION_ID_NO", "ITEM_ID_NO", "QUANTITY_NO", "CREATED_BY_ID_NO", "UPDATED_BY_ID_NO")
VALUES
-- Transaction 1
(1, 1, 1, 1, 1),  -- Laptop
(1, 3, 2, 1, 1),  -- Headphones

-- Transaction 2
(2, 2, 1, 1, 1),  -- Smartphone
(2, 12, 1, 1, 1), -- External HDD

-- Transaction 3
(3, 1, 1, 1, 1),  -- Laptop
(3, 4, 1, 1, 1),  -- Tablet
(3, 3, 1, 1, 1),  -- Headphones

-- Transaction 4
(4, 5, 1, 1, 1),  -- Camera

-- Transaction 5
(5, 4, 2, 1, 1),  -- Tablets
(5, 6, 1, 1, 1),  -- Monitor
(5, 3, 1, 1, 1),  -- Headphones

-- Transaction 6
(6, 7, 1, 1, 1),  -- Keyboard
(6, 8, 1, 1, 1),  -- Mouse

-- Transaction 7
(7, 9, 1, 1, 1),  -- Printer

-- Transaction 8
(8, 15, 1, 1, 1), -- Drone
(8, 2, 1, 1, 1),  -- Smartphone

-- Transaction 9
(9, 10, 1, 1, 1), -- Speaker

-- Transaction 10
(10, 14, 1, 1, 1), -- Smartwatch

-- Transaction 11
(11, 16, 1, 1, 1), -- Gaming Console

-- Transaction 12
(12, 17, 1, 1, 1), -- VR Headset

-- Transaction 13
(13, 1, 1, 1, 1),  -- Laptop

-- Transaction 14
(14, 11, 1, 1, 1), -- Router

-- Transaction 15
(15, 18, 1, 1, 1), -- Projector

-- Transaction 16
(16, 19, 1, 1, 1), -- Mic

-- Transaction 17
(17, 20, 1, 1, 1), -- SSD Drive

-- Transaction 18
(18, 5, 1, 1, 1),  -- Camera

-- Transaction 19
(19, 2, 1, 1, 1),  -- Smartphone

-- Transaction 20
(20, 1, 1, 1, 1);  -- Laptop


INSERT INTO "ASSESSMENT"."TB_REJECTED_APPLICATION" 
("RAW_NAME", "EMAIL_ADDR", "MOBILE_NO", "BIRTH_DT", "REJECT_REASON_TXT", "CREATED_BY_ID_NO", "UPDATED_BY_ID_NO")
VALUES
('','noemail@emailprovider.com','9123456','2005-05-15','Missing name field',1,1),
('Tom H','tom.h@gmail.com','92345678','2010-09-20','Invalid email domain',1,1),
('Mary P','mary.p@emailprovider.net','1234567','2006-01-10','Invalid mobile number',1,1),
(NULL,'john.doe@emailprovider.org','93456789','2004-11-30','Invalid email domain',1,1),
('Anna W','anna.w@emailprovider.com','912345','2008-03-25','Invalid mobile number',1,1),
('','no_name@emailprovider.net','9456789','2003-07-12','Missing name field',1,1),
('Bob L','bob.l@othermail.com','96789012','2007-02-18','Invalid email domain',1,1),
('','cheryl.koh@emailprovider.net','9789012','2011-06-07','Missing name field',1,1),
('Daniel G','daniel.goh@gmail.com','9890123','2009-04-11','Invalid email domain',1,1),
(NULL,'grace.chan@emailprovider.net','901234','2012-08-14','Missing name field',1,1),
('Henry F','henry.foo@email.com','912398','2005-12-02','Invalid email domain',1,1),
('Isabel C','isabel.chua@emailprovider.org','923487','2006-01-21','Invalid email domain',1,1),
('Jason T','','934576','2008-09-09','Missing email field',1,1),
('Kelly Y','kelly.yap@emailprovider.net','945665','2010-11-01','Invalid mobile number',1,1),
('Leon L','leon.loh@email.com','956754','2004-03-18','Invalid email domain',1,1),
('Megan P','','967843','2007-07-24','Missing email field',1,1),
('Nicholas S','nicholas.sim@emailprovider.net','978932','2011-05-30','Invalid mobile number',1,1),
('Olivia C','olivia.chia@email.com','989021','2009-02-05','Invalid email domain',1,1),
('Peter A','','990110','2006-06-17','Missing email field',1,1),
('Queenie H','queenie.heng@emailprovider.org','901209','2008-10-22','Invalid email domain',1,1);


-- 	Create role TEAM_LOGISTICS
DROP ROLE IF EXISTS "ROLE_LOGISTICS";
CREATE ROLE "ROLE_LOGISTICS";
COMMENT ON ROLE "ROLE_LOGISTICS" IS 'This role is for logistics team';

-- 	Create role TEAM_ANALYTICS
DROP ROLE IF EXISTS "ROLE_ANALYTICS";
CREATE ROLE "ROLE_ANALYTICS";
COMMENT ON ROLE "ROLE_ANALYTICS" IS 'This role is for analytics team';

-- 	Create role TEAM_SALES
DROP ROLE IF EXISTS "ROLE_SALES";
CREATE ROLE "ROLE_SALES";
COMMENT ON ROLE "ROLE_SALES" IS 'This role is for sales team';

-- Create user accounts for team members and assign roles
DROP USER IF EXISTS "USER_LOGISTIC";
CREATE USER "USER_LOGISTIC" WITH PASSWORD 'logistic_pass';
GRANT "ROLE_LOGISTICS" TO "USER_LOGISTIC";

DROP USER IF EXISTS "USER_ANALYST";
CREATE USER "USER_ANALYST" WITH PASSWORD 'analyst_pass';
GRANT "ROLE_ANALYTICS" TO "USER_ANALYST";

DROP USER IF EXISTS "USER_SALES";
CREATE USER "USER_SALES" WITH PASSWORD 'sales_pass';
GRANT "ROLE_SALES" TO "USER_SALES";

-- PERMISSIONS

-- Logictics Team
-- Allow Logistics to SELECT transactions and transaction_items
GRANT SELECT ON "ASSESSMENT"."TB_TRANSACTION", "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING", "ASSESSMENT"."TB_ITEM" TO "ROLE_LOGISTICS";

-- Allow Logistics to UPDATE transactions (e.g., mark completed)
GRANT UPDATE ON "ASSESSMENT"."TB_TRANSACTION" TO "ROLE_LOGISTICS";

-- Analytics 
-- Read-only access to all tables
GRANT SELECT ON "ASSESSMENT"."TB_MEMBERSHIP", "ASSESSMENT"."TB_ITEM", "ASSESSMENT"."TB_TRANSACTION", "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING", "ASSESSMENT"."TB_REJECTED_APPLICATION" TO "ROLE_ANALYTICS";

-- Sales 
-- Manage items
GRANT INSERT, UPDATE, DELETE ON "ASSESSMENT"."TB_ITEM" TO "ROLE_SALES";
-- Optionally: SELECT access to see items
GRANT SELECT ON "ASSESSMENT"."TB_ITEM" TO "ROLE_SALES";
