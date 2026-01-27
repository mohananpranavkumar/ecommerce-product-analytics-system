# Load raw CSVs into Postgres

This project supports two ways to load the Olist CSVs into Postgres:

- **Method A (recommended / reproducible): psql + \copy** → runnable script (`sql/02_load_raw_psql.sql`)
- **Method B (GUI): pgAdmin Import/Export** → easy, interactive, good for learning

> Note: Raw CSVs stay local in `data/` and are not committed to GitHub (`data/` is gitignored).

---

## Method A: psql (\copy) — recommended

Why:
- Fully scriptable and reproducible
- Fast to rerun if you reset the DB
- Best for portfolio “engineering” signal

### Run
From repo root:

```bash
psql -U postgres -d ecommerce_analytics -f sql/02_load_raw_psql.sql