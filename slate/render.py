"""Utility module for rendering Jinja templates."""
import jinja2


class Renderer(object):
    """Wrapper around Jinja for rendering templates."""

    def __init__(self, path=None, autoescape=True, context=None):
        loader = jinja2.FileSystemLoader(path or '.')
        self.env = jinja2.Environment(
                loader=loader,
                autoescape=autoescape)
        self.context = {}
        if context:
            self.context.update(context)

    def render_template(self, filepath, context=None):
        local_context = self.context.copy()
        if context:
            local_context.update(context)
        return self.env.get_template(filepath).render(local_context)
