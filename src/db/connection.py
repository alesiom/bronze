"""Database connection and session management."""

from contextlib import asynccontextmanager
from typing import AsyncGenerator

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.pool import NullPool
import structlog

from config.settings import get_settings
from .models import Base

log = structlog.get_logger()

# Global engine and session maker
_engine = None
_async_session_maker = None


def get_async_engine():
    """Get or create the async database engine."""
    global _engine

    if _engine is None:
        settings = get_settings()

        # Convert postgresql:// to postgresql+asyncpg://
        db_url = settings.database_url
        if db_url.startswith("postgresql://"):
            db_url = db_url.replace("postgresql://", "postgresql+asyncpg://", 1)

        _engine = create_async_engine(
            db_url,
            echo=settings.debug,
            poolclass=NullPool,  # Disable connection pooling for serverless compatibility
        )
        log.info("Database engine created", url=db_url.split("@")[-1] if "@" in db_url else "local")

    return _engine


def get_session_maker() -> async_sessionmaker[AsyncSession]:
    """Get or create the async session maker."""
    global _async_session_maker

    if _async_session_maker is None:
        engine = get_async_engine()
        _async_session_maker = async_sessionmaker(
            engine,
            class_=AsyncSession,
            expire_on_commit=False,
        )

    return _async_session_maker


@asynccontextmanager
async def get_session() -> AsyncGenerator[AsyncSession, None]:
    """Get a database session with automatic cleanup."""
    session_maker = get_session_maker()
    session = session_maker()
    try:
        yield session
        await session.commit()
    except Exception:
        await session.rollback()
        raise
    finally:
        await session.close()


async def init_db() -> None:
    """Initialize the database (create tables)."""
    engine = get_async_engine()
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    log.info("Database tables created")


async def close_db() -> None:
    """Close database connections."""
    global _engine, _async_session_maker

    if _engine is not None:
        await _engine.dispose()
        _engine = None
        _async_session_maker = None
        log.info("Database connections closed")
