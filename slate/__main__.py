"""Entry point for slate package."""
import os

from absl import app
from absl import flags
from absl import logging
import flask

from slate import views

HOST = flags.DEFINE_string(
        'host', 'localhost', 'The host serving requests.')
PORT = flags.DEFINE_integer('port', 8080, 'The port to serve at.')


def main(argv):
    """Main entry point when launching app."""
    logging.info('Starting server with command: %s', argv)

    flask_app = flask.Flask(
            __name__,
            root_path=os.getcwd(),
            # For some reason the static content configuration here seems to
            # take precedence over that of the blueprint. Not sure if I'm doing
            # something weird, but I should double check.
            static_folder='static',
            static_url_path='',
    )
    views.register(flask_app)

    logging.info(flask_app.url_map)

    flask_app.run(
            host=HOST.value,
            port=PORT.value,
            debug=False,
    )

if __name__ == '__main__':
    app.run(main)
