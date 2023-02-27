"""Library for rendering content from Markdown."""
import markdown

from slate import render

CONVERTER = markdown.Markdown(
        extensions=['fenced_code', 'codehilite'])
RENDERER = render.Renderer()


def from_markdown(filepath):
    return CONVERTER.convert(RENDERER.render_template(filepath))
