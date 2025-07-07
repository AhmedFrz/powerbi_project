import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os

# Load .env vars
load_dotenv()

# Read creds securely
user = os.getenv("PG_USER")
password = os.getenv("PG_PASSWORD")
host = os.getenv("PG_HOST")
port = os.getenv("PG_PORT")
db = os.getenv("PG_DB")

engine = create_engine(f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}")

data_folder = "instacart_data"
file_names = [
    "aisles.csv",
    "departments.csv",
    "products.csv",
    "orders.csv",
    "order_products__prior.csv",
    "order_products__train.csv"
]

files = {
    name.replace(".csv", "").replace("__", "_"): f"{data_folder}/{name}"
    for name in file_names
}

for table, file in files.items():
    print(f"Loading {table}...")
    df = pd.read_csv(file)
    df.to_sql(table, engine, if_exists='append', index=False)

print("✅ All data loaded securely.")