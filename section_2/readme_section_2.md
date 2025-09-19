# Section2: Database
---

# Overview

This section covers the following deliverables:
1. [Architecting and implementing data pipeline and database](#1-architecting-and-implementing-data-pipeline-and-database)
2. [Membership Application Pipeline](#2-membership-application-pipeline)
3. [Database Design with Entity Relationship Diagram](#3-database-design-with-entity-relationship-diagram)
4. [Dockerfile setup and PostgreSQL DDL statements](#4-dockerfile-setup-and-postgresql-ddl-statements)
5. [Addressing Analyst Queries](#5-addressing-analyst-queries)

# 1. Architecting and implementing data pipeline and database
Being a tech lead goes far beyond just writing DDL and setting up pipelines. It’s about shaping the architecture, practices, and people around the project so that the system is reliable, maintainable, and scalable.

Here’s what else I’d do as the technical lead in this scenario:
1. Setup data architecture and design
	- End-to-End Data Flow: Document the ingestion → validation → storage → analytics pipeline clearly so engineers and analysts know where their data comes from.
	- Analyse and decide on Cloud-native Design: Leverage managed services. In this case, AWS.
	- Ensure Security & Compliance: Ensure data encryption, PII masking (emails, birthdays), and access control for sensitive membership data.
	- Ensure Scalability: Design the pipeline and DB schema for growth (millions of transactions, thousands of items).
	
2. Adopt data engineering best practices
	- Setup coding standards: Define conventions for validation, logging, and error handling in the pipeline code.
	- Setup testing strategy: Require unit tests for validation rules, integration tests for pipeline, SQL query correctness checks.
	- Setup CI/CD: Automate build/deploy of pipelines and DB migrations (e.g., GitHub Actions + Flyway/Migrate).
	- Setup Monitoring & Alerts: Set up metrics (failed applications, rejected rows, DB query performance) and alerting in case of anomalies.

3. Database & Data Modeling
	- Indexes: Add indexes on membership_id, item_id, and transaction_id for performance.
	- Partitioning: Consider partitioning transactions table by month if transaction volume is very high.
	- Audit Logging: Keep history of rejected membership applications for compliance and analytics.
	- Data Dictionary: Provide analysts with clear documentation of tables, fields, and sample queries.	
	
4. Team and Cross-Function Collaboration
	- With Software Engineers: Align membership pipeline output format with application’s expectations.
	- With Analysts: Gather more sample queries.
	- With Product Managers: Clarify requirements (e.g., do we need to track item returns, refunds, or order cancellations?).
	- Do mentorship: Help junior engineers understand trade-offs (denormalization vs normalization, batch vs streaming).
	
5. Future-Proofing
	- Data Warehouse: Plan integration with a warehouse (e.g., BigQuery, Snowflake, Redshift) for analytics at scale.
	
In short: as a techical lead, I wouldn’t just “build the pipeline and database” — I’d set up processes, architecture, and practices so the system remains healthy, secure, and useful for years

[Back to Top](#overview)

# 2. Membership Application Pipeline
Recap of Section 1:
1. Applications submitted and dropped the file into a cloud storage/input folder (e.g., input/) for processing.
2. Engineers already implemented following logics using Python:
	- Reads application file.
	- Perform data validation for mobile number, age, name and email.
	- Determines Success or Fail application.
	- Assigns Membership ID for successful applications.
4. Output:
	- Successful applications → stored in success/ storage location.
	- Failed applications → stored in fail/ storage location with reject reason.
	- Archive -> stored processed file.
5. Database Integration:
	- Successful applications are loaded into the TB_MEMBERSHIP table in PostgreSQL for transaction reference.

This ensures clean lineage and referenceability.

[Back to Top](#overview)

# 3. Database Design with Entity Relationship Diagram

We need to design memberships, items, transactions, and transaction details.
1. TB_MEMBERSHIP: created from successful applications.
2. TB_ITEM: product catalog.
3. TB_TRANSACTION: records purchases by members.
4. TB_TRANSACTION_ITEM_MAPPING: mapping table that captures items within each transaction (many-to-many relationship).
5. TB_REJECTED_APPLICATION: provides analysts with a dedicated record of all rejected applications. This eliminates the need for them to access S3, which may have restricted access for cloud administrators, thereby streamlining the analysis of rejection reasons.

Refer to init.sql for DDL and Test data.


![view here](ERD.png)


[Back to Top](#overview)

# 4. Dockerfile setup and PostgreSQL DDL statements
1. Install tool: Docker Desktop
2. Install tool: pgAdmin 4
3. Create the following files:
- **`init.sql`** – This will contain the entire SQL script to initialize the database.
- **`Dockerfile`** – This configuation defines how PostgreSQL is set up, by specifying user, password and database name.

~~~dockerfile
FROM postgres:latest

# Set the default environment variables
ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=admin123
ENV POSTGRES_DB=ASSESSMENT

# Copy initialization SQL script
COPY init.sql /docker-entrypoint-initdb.d/
~~~

- **`docker-compose.yml`** – This yml file manage the PostgreSQL container that I will setup, by using the username, password, database name and database port.

~~~yml
services:
  db:
    build: .
    container_name: container_assessment
    image: image_assessment
    restart: always
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: admin123
      POSTGRES_DB: ASSESSMENT
    ports:
      - "5433:5432"

volumes:
  pgdata:
~~~

4. Open the Docker Desktop terminal.
5. Go to the project directory.
6. Run the following command to start the container:
```bash
docker-compose up -d --build
```
7. Ensure that the container is running:
8. Go to pgAdmin. Right click on server - register, in order to setup the database.
9. Verify the database is up and running by expanding the database which was just created.

[Back to Top](#overview)

## Applying data standard and guidelines
1. All the columns are harmonized with appended with classword as suffix:
- _NO is for number.
- _TXT is for text field.
- _IND is for indicator / 2 values field.
- _CD is for code values / fields with more than 2 possible values.
			
2. All the tables are harmonized with prefix: TB_, which represents base table.
3. Primary key and foreign keys are indicated accordingly.
4. Table descriptions are indicated accordingly for future reference.
5. Column descriptions are indicated accordingly for future reference.

# 5. Addressing Analyst Queries
## Q1. Top 3 items that are frequently bought by members
~~~~sql
--Which are the top 3 items that are frequently brought by members ?
--We need to count total quantity purchased for each item across all transactions:
SELECT i."ITEM_ID_NO", i."ITEM_NAME", SUM(ti."QUANTITY_NO") AS total_quantity_sold
FROM "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING" ti
JOIN "ASSESSMENT"."TB_ITEM" i ON ti."ITEM_ID_NO" = i."ITEM_ID_NO"
GROUP BY i."ITEM_ID_NO", i."ITEM_NAME"
ORDER BY total_quantity_sold DESC
LIMIT 3;

--Explanation:
--Join TB_ITEM and TB_TRANSACTION_ITEM_MAPPING to get purchase quantities.
--Aggregate total quantity per item (SUM(ti.QUANTITY_NO)).
--Order descending and take the top 3 most frequently purchased items.
~~~~

## Q2. Top 10 members by spending
~~~~sql
-- Which are the top 10 members by spending ?
-- We need to sum the total_price of all transactions per member and order by spending descending:
SELECT 
    m."MEMBERSHIP_ID_TXT",
    m."FIRST_NAME",
    m."LAST_NAME",
    m."EMAIL_ADDR",
    SUM(t."TOTAL_PRICE_NO") AS total_spent
FROM "ASSESSMENT"."TB_MEMBERSHIP" m
JOIN "ASSESSMENT"."TB_TRANSACTION" t ON m."MEMBERSHIP_ID_TXT" = t."MEMBERSHIP_ID_TXT"
GROUP BY m."MEMBERSHIP_ID_TXT", m."FIRST_NAME", m."LAST_NAME", m."EMAIL_ADDR"
ORDER BY total_spent DESC
LIMIT 10;

--Explanation:
-- Join TB_MEMBERSHIP and TB_TRANSACTION on membership_id_txt.
-- Aggregate total spending per member (SUM(t.total_price)).
-- Order by total_spent descending and take the top 10.
~~~~

## Next
Automate the data harmonization (i.e. logical modeling and physical modeling) for every new tables brought in to the system.

[Back to Top](#overview)