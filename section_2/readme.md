# Section2: Database
---

## Overview
This section covers the setting up of database, creating the data model, setting up test data and address the questions from stakeholders on the data analysis.

## Pre-requisite: Setup Docker Desktop with PostgreSQL database, using the following steps:
1. Install tool: Docker Desktop
2. Install tool: pgAdmin 4
3. Create the following files:
- **`init.sql`** – This will contain the entire SQL script to initialize the database.
- **`Dockerfile`** – This configuation defines how PostgreSQL is set up, by specifying user, password and database name.
- **`docker-compose.yml`** – This yml file manage the PostgreSQL container that I will setup, by using the username, password, database name and database port.

4. Open the Docker Desktop terminal, i.e. command prompt.
5. Go to the project directory (e.g., `<work folder>/section_2`).
6. Run the following command to start the container:
```bash
cd section2
docker-compose up -d --build
```
Ensure that the container is running:

![image](https://github.com/user-attachments/assets/697f9012-1d08-4535-b538-b4fd2814d281)


7. Go to pgAdmin. Right click on server - register, in order to setup the database.

![image](https://github.com/user-attachments/assets/94c91651-08ff-4998-92ca-609b0700c16e)

![image](https://github.com/user-attachments/assets/f2ff4c31-6d2a-4346-ac03-5cf93e0062dd)

7. Verify the database is up and running by expanding the database which was just created.
    
![image](https://github.com/user-attachments/assets/9818b6eb-20e9-4116-b0e5-13f10e6819e3)

## Solution - Entity Relationship Diagram

![image](https://github.com/user-attachments/assets/03dde0eb-863a-4074-b64a-ead947bbef39)


## I have applied the following database standard and guidelines:
### 1. All the columns are harmonized with appended with classword as suffix:
- _NO is for number.
- _TXT is for text field.
- _IND is for indicator / 2 values field.
- _CD is for code values / fields with more than 2 possible values.
			
### 2. All the tables are harmonized with prefix: TB_, which represents base table.

### 3. Primary key and foreign keys are indicated accordingly.

### 4. Table descriptions are indicated accordingly.

### 5. Column descriptions are indicated accordingly.

## Solution - Test Data
Refer to folder "Test Data" for the mock up data.

## Solution - DDLs
Refer to folder "Tables" for all DDLs / table creation scripts.

## Solution - Top 10 members by spending
~~~~sql
--Which are the top 3 items that are frequently brought by members
SELECT
	ITEM."ITEM_NAME" ITEM_NAME,
	SUM(TRANSACTION."ITEM_BOUGHT_NO") MOST_FREQUENT_ITEM_BOUGHT_NO
FROM
	"EXAM"."TB_ITEM" ITEM
	INNER JOIN "EXAM"."TB_TRANSACTION" TRANSACTION ON TRANSACTION."ITEM_ID_NO" = ITEM."ITEM_ID_NO"
GROUP BY
	ITEM."ITEM_NAME"
ORDER BY
	SUM(TRANSACTION."ITEM_BOUGHT_NO") DESC
LIMIT
	3;
~~~~

## Solution - Top 3 items that are frequently bought by members
~~~~sql
-- Which are the top 10 members by spending
SELECT
	MEMBERSHIP."MEMBERSHIP_TXT" MEMBERSHIP_TXT,
	(
		MEMBERSHIP."FIRST_NAME" || ' ' || MEMBERSHIP."LAST_NAME"
	) MEMBERSHIP_FULL_NAME,
	SUM(TRANSACTION."TOTAL_ITEM_PRICE_NO") TOTAL_SPENDING_NO
FROM
	"EXAM"."TB_MEMBERSHIP" MEMBERSHIP
	INNER JOIN "EXAM"."TB_TRANSACTION" TRANSACTION ON TRANSACTION."MEMBERSHIP_ID_NO" = MEMBERSHIP."MEMBERSHIP_ID_NO"
GROUP BY
	MEMBERSHIP."MEMBERSHIP_TXT",
	MEMBERSHIP."FIRST_NAME",
	MEMBERSHIP."LAST_NAME"
ORDER BY
	SUM(TRANSACTION."TOTAL_ITEM_PRICE_NO") DESC
LIMIT
	10;
~~~~

## Next
Automate the data harmonization (i.e. logical modeling and physical modeling) for every new tables brought in to the system.
