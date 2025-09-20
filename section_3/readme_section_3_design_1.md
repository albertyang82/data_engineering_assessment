# Section3: Design 1
---

# Overview
I, as technical lead, design a database access strategy that satisfies different team roles and their privileges. I’ll break this down and give a PostgreSQL-based approach with roles, privileges, and grants:  
1. [Define User Roles](#1-define-user-roles)  
2. [Role Creation](#2-role-creation)  
3. [Privilege Assignments](#3-privilege-assignments)  
4. [Security Considerations](#4-security-considerations)  

# 1. Define User Roles

| Team      | Role Name        | Responsibilities                                                | Privileges Required                                                        |
| --------- | ---------------- | --------------------------------------------------------------- | -------------------------------------------------------------------------- |
| Logistics | `ROLE_LOGISTICS` | - Query sales & item weights<br>- Update completed transactions | SELECT on `transactions` & `transaction_items`<br>UPDATE on `transactions` |
| Analytics | `ROLE_ANALYTICS` | - Analyze sales, items, and membership data                     | SELECT on all tables (read-only)                                           |
| Sales     | `ROLE_SALES`     | - Add new items<br>- Remove old items                           | INSERT/DELETE/UPDATE on `items`                                            |

This approach:
- Protects raw data integrity.
- Gives each team just enough permissions to do their jobs.
- Provides views for Analytics so they don’t need direct table access.

[Back to Top](#Overview)

# 2. Role Creation

~~~sql
-- ============
-- Create roles
-- ============

-- Role Logistics
DROP ROLE IF EXISTS "ROLE_LOGISTICS";
CREATE ROLE "ROLE_LOGISTICS";
COMMENT ON ROLE "ROLE_LOGISTICS" IS 'This role is for logistics team';

-- Role Analytics
DROP ROLE IF EXISTS "ROLE_ANALYTICS";
CREATE ROLE "ROLE_ANALYTICS";
COMMENT ON ROLE "ROLE_ANALYTICS" IS 'This role is for analytics team';

-- Role Sales
DROP ROLE IF EXISTS "ROLE_SALES";
CREATE ROLE "ROLE_SALES";
COMMENT ON ROLE "ROLE_SALES" IS 'This role is for sales team';

-- ==========================
-- Create users for each team
-- ==========================

-- Create user accounts for team members and assign roles
DROP USER IF EXISTS "USER_LOGISTIC";
CREATE USER "USER_LOGISTIC" WITH PASSWORD 'logistic_pass';

DROP USER IF EXISTS "USER_ANALYST";
CREATE USER "USER_ANALYST" WITH PASSWORD 'analyst_pass';

DROP USER IF EXISTS "USER_SALES";
CREATE USER "USER_SALES" WITH PASSWORD 'sales_pass';

-- =====================
-- Assign roles to users
-- =====================
GRANT "ROLE_LOGISTICS" TO "USER_LOGISTIC";
GRANT "ROLE_ANALYTICS" TO "USER_ANALYST";
GRANT "ROLE_SALES" TO "USER_SALES";
~~~

[Back to Top](#Overview)

# 3. Privilege Assignments

1. Logistics
~~~sql
-- Logictics
-- Allow Logistics to SELECT transactions and transaction_items
GRANT SELECT ON "ASSESSMENT"."TB_TRANSACTION", "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING", "ASSESSMENT"."TB_ITEM" TO "ROLE_LOGISTICS";

-- Allow Logistics to UPDATE transactions (e.g., mark completed)
GRANT UPDATE ON "ASSESSMENT"."TB_TRANSACTION" TO "ROLE_LOGISTICS";
~~~

2. Analytics
~~~sql
-- Analytics 
-- Read-only access to all tables
GRANT SELECT ON "ASSESSMENT"."TB_MEMBERSHIP", "ASSESSMENT"."TB_ITEM", "ASSESSMENT"."TB_TRANSACTION", "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING", "ASSESSMENT"."TB_REJECTED_APPLICATION" TO "ROLE_ANALYTICS";
~~~

3. Sales
~~~sql
-- Sales 
-- Manage items
GRANT INSERT, UPDATE, DELETE ON "ASSESSMENT"."TB_ITEM" TO "ROLE_SALES";
-- Optionally: SELECT access to see items
GRANT SELECT ON "ASSESSMENT"."TB_ITEM" TO "ROLE_SALES";
~~~

[Back to Top](#Overview)

# 4. Security Considerations
1. Separate schemas for different tables.
	- I can place different tables in schemas (e.g., app_data) and grant schema-level privileges.

2. Row-level security (optional)
	- If Logistics should only see transactions for certain regions or stores, you can enable RLS.

3. Audit Tables
	- Use triggers or audit tables to log updates, especially for Logistics and Sales teams.

[Back to Top](#Overview)