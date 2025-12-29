"""API route handlers."""

from .events import router as events_router
from .devices import router as devices_router
from .health import router as health_router

__all__ = ["events_router", "devices_router", "health_router"]
