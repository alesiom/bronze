"""Device registration and favorites sync endpoints."""

from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
import structlog

from src.db import get_session, register_device, get_device_by_id, sync_favorites, get_device_favorites
from src.api.models import DeviceRegister, DeviceResponse, FavoritesSync, FavoritesSyncResponse

log = structlog.get_logger()
router = APIRouter(prefix="/devices", tags=["devices"])


async def get_db():
    """Dependency for database session."""
    async with get_session() as session:
        yield session


@router.post("", response_model=DeviceResponse, status_code=201)
async def register_device_endpoint(
    device_data: DeviceRegister,
    session: AsyncSession = Depends(get_db),
):
    """
    Register a device for push notifications.

    Call this on app startup with the FCM/APNs token.
    If the device is already registered, returns the existing device.
    """
    device = await register_device(
        session,
        token=device_data.token,
        platform=device_data.platform,
    )

    log.info("Device registered", device_id=str(device.id), platform=device.platform)
    return DeviceResponse.model_validate(device)


@router.put("/{device_id}/favorites", response_model=FavoritesSyncResponse)
async def sync_device_favorites(
    device_id: UUID,
    favorites: FavoritesSync,
    session: AsyncSession = Depends(get_db),
):
    """
    Sync device favorites (bulk replace).

    This replaces all favorites for the device with the provided list.
    Call this when the app comes online to sync local favorites to server.
    """
    # Check device exists
    device = await get_device_by_id(session, device_id)
    if not device:
        raise HTTPException(status_code=404, detail="Device not found")

    count = await sync_favorites(session, device_id, favorites.event_ids)

    log.info("Favorites synced", device_id=str(device_id), count=count)
    return FavoritesSyncResponse(synced=count, event_ids=favorites.event_ids)


@router.get("/{device_id}/favorites", response_model=FavoritesSyncResponse)
async def get_device_favorites_endpoint(
    device_id: UUID,
    session: AsyncSession = Depends(get_db),
):
    """
    Get device's synced favorites.

    Returns the list of event IDs that have been synced to the server.
    """
    # Check device exists
    device = await get_device_by_id(session, device_id)
    if not device:
        raise HTTPException(status_code=404, detail="Device not found")

    event_ids = await get_device_favorites(session, device_id)

    return FavoritesSyncResponse(synced=len(event_ids), event_ids=event_ids)
