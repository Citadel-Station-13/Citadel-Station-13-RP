import argparse;
import codecs;
import encodings;
import io;
import os;
import subprocess;
import signal;
import sys;
import time;
import threading;

keep_running: bool = True

def on_interrupt(signo, frame):
    global keep_running
    keep_running = False
    print("ctrl+C caught!")

signal.signal(signal.SIGINT, on_interrupt)

def log_message(source: str, string: str, end: str = "\n"):
    print('%s: %s' % (source, string), end=end)
    sys.stdout.flush()

def thread_pipe_dump(source: str, pipe: io.TextIOWrapper):
    while True:
        for line in pipe.readlines():
            log_message(source, line, end="")
        time.sleep(0.001)

if __name__ == "__main__":
    argparser = argparse.ArgumentParser(
        prog="setup.ps1",
        usage="setup.ps1 --port [port] --dbname [dbname]",
    )
    argparser.add_argument("--mysqld", type=str)
    argparser.add_argument("--mysql_admin", type=str)
    argparser.add_argument("--flyway", type=str)
    argparser.add_argument("--migrations", type=str)
    argparser.add_argument("--dataDir", type=str)
    argparser.add_argument("--port", required=False, default=3306, type=int)
    argparser.add_argument("--dbname", required=False, default="ss13", type=str)
    argparser.add_argument("--no_migrations", required=False, action="store_true", default=False)

    # we slice it, as being invoked from bootstrap consumes this script's file path as the first arg
    effective_args: list[str] = sys.argv[1:]

    if len(effective_args) == 0:
        argparser.print_help()
        exit(1)

    parsed_args = argparser.parse_args(effective_args)

    PATH_TO_MYSQLD: str = parsed_args.mysqld
    PATH_TO_MYSQL_ADMIN: str = parsed_args.mysql_admin
    PATH_TO_FLYWAY: str = parsed_args.flyway
    PATH_TO_MIGRATIONS: str = parsed_args.migrations
    USE_DATADIR: str = parsed_args.dataDir
    USE_PORT: int = parsed_args.port
    USE_DATABASE: str = parsed_args.dbname

    log_message("setup_dev_db", "WARNING: This is a very, very lazy Python app! Logs are not necessarily in order of occurence; the script is just a very, very dumb while(True) loop that is just jank enough to work. Do not use this for production")
    log_message("setup_dev_db", 'Using port %d and setting up on database %s. Use --port and --dbname to override!' % (USE_PORT, USE_DATABASE))
    log_message("setup_dev_db", 'Using data directory %s.' % (USE_DATADIR))
    log_message("setup_dev_db", "Starting processes...")

    log_message("setup_dev_db", "Starting mysqld...")
    mysqld: subprocess.Popen | None = subprocess.Popen(
        [
            PATH_TO_MYSQLD,
            '--datadir',
            USE_DATADIR,
            "--console",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    os.set_blocking(mysqld.stdout.fileno(), False)
    mysqld_out_dump = threading.Thread(target=thread_pipe_dump, args=("mysqld-out", mysqld.stdout), daemon=True)
    mysqld_out_dump.start()

    log_message("setup_dev_db", "Creating database...")
    create_db_run: subprocess.CompletedProcess = subprocess.run(
        [
            PATH_TO_MYSQL_ADMIN,
            "--user=root",
            '--password=password',
            "create",
            USE_DATABASE,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    log_message("mariadb_admin", create_db_run.stdout or "\n", end="")

    flyway: subprocess.Popen | None = None
    if not parsed_args.no_migrations:
        log_message("setup_dev_db", "Starting flyway and migrating...")
        flyway = subprocess.Popen(
            [
                PATH_TO_FLYWAY,
                "-user=root",
                "-password=password",
                '-url=jdbc:mariadb://localhost:%d/%s' % (USE_PORT, USE_DATABASE),
                '-locations=filesystem:%s' % (PATH_TO_MIGRATIONS),
                "migrate",
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        os.set_blocking(flyway.stdout.fileno(), False)
        flyway_out_dump = threading.Thread(target=thread_pipe_dump, args=("flyway-out", flyway.stdout), daemon=True)
        flyway_out_dump.start()


    # main loop
    while keep_running == True:
        # pull outputs
        polled: list[str]
        exited: int | None

        if mysqld != None:
            exited = mysqld.poll()
            if exited != None:
                mysqld = None
                log_message("setup_dev_db", 'mysqld exited with code %d' % (exited))

        if flyway != None:
            exited = flyway.poll()
            if exited != None:
                flyway = None
                log_message("setup_dev_db", 'flyway exited with code %d' % (exited))

        if flyway == None and mysqld == None:
            keep_running = False

        # "this is async right"
        # "yeah"
        # pulls the cover off
        # "what the hell, this is just an infinite loop!"
        time.sleep(0.001)

    log_message("setup_dev_db", 'exiting...')

    # exit mysqld and flyway
    if mysqld != None:
        mysqld.terminate()
    if flyway != None:
        flyway.terminate()

    # block on mysqld/flyway exiting
    if mysqld != None:
        mysqld_exitcode: int | None = mysqld.wait()
        log_message("setup_dev_db", 'mysqld exited with code %d' % (mysqld_exitcode))
    if flyway != None:
        flyway_exitcode: int | None = flyway.wait()
        log_message("setup_dev_db", 'flyway exited with code %d' % (flyway_exitcode))
