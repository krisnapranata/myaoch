# core/utils/notifications.py
from django.db import transaction
from django.utils import timezone
from core.models import Notifikasi, AppUser


def create_notification_for_user(user, title, message, jenis='Kesiapan',
                                 related_model=None, related_id=None, link=None, unit=None):
    return Notifikasi.objects.create(
        user=user,
        judul=title,
        pesan=message,
        jenis=jenis,
        related_model=related_model,
        related_id=related_id,
        link=link,
        unit=unit,
        created_at=timezone.now()
    )


def create_notification_for_role(role, unit, title, message, jenis='Kesiapan',
                                 related_model=None, related_id=None, link=None):
    qs = AppUser.objects.filter(role=role, is_active=True)
    if unit is not None:
        qs = qs.filter(unit=unit)
    notifs = []
    with transaction.atomic():
        for u in qs:
            notifs.append(Notifikasi(
                user=u,
                judul=title,
                pesan=message,
                jenis=jenis,
                related_model=related_model,
                related_id=related_id,
                link=link,
                unit=unit,
            ))
        Notifikasi.objects.bulk_create(notifs)
    return len(notifs)
