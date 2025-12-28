"""Diff engine for detecting schedule changes."""

from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from typing import Optional
import hashlib
import json
import structlog

log = structlog.get_logger()


class ChangeType(Enum):
    """Types of schedule changes we track."""
    TIME_CHANGED = "time_changed"
    DATE_CHANGED = "date_changed"
    VENUE_CHANGED = "venue_changed"
    STATUS_CHANGED = "status_changed"
    SESSION_MERGED = "session_merged"
    NEW_EVENT = "new_event"
    EVENT_REMOVED = "event_removed"


@dataclass
class ScheduleChange:
    """Represents a detected change in the schedule."""
    event_id: str
    sport: str
    event_name: str
    change_type: ChangeType
    old_value: Optional[str]
    new_value: Optional[str]
    detected_at: datetime
    
    def to_notification_text(self) -> str:
        """Generate user-friendly notification text."""
        templates = {
            ChangeType.TIME_CHANGED: f"⏰ {self.event_name}: Time changed from {self.old_value} to {self.new_value}",
            ChangeType.DATE_CHANGED: f"📅 {self.event_name}: Rescheduled to {self.new_value}",
            ChangeType.VENUE_CHANGED: f"📍 {self.event_name}: Moved to {self.new_value}",
            ChangeType.STATUS_CHANGED: f"⚠️ {self.event_name}: {self.new_value}",
            ChangeType.SESSION_MERGED: f"🔀 {self.event_name}: Session combined",
            ChangeType.NEW_EVENT: f"🆕 New event: {self.event_name}",
            ChangeType.EVENT_REMOVED: f"❌ Removed: {self.event_name}",
        }
        return templates.get(self.change_type, f"Change in {self.event_name}")
    
    def to_dict(self) -> dict:
        """Convert to dictionary for storage."""
        return {
            "event_id": self.event_id,
            "sport": self.sport,
            "event_name": self.event_name,
            "change_type": self.change_type.value,
            "old_value": self.old_value,
            "new_value": self.new_value,
            "detected_at": self.detected_at.isoformat(),
        }


class DiffEngine:
    """
    Compares schedule snapshots and detects changes.
    
    Usage:
        engine = DiffEngine()
        changes = engine.compare(old_schedule, new_schedule)
        for change in changes:
            print(change.to_notification_text())
    """
    
    # Fields that trigger notifications when changed
    TRACKED_FIELDS = ["date", "time", "venue", "status"]
    
    def compute_hash(self, event: dict) -> str:
        """
        Create deterministic hash of event data.
        
        Args:
            event: Event dictionary
            
        Returns:
            MD5 hash of key fields
        """
        data = {k: event.get(k) for k in self.TRACKED_FIELDS}
        return hashlib.md5(json.dumps(data, sort_keys=True).encode()).hexdigest()
    
    def compare(
        self,
        old_schedule: list[dict],
        new_schedule: list[dict]
    ) -> list[ScheduleChange]:
        """
        Compare two schedule snapshots and return list of changes.
        
        Args:
            old_schedule: Previous schedule snapshot
            new_schedule: New schedule snapshot
            
        Returns:
            List of detected ScheduleChange objects
        """
        changes: list[ScheduleChange] = []
        now = datetime.utcnow()
        
        # Index by event_id for O(1) lookup
        old_by_id = {e["event_id"]: e for e in old_schedule}
        new_by_id = {e["event_id"]: e for e in new_schedule}
        
        # Check for modified or removed events
        for event_id, old_event in old_by_id.items():
            if event_id not in new_by_id:
                # Event was removed
                changes.append(ScheduleChange(
                    event_id=event_id,
                    sport=old_event.get("sport", ""),
                    event_name=old_event.get("event_name", "Unknown"),
                    change_type=ChangeType.EVENT_REMOVED,
                    old_value=old_event.get("event_name"),
                    new_value=None,
                    detected_at=now
                ))
                continue
            
            new_event = new_by_id[event_id]
            
            # Check each tracked field for changes
            changes.extend(self._compare_event(old_event, new_event, now))
        
        # Check for new events
        for event_id, new_event in new_by_id.items():
            if event_id not in old_by_id:
                changes.append(ScheduleChange(
                    event_id=event_id,
                    sport=new_event.get("sport", ""),
                    event_name=new_event.get("event_name", "Unknown"),
                    change_type=ChangeType.NEW_EVENT,
                    old_value=None,
                    new_value=new_event.get("event_name"),
                    detected_at=now
                ))
        
        if changes:
            log.info("Changes detected", count=len(changes))
        
        return changes
    
    def _compare_event(
        self,
        old_event: dict,
        new_event: dict,
        now: datetime
    ) -> list[ScheduleChange]:
        """Compare two versions of the same event."""
        changes: list[ScheduleChange] = []
        event_id = new_event["event_id"]
        sport = new_event.get("sport", "")
        event_name = new_event.get("event_name", "Unknown")
        
        # Time changed
        if old_event.get("time") != new_event.get("time"):
            changes.append(ScheduleChange(
                event_id=event_id,
                sport=sport,
                event_name=event_name,
                change_type=ChangeType.TIME_CHANGED,
                old_value=old_event.get("time"),
                new_value=new_event.get("time"),
                detected_at=now
            ))
        
        # Date changed
        if old_event.get("date") != new_event.get("date"):
            changes.append(ScheduleChange(
                event_id=event_id,
                sport=sport,
                event_name=event_name,
                change_type=ChangeType.DATE_CHANGED,
                old_value=old_event.get("date"),
                new_value=new_event.get("date"),
                detected_at=now
            ))
        
        # Venue changed
        if old_event.get("venue") != new_event.get("venue"):
            changes.append(ScheduleChange(
                event_id=event_id,
                sport=sport,
                event_name=event_name,
                change_type=ChangeType.VENUE_CHANGED,
                old_value=old_event.get("venue"),
                new_value=new_event.get("venue"),
                detected_at=now
            ))
        
        # Status changed (e.g., scheduled -> postponed -> cancelled)
        if old_event.get("status") != new_event.get("status"):
            changes.append(ScheduleChange(
                event_id=event_id,
                sport=sport,
                event_name=event_name,
                change_type=ChangeType.STATUS_CHANGED,
                old_value=old_event.get("status"),
                new_value=new_event.get("status"),
                detected_at=now
            ))
        
        return changes
    
    def has_changes(
        self,
        old_schedule: list[dict],
        new_schedule: list[dict]
    ) -> bool:
        """
        Quick check if there are any changes (without computing details).
        
        Args:
            old_schedule: Previous schedule snapshot
            new_schedule: New schedule snapshot
            
        Returns:
            True if any changes detected
        """
        # Quick length check
        if len(old_schedule) != len(new_schedule):
            return True
        
        # Compare hashes
        old_hashes = {e["event_id"]: self.compute_hash(e) for e in old_schedule}
        new_hashes = {e["event_id"]: self.compute_hash(e) for e in new_schedule}
        
        return old_hashes != new_hashes
