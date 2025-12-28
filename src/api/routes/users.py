"""User and favorites endpoints."""

from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from src.db import (
    get_session,
    get_or_create_user,
    update_user_token,
    get_user_favorites,
    add_favorite,
    remove_favorite,
    get_event_by_id,
)
from src.api.models import (
    UserCreate,
    UserResponse,
    UserTokenUpdate,
    FavoriteAdd,
    FavoriteResponse,
    EventResponse,
    EventListResponse,
)

log = structlog.get_logger()
router = APIRouter(prefix="/users", tags=["users"])


async def get_db():
    """Dependency for database session."""
    async with get_session() as session:
        yield session


@router.post("", response_model=UserResponse, status_code=201)
async def register_user(
    user_data: UserCreate,
    session: AsyncSession = Depends(get_db),
):
    """
    Register a new user/device.

    This creates a unique ID for the device that can be used for favorites
    and push notifications. No login required.
    """
    user = await get_or_create_user(
        session,
        device_token=user_data.device_token,
        platform=user_data.platform,
    )

    return UserResponse.model_validate(user)


@router.put("/{user_id}/token", response_model=UserResponse)
async def update_push_token(
    user_id: UUID,
    token_data: UserTokenUpdate,
    session: AsyncSession = Depends(get_db),
):
    """
    Update user's push notification token.

    Call this when the device token changes or on app startup.
    """
    user = await update_user_token(
        session,
        user_id=user_id,
        device_token=token_data.device_token,
        platform=token_data.platform,
    )

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return UserResponse.model_validate(user)


@router.get("/{user_id}/favorites", response_model=EventListResponse)
async def get_favorites(
    user_id: UUID,
    include_past: bool = False,
    session: AsyncSession = Depends(get_db),
):
    """
    Get user's favorited events.

    By default, only future events are returned.
    """
    events = await get_user_favorites(
        session,
        user_id=user_id,
        include_past=include_past,
    )

    return EventListResponse(
        events=[EventResponse.model_validate(e) for e in events],
        total=len(events),
    )


@router.post("/{user_id}/favorites", response_model=FavoriteResponse, status_code=201)
async def add_user_favorite(
    user_id: UUID,
    favorite: FavoriteAdd,
    session: AsyncSession = Depends(get_db),
):
    """
    Add an event to user's favorites.
    """
    # Check if event exists
    event = await get_event_by_id(session, favorite.event_id)
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")

    added = await add_favorite(session, user_id, favorite.event_id)

    return FavoriteResponse(event_id=favorite.event_id, added=added)


@router.delete("/{user_id}/favorites/{event_id}", status_code=204)
async def remove_user_favorite(
    user_id: UUID,
    event_id: str,
    session: AsyncSession = Depends(get_db),
):
    """
    Remove an event from user's favorites.
    """
    removed = await remove_favorite(session, user_id, event_id)

    if not removed:
        raise HTTPException(status_code=404, detail="Favorite not found")

    return None
