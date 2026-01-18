"""API route handlers."""

from .events import router as events_router
from .devices import router as devices_router
from .health import router as health_router
from .articles import router as articles_router
from .social import router as social_router
from .monitoring import router as monitoring_router
from .sitemap import router as sitemap_router

__all__ = [
    "events_router",
    "devices_router",
    "health_router",
    "articles_router",
    "social_router",
    "monitoring_router",
    "sitemap_router",
]
