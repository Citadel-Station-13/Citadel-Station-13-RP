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

def on_interrupt():
    global keep_running
    print("ctrl+C caught!")
    keep_running = False

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
    argparser.add_argument("--daemon", type=str)
    argparser.add_argument("--flyway", type=str)
    argparser.add_argument("--migrations", type=str)
    argparser.add_argument("--dataDir", type=str)
    argparser.add_argument("--port", required=False, default=3306, type=int)
    argparser.add_argument("--dbname", required=False, default="ss13", type=str)

    # we slice it, as being invoked from bootstrap consumes this script's file path as the first arg
    effective_args: list[str] = sys.argv[1:]

    if len(effective_args) == 0:
        argparser.print_help()
        exit(1)

    parsed_args = argparser.parse_args(effective_args)

    PATH_TO_MYSQLD: str = parsed_args.daemon
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

    log_message("setup_dev_db", "Starting flyway...")
    flyway: subprocess.Popen | None = subprocess.Popen(
        [
            PATH_TO_FLYWAY,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )

    os.set_blocking(mysqld.stdout.fileno(), False)
    os.set_blocking(flyway.stdout.fileno(), False)

    mysqld_out_dump = threading.Thread(target=thread_pipe_dump, args=("mysqld-out", mysqld.stdout), daemon=True)
    flyway_out_dump = threading.Thread(target=thread_pipe_dump, args=("flyway-out", flyway.stdout), daemon=True)

    mysqld_out_dump.start()
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
                log_message("setup_dev_db", 'mysqld exited with code %d' % exited)

        if flyway != None:
            exited = flyway.poll()
            if exited != None:
                flyway = None
                log_message("setup_dev_db", 'flyway exited with code %d' % exited)

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
        mysqld.send_signal(sig=signal.CTRL_C_EVENT)
    if flyway != None:
        flyway.send_signal(sig=signal.CTRL_C_EVENT)

    # block on mysqld/flyway exiting
    if mysqld != None:
        mysqld_exitcode: int | None = mysqld.wait()
        log_message("setup_dev_db", 'mysqld exited with code %d' % exited)
    if flyway != None:
        flyway_exitcode: int | None = flyway.wait()
        log_message("setup_dev_db", 'flyway exited with code %d' % exited)

