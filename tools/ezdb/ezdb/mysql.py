import atexit
import mysql.connector
import subprocess
from contextlib import closing
from .config import read_config
from .paths import get_mariadb_client_path, get_mariadb_daemon_path

def open_connection():
    config = read_config()
    assert config["SQL_PASSWORD"] is not None, "No password found in config file"

    connection = mysql.connector.connect(
        user = config["SQL_USER"],
        password = config["SQL_PASSWORD"],
        port = int(config["SQL_PORT"]),
        raise_on_warnings = True,
    )

    connection.autocommit = True

    return closing(connection)

# We use custom things like delimiters, so we can't use the built-in cursor.execute
def execute_sql(sql: str):
    config = read_config()
    assert config is not None, "No config file found"
    assert config["SQL_PASSWORD"] is not None, "No password found in config file"

    subprocess.run(
        [
            str(get_mariadb_client_path()),
            "-u",
            "root",
            "-p" + config["SQL_PASSWORD"],
            "--port",
            config["SQL_PORT"],
            "--database",
            config["FEEDBACK_DATABASE"],
        ],
        input = sql,
        encoding = "utf-8",
        check = True,
        stderr = subprocess.STDOUT,
    )

def insert_new_schema_query(major_version: int, minor_version: int):
    return f"INSERT INTO `schema_revision` (`major`, `minor`) VALUES ({major_version}, {minor_version})"

process = None
def start_daemon():
    global process
    if process is not None:
        return

    print("Starting MariaDB daemon...")
    config = read_config()
    assert config is not None, "No config file found"

    process = subprocess.Popen(
        [
            str(get_mariadb_daemon_path()),
            "--port",
            config["SQL_PORT"],
        ],
        stderr = subprocess.PIPE,
    )

    atexit.register(process.kill)
