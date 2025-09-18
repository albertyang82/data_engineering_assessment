DROP SCHEMA IF EXISTS "ASSESSMENT" CASCADE;
CREATE SCHEMA "ASSESSMENT";

-- 	Create role TEAM_LOGISTICS
DROP ROLE IF EXISTS "TEAM_LOGISTICS";
CREATE ROLE "TEAM_LOGISTICS";

COMMENT ON ROLE "TEAM_LOGISTICS" IS 'This role is for logistics team';

-- 	Create role TEAM_ANALYTICS
DROP ROLE IF EXISTS "TEAM_ANALYTICS";
CREATE ROLE "TEAM_ANALYTICS";

COMMENT ON ROLE "TEAM_ANALYTICS" IS 'This role is for analytics team';

-- 	Create role TEAM_SALES
DROP ROLE IF EXISTS "TEAM_SALES";
CREATE ROLE "TEAM_SALES";

COMMENT ON ROLE "TEAM_SALES" IS 'This role is for sales team';
	
-- Table: ASSESSMENT.TB_ITEM

DROP TABLE IF EXISTS "ASSESSMENT"."TB_ITEM" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_ITEM"
(
    "ITEM_ID_NO" SERIAL PRIMARY KEY,
    "ITEM_NAME" VARCHAR(100) NOT NULL,
    "MANUFACTURER_NAME" VARCHAR(100),
    "COST_NO" NUMERIC(10,2) NOT NULL,
    "WEIGHT_KG" NUMERIC(10,2) NOT NULL
);

REVOKE ALL ON TABLE "ASSESSMENT"."TB_ITEM" FROM "TEAM_ANALYTICS";
REVOKE ALL ON TABLE "ASSESSMENT"."TB_ITEM" FROM "TEAM_LOGISTICS";
REVOKE ALL ON TABLE "ASSESSMENT"."TB_ITEM" FROM "TEAM_SALES";

GRANT SELECT ON TABLE "ASSESSMENT"."TB_ITEM" TO "TEAM_ANALYTICS";

GRANT SELECT ON TABLE "ASSESSMENT"."TB_ITEM" TO "TEAM_LOGISTICS";

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE "ASSESSMENT"."TB_ITEM" TO "TEAM_SALES";

COMMENT ON TABLE "ASSESSMENT"."TB_ITEM"
    IS 'Contains catalog of items listed for sale on the website';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."ITEM_ID_NO"
    IS 'Unique identifier for each item';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."ITEM_NAME"
    IS 'Name of the item';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."MANUFACTURER_NAME"
    IS 'Manufacturer or brand of the item';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."COST_NO"
    IS 'Cost (price) of one unit of the item';

COMMENT ON COLUMN "ASSESSMENT"."TB_ITEM"."WEIGHT_KG"
    IS 'Weight of one unit of the item (in kilograms)';
	
-- Granting roles for the above privileges for table: TB_ITEM
GRANT SELECT ON TABLE "ASSESSMENT"."TB_ITEM" TO "TEAM_ANALYTICS";
GRANT SELECT ON TABLE "ASSESSMENT"."TB_ITEM" TO "TEAM_LOGISTICS";
GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE "ASSESSMENT"."TB_ITEM" TO "TEAM_SALES";	

-- Table: ASSESSMENT.TB_MEMBERSHIP

DROP TABLE IF EXISTS "ASSESSMENT"."TB_MEMBERSHIP" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_MEMBERSHIP"
(
    "MEMBERSHIP_ID_TXT" VARCHAR(100) PRIMARY KEY,
    "FIRST_NAME" VARCHAR(100) NOT NULL,
    "LAST_NAME" VARCHAR(100),
	"BIRTH_DT" DATE NOT NULL,
    "EMAIL_ADDR" VARCHAR(100) UNIQUE NOT NULL,
	"JOIN_DT" DATE DEFAULT CURRENT_DATE,
	"STATUS_CD" VARCHAR(1) CHECK ("STATUS_CD" IN ('A', 'I'))
);

