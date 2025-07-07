os is a built-in Python module used to interact with the operating system.
- In this script, it’s used to read environment variables like this:

- user = os.getenv("PG_USER")
So instead of hardcoding credentials in the script, os.getenv() securely fetches them from the .env file loaded using dotenv.