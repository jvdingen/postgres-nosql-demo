# Exercises

All of the demo excercises will be done using the provided docker compose file. 
This repository includes a docker-compose file to run the services required for the exercises: PostgreSQL and pgvector extension (database), pgAdmin (Postgres UI), Neo4j (graph DB) and a Jupyter Notebook server (for running code and experiments). The compose file brings up all components with persistent volumes and preconfigured networking so they can be accessed on localhost.

Quick start
- Ensure Docker Desktop is running.
- Navigate to the root directory and run:
   - `docker compose up -d`
- Wait for containers to finish starting before running notebooks or loading data (check readiness via docker compose logs -f <service> or the Docker Dekstop UI).

Accessing services
- PostgreSQL:
   - http://localhost:5432 (use credentials in the compose file).
- pgAdmin:
   - http://localhost:5050 (A server connection is included to connect to the PostgreSQL)
- Neo4j: 
   - http://localhost:7474 (Standard Web UI)
- Jupyter Notebook: 
   - http://localhost:8888 (Satndard Web UI)

Management tips
- Follow the compose/env file for usernames, passwords and database names used in the exercises.
- Use docker compose logs -f <service> to inspect startup issues.
- Stop and remove containers with `docker compose down` (ONLY WHEN ASKED: add --volumes to remove persisted data in case you want to clean up everyting).

## Part 1 — Refreshing our understanding of Relational databases
1. Load `datasets/descriptions.csv` into PostgreSQL.
2. Convert descriptions into embeddings using any model (OpenAI, HuggingFace).
3. Insert embeddings into a new table.
4. Run a similarity search to answer:
   - Which description is closest to "wireless headphones"?
## Part 1 — pgvector
1. Load `datasets/descriptions.csv` into PostgreSQL.
2. Convert descriptions into embeddings using any model (OpenAI, HuggingFace).
3. Insert embeddings into a new table.
4. Run a similarity search to answer:
   - Which description is closest to "wireless headphones"?

## Part 2 — Neo4j
1. Load `datasets/people.csv` as nodes.
2. Load `datasets/connections.csv` as relationships.
3. Query:
   - Who is 2 hops away from Alice?
   - What is the shortest path between Bob and Diana?