REVOKE ALL ON TABLE "ASSESSMENT"."TB_MEMBERSHIP" FROM "TEAM_ANALYTICS";

GRANT SELECT ON TABLE "ASSESSMENT"."TB_MEMBERSHIP" TO "TEAM_ANALYTICS";

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
	
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."JOIN_DT"
    IS 'Date the member joined. Defaults to current date.';	
	
COMMENT ON COLUMN "ASSESSMENT"."TB_MEMBERSHIP"."STATUS_CD"
    IS 'Membership status (A: active or I: inactive)';		

-- Table: ASSESSMENT.TB_TRANSACTION

DROP TABLE IF EXISTS "ASSESSMENT"."TB_TRANSACTION" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_TRANSACTION"
(
    "TRANSACTION_ID_NO" SERIAL PRIMARY KEY,
    "MEMBERSHIP_ID_TXT" VARCHAR(100) NOT NULL,
    "TOTAL_PRICE_NO" NUMERIC(12,2),
    "TOTAL_WEIGHT_KG" NUMERIC(12,2),
	"TRANSACTION_DTTM" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "FK_MEMBERSHIP_ID_TXT" FOREIGN KEY ("MEMBERSHIP_ID_TXT")
        REFERENCES "ASSESSMENT"."TB_MEMBERSHIP" ("MEMBERSHIP_ID_TXT") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION		
);

REVOKE ALL ON TABLE "ASSESSMENT"."TB_TRANSACTION" FROM "TEAM_ANALYTICS";
REVOKE ALL ON TABLE "ASSESSMENT"."TB_TRANSACTION" FROM "TEAM_LOGISTICS";

GRANT SELECT ON TABLE "ASSESSMENT"."TB_TRANSACTION" TO "TEAM_ANALYTICS";

GRANT SELECT, UPDATE ON TABLE "ASSESSMENT"."TB_TRANSACTION" TO "TEAM_LOGISTICS";

COMMENT ON TABLE "ASSESSMENT"."TB_TRANSACTION"
    IS 'Represents each purchase made by members';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TRANSACTION_ID_NO"
    IS 'Unique identifier for each transaction';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."MEMBERSHIP_ID_TXT"
    IS 'Links the transaction to the member who made it. References TB_MEMBERSHIP(MEMBERSHIP_ID_NO)';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TOTAL_PRICE_NO"
    IS 'Total item price for this transaction';

COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TOTAL_WEIGHT_KG"
    IS 'Total item weight for this transaction';
	
COMMENT ON COLUMN "ASSESSMENT"."TB_TRANSACTION"."TRANSACTION_DTTM"
    IS 'Date and time when the transaction occurred. Defaults to current timestamp.';	
	
	
-- Table: ASSESSMENT.TB_TRANSACTION_ITEM_MAPPING

DROP TABLE IF EXISTS "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING" CASCADE;

