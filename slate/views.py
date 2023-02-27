"""Module containing all Flask views and blueprints."""
import os

import flask

from slate import content
from slate import render

RENDERER = render.Renderer(autoescape=False)

home = flask.Blueprint('home', __name__)

def register(app):
    """Register blueprints for a Flask application."""
    app.register_blueprint(home)


@home.route('/')
def index():
    context = dict(
            content=content.from_markdown('markdown/index.md'))

    return RENDERER.render_template(
            'templates/base.html',
            context=context)
