import argparse;
import subprocess;
import signal;
import sys;
import time;

def log_message(source: str, string: str):
    print('%s: %s' % (source, string))

if __name__ == "main":
    argparser = argparse.ArgumentParser(
        prog="setup.ps1",
        usage="setup.ps1 --daemon [path-to-mysqld] --flyway [path-to-flyway] --migrations [path-to-migrations-folder]",
    )
    argparser.add_argument("--daemon", type=str)
    argparser.add_argument("--flyway", type=str)
    argparser.add_argument("--migrations", type=str)
    argparser.add_argument("--port", required=False, default=3306, type=int)
    argparser.add_argument("--dbname", required=False, default="ss13", type=str)

    parsed_args = argparser.parse_args(sys.argv)

    PATH_TO_MYSQLD: str = parsed_args.daemon
    PATH_TO_FLYWAY: str = parsed_args.flyway
    PATH_TO_MIGRATIONS: str = parsed_args.migrations
    USE_PORT: int = parsed_args.port
    USE_DATABASE: str = parsed_args.dbname

    log_message("setup_dev_db", "WARNING: This is a very, very lazy Python app! Logs are not necessarily in order of occurence; the script is just a very, very dumb while(True) loop that is just jank enough to work. Do not use this for production")
    log_message("setup_dev_db", "Starting processes...")

    mysqld: subprocess.Popen | None = subprocess.Popen(
        [],
        executable="",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    flyway: subprocess.Popen | None = subprocess.Popen(
        [],
        executable="",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    # main loop
    keep_running: bool = True
    while(keep_running):
        # pull outputs
        polled: list[str]
        exited: int | None

        if mysqld != None:
            polled = mysqld.stdout.readlines()
            for string in polled:
                log_message("mysqld-out", string)

            polled = mysqld.stderr.readlines()
            for string in polled:
                log_message("mysqld-err", string)

            exited = mysqld.poll()
            if exited != None:
                mysqld = None
                log_message("setup_dev_db", 'mysqld exited with code %d' % exited)

        if flyway != None:
            polled = flyway.stdout.readlines()
            for string in polled:
                log_message("flyway-out", string)

            polled = flyway.stderr.readlines()
            for string in polled:
                log_message("flyway-err", string)

            exited = flyway.poll()
            if exited != None:
                flyway = None
                log_message("setup_dev_db", 'flyway exited with code %d' % exited)

        # "this is async right"
        # "yeah"
        # pulls the cover off
        # "what the hell, this is just an infinite loop!"
        time.sleep(0.001)

    # exit mysqld and flyway
    if mysqld != None:
        mysqld.send_signal(sig=signal.CTRL_C_EVENT)
    if flyway != None:
        flyway.send_signal(sig=signal.CTRL_C_EVENT)

    # block on mysqld/flyway exiting
    mysqld_exitcode: int | None = mysqld.wait()
    log_message("setup_dev_db", 'mysqld exited with code %d' % exited)
    flyway_exitcode: int | None = flyway.wait()
    log_message("setup_dev_db", 'flyway exited with code %d' % exited)