CREATE TABLE IF NOT EXISTS "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING"
(
	"TRANSACTION_ID_NO" INT NOT NULL,
    "ITEM_ID_NO" INT NOT NULL,
    "QUANTITY_NO" INT NOT NULL CHECK ("QUANTITY_NO" > 0),
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
	
-- Test Data

TRUNCATE TABLE "ASSESSMENT"."TB_MEMBERSHIP" CASCADE;

INSERT INTO "ASSESSMENT"."TB_MEMBERSHIP" ("MEMBERSHIP_ID_TXT", "FIRST_NAME", "LAST_NAME", "EMAIL_ADDR", "BIRTH_DT", "STATUS_CD")
VALUES
('chong_1a2b3', 'Fiona', 'Chong', 'fiona.chong@example.com', '1988-02-14', 'A'),
('tan_4c5d6', 'George', 'Tan', 'george.tan@example.com', '1991-06-21', 'A'),
('lim_7e8f9', 'Hannah', 'Lim', 'hannah.lim@example.com', '1994-12-02', 'A'),
('ng_a1b2c', 'Ivan', 'Ng', 'ivan.ng@example.com', '1987-09-11', 'I'),
('lee_d3e4f', 'Jenny', 'Lee', 'jenny.lee@example.com', '1993-05-18', 'A'),
('wong_f5g6h', 'Kevin', 'Wong', 'kevin.wong@example.com', '1990-07-30', 'A'),
('tan_i7j8k', 'Laura', 'Tan', 'laura.tan@example.com', '1995-11-09', 'A'),
('lim_l9m0n', 'Michael', 'Lim', 'michael.lim@example.com', '1989-04-22', 'I'),
('chong_o1p2q', 'Nina', 'Chong', 'nina.chong@example.com', '1992-08-15', 'A'),
('ng_r3s4t', 'Oscar', 'Ng', 'oscar.ng@example.com', '1986-03-05', 'A'),
('lee_u5v6w', 'Paul', 'Lee', 'paul.lee@example.com', '1990-01-27', 'A'),
('wong_x7y8z', 'Quinn', 'Wong', 'quinn.wong@example.com', '1993-10-12', 'A'),
('tan_a9b0c', 'Rachel', 'Tan', 'rachel.tan@example.com', '1991-09-19', 'A'),
('lim_d1e2f', 'Steven', 'Lim', 'steven.lim@example.com', '1988-06-07', 'I'),
('chong_g3h4i', 'Tina', 'Chong', 'tina.chong@example.com', '1994-03-23', 'A'),
('ng_j5k6l', 'Umar', 'Ng', 'umar.ng@example.com', '1987-12-01', 'A'),
('lee_m7n8o', 'Vera', 'Lee', 'vera.lee@example.com', '1992-05-09', 'A'),
('wong_p9q0r', 'Will', 'Wong', 'will.wong@example.com', '1990-08-28', 'A'),
('tan_s1t2u', 'Xena', 'Tan', 'xena.tan@example.com', '1995-02-17', 'A'),
('lim_v3w4x', 'Yusuf', 'Lim', 'yusuf.lim@example.com', '1989-11-03', 'I');

INSERT INTO "ASSESSMENT"."TB_ITEM" ("ITEM_NAME", "MANUFACTURER_NAME", "COST_NO", "WEIGHT_KG")
VALUES
('Laptop', 'TechBrand', 1500.00, 2.50),
('Smartphone', 'PhoneCorp', 900.00, 0.40),
('Headphones', 'AudioMax', 120.00, 0.30),
('Office Chair', 'FurniCo', 300.00, 12.00),
('Coffee Machine', 'HomeBrew', 250.00, 5.00),
('Tablet', 'TechBrand', 600.00, 0.80),
('Gaming Mouse', 'GamerTech', 80.00, 0.15),
('Keyboard', 'KeyMaster', 150.00, 1.20),
('Monitor', 'ViewPro', 300.00, 4.50),
('Desk Lamp', 'BrightLite', 45.00, 0.80),
('External HDD', 'StoragePlus', 120.00, 0.25),
('Webcam', 'CamVision', 70.00, 0.20),
('Bluetooth Speaker', 'SoundMax', 90.00, 0.50),
('Printer', 'PrintCo', 250.00, 8.00),
('Router', 'NetLink', 130.00, 0.60),
('Notebook', 'PaperWorks', 5.00, 0.50);

INSERT INTO "ASSESSMENT"."TB_TRANSACTION" ("TRANSACTION_ID_NO", "MEMBERSHIP_ID_TXT", "TOTAL_PRICE_NO", "TOTAL_WEIGHT_KG", "TRANSACTION_DTTM")
VALUES
(1, 'chong_1a2b3', 1800.00, 6.50, '2025-09-06 10:00:00'),
(2, 'tan_4c5d6', 980.00, 0.55, '2025-09-06 12:15:00'),
(3, 'lim_7e8f9', 210.00, 0.80, '2025-09-07 09:30:00'),
(4, 'ng_a1b2c', 300.00, 12.00, '2025-09-07 14:45:00'),
(5, 'lee_d3e4f', 500.00, 13.00, '2025-09-08 11:20:00'),
(6, 'wong_f5g6h', 750.00, 2.00, '2025-09-08 15:30:00'),
(7, 'tan_i7j8k', 1020.00, 0.65, '2025-09-09 09:45:00'),
(8, 'lim_l9m0n', 1500.00, 2.50, '2025-09-09 13:20:00'),
(9, 'chong_o1p2q', 350.00, 5.80, '2025-09-10 10:10:00'),
(10, 'ng_r3s4t', 200.00, 0.80, '2025-09-10 14:55:00'),
(11, 'lee_u5v6w', 125.00, 0.80, '2025-09-11 11:30:00'),
(12, 'wong_x7y8z', 340.00, 5.50, '2025-09-11 15:00:00'),
(13, 'tan_a9b0c', 980.00, 0.55, '2025-09-12 09:15:00'),
(14, 'lim_d1e2f', 550.00, 20.00, '2025-09-12 14:40:00'),
(15, 'chong_g3h4i', 720.00, 1.10, '2025-09-13 10:25:00'),
(16, 'ng_j5k6l', 1800.00, 6.50, '2025-09-13 13:50:00'),
(17, 'lee_m7n8o', 195.00, 2.00, '2025-09-14 11:15:00'),
(18, 'wong_p9q0r', 1020.00, 0.65, '2025-09-14 15:30:00'),
(19, 'tan_s1t2u', 510.00, 13.50, '2025-09-15 09:50:00'),
(20, 'lim_v3w4x', 1500.00, 2.50, '2025-09-15 14:10:00');

INSERT INTO "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING" ("TRANSACTION_ID_NO", "ITEM_ID_NO", "QUANTITY_NO")
VALUES
-- Transaction 1: Fiona Chong buys Laptop + Monitor
(1, 1, 1), (1, 9, 1),
-- Transaction 2: George Tan buys Smartphone + Gaming Mouse
(2, 2, 1), (2, 7, 1),
-- Transaction 3: Hannah Lim buys Headphones + Bluetooth Speaker
(3, 3, 1), (3, 13, 1),
-- Transaction 4: Ivan Ng buys Office Chair
(4, 4, 1),
-- Transaction 5: Jenny Lee buys Coffee Machine + Printer
(5, 5, 1), (5, 14, 1),
-- Transaction 6: Kevin Wong buys Tablet + Keyboard
(6, 6, 1), (6, 8, 1),
-- Transaction 7: Laura Tan buys Smartphone + External HDD
(7, 2, 1), (7, 11, 1),
-- Transaction 8: Michael Lim buys Laptop
(8, 1, 1),
-- Transaction 9: Nina Chong buys Monitor + Desk Lamp + Notebook
(9, 9, 1), (9, 10, 1), (9, 16, 1),
-- Transaction 10: Oscar Ng buys Router + Webcam
(10, 15, 1), (10, 12, 1),
-- Transaction 11: Paul Lee buys Headphones + Notebook
(11, 3, 1), (11, 16, 1),
-- Transaction 12: Quinn Wong buys Coffee Machine + Bluetooth Speaker
(12, 5, 1), (12, 13, 1),
-- Transaction 13: Rachel Tan buys Smartphone + Gaming Mouse
(13, 2, 1), (13, 7, 1),
-- Transaction 14: Steven Lim buys Office Chair + Printer
(14, 4, 1), (14, 14, 1),
-- Transaction 15: Tina Chong buys Tablet + Headphones
(15, 6, 1), (15, 3, 1),
-- Transaction 16: Umar Ng buys Laptop + Monitor
(16, 1, 1), (16, 9, 1),
-- Transaction 17: Vera Lee buys Keyboard + Desk Lamp
(17, 8, 1), (17, 10, 1),
-- Transaction 18: Will Wong buys Smartphone + External HDD
(18, 2, 1), (18, 11, 1),
-- Transaction 19: Xena Tan buys Coffee Machine + Printer + Notebook
(19, 5, 1), (19, 14, 1), (19, 16, 1),
-- Transaction 20: Yusuf Lim buys Laptop
(20, 1, 1);