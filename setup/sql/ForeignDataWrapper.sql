CREATE EXTENSION IF NOT EXISTS file_fdw;

DROP SERVER IF EXISTS csv_srv CASCADE;
CREATE SERVER csv_srv FOREIGN DATA WRAPPER file_fdw;

DROP FOREIGN TABLE IF EXISTS employees_csv;

CREATE FOREIGN TABLE employees_csv (
    id          INT,
    name        TEXT,
    department  TEXT
)
SERVER csv_srv
OPTIONS (filename '/var/lib/pgadmin/storage/admin_admin.com/employees.csv', format 'csv', header 'true');

-- Query the CSV as if it were a Postgres table!
SELECT * FROM employees_csv;