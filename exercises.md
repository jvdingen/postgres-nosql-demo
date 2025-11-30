# Exercises

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
