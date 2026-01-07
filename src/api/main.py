"""FastAPI application for Neve26 API."""

import json
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import structlog

from config.settings import get_settings
from src.db import init_db, close_db, get_session, upsert_events
from src.api.routes import events_router, devices_router, health_router

log = structlog.get_logger()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan handler."""
    # Startup
    log.info("Starting Neve26 API")

    # Initialize database
    await init_db()

    # Load mock data if database is empty
    await load_mock_data_if_empty()

    yield

    # Shutdown
    log.info("Shutting down Neve26 API")
    await close_db()


async def load_mock_data_if_empty():
    """Load mock schedule data if the database is empty."""
    mock_file = Path(__file__).parent.parent.parent / "data" / "schedule.json"

    if not mock_file.exists():
        log.warning("Mock data file not found", path=str(mock_file))
        return

    async with get_session() as session:
        # Check if we already have events
        from src.db import get_all_events
        existing = await get_all_events(session, include_past=True)

        if existing:
            log.info("Database already has events", count=len(existing))
            return

        # Load mock data
        with open(mock_file) as f:
            events = json.load(f)

        count = await upsert_events(session, events)
        log.info("Loaded mock schedule data", count=count)


def create_app() -> FastAPI:
    """Create and configure the FastAPI application."""
    settings = get_settings()

    app = FastAPI(
        title="Neve26 API",
        description="Winter Games Italy 2026 Schedule Tracker API",
        version="0.1.0",
        lifespan=lifespan,
        docs_url="/docs" if settings.debug else None,
        redoc_url="/redoc" if settings.debug else None,
    )

    # CORS middleware
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Include routers
    app.include_router(health_router, prefix="/api/v1")
    app.include_router(events_router, prefix="/api/v1")
    app.include_router(devices_router, prefix="/api/v1")

    return app


# Create the app instance
app = create_app()


if __name__ == "__main__":
    import uvicorn

    settings = get_settings()

    # Configure logging
    structlog.configure(
        processors=[
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.dev.ConsoleRenderer()
        ]
    )

    uvicorn.run(
        "src.api.main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.debug,
    )
