# Demo Exercises with Docker Compose

All demo exercises will be done using the provided Docker Compose file.
This repository includes a `docker-compose.yml` to run all services required for the exercises:

* **PostgreSQL** (with `pgvector` extension)
* **pgAdmin** (Postgres UI)
* **Neo4j** (graph database)
* **Jupyter Notebook** (for running code and experiments)

The compose file sets up persistent volumes and preconfigured networking so all services can be accessed on `localhost`.

---

## Quick Start

1. Ensure **Docker Desktop** is running.
2. Navigate to the root directory of the repository.
3. Run the following command to start all containers:

   ```bash
   docker compose up -d
   ```
4. Wait for containers to finish starting before running any of the excercises.
   You can check readiness via:

   ```bash
   docker compose logs -f <service>
   ```

   or by using the Docker Desktop UI.

---

## Accessing Services

* **PostgreSQL**

  * URL: `http://localhost:5432`
  * Use the credentials defined in the compose file.

* **pgAdmin**

  * URL: `http://localhost:5050`
  * A preconfigured server connection is included to connect to PostgreSQL.

* **Neo4j**

  * URL: `http://localhost:7474`

* **Jupyter Notebook**

  * URL: `http://localhost:8888`

---

## Management Tips

* Refer to the `compose`-file for usernames, passwords, and database names used in the exercises.
* Inspect startup issues with:

  ```bash
  docker compose logs -f <service>
  ```
* Stop and remove containers when needed:

  ```bash
  docker compose down
  ```

  > **Note:** Add `--volumes` if you want to remove persisted data and completely clean up the environment.
