# Instructions

## Getting started

* Open SQL Developer and connect as `SYSDBA` with the following settings:
  ```
  Connection name: sys
  Username: sys
  Password: oracle
  Save password: [x]
  Connection type: Basic
  Role: SYSDBA
  Hostname: localhost
  Port: 1521
  Service name: orcl
  ```

* Execute the file `create_role_and_users.sql`

* Create the following connections in Oracle SQL Developer:
  ```
  Connection name: kata
  Username: kata
  Password: oracle
  Save password: [x]
  Connection type: Basic
  Role: default
  Hostname: localhost
  Port: 1521
  Service name: orcl
  ```

  ```
  Connection name: sakila
  Username: sakila
  Password: oracle
  Save password: [x]
  Connection type: Basic
  Role: default
  Hostname: localhost
  Port: 1521
  Service name: orcl
  ```

* Import the schema `sakila` with `Sakila/CreateSakila.sql`
