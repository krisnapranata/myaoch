from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from core.models import NilaiKesiapan
from core.utils.notifications import (
    create_notification_for_user,
    create_notification_for_role
)


# ============================================================
# 1️⃣ PRE_SAVE – simpan status lama sebelum di-update
# ============================================================
@receiver(pre_save, sender=NilaiKesiapan)
def store_old_status(sender, instance, **kwargs):
    if instance.pk:
        old = sender.objects.filter(pk=instance.pk).first()
        instance._old_status = old.status if old else None
    else:
        instance._old_status = None


# ============================================================
# 2️⃣ POST_SAVE – buat notifikasi saat status berubah
# ============================================================
@receiver(post_save, sender=NilaiKesiapan)
def notif_status_change(sender, instance, created, **kwargs):

    if created:
        return

    old = getattr(instance, "_old_status", None)
    new = instance.status

    if old == new:
        return  # status tidak berubah

    peralatan = instance.peralatan
    operator = instance.user_input
    unit = peralatan.unit

    # ============================================================
    # SPV Verifikasi → Diverifikasi SPV
    # ============================================================
    if new == "Diverifikasi SPV":

        # 🔵 Notif ke Operator (tetap)
        if operator:
            create_notification_for_user(
                user=operator,
                title=f"SPV Memverifikasi: {peralatan.nama_peralatan}",
                message="SPV telah memverifikasi kesiapan Anda.",
                related_model="NilaiKesiapan",
                related_id=instance.id,
                link=f"/kesiapan/{instance.id}/detail",
                unit=unit,
            )

        # 🔵 Notif ke AOCH
        create_notification_for_role(
            role="AOCH",
            unit=unit,
            title=f"Kesiapan Diverifikasi SPV",
            message=f"{peralatan.nama_peralatan} diverifikasi oleh SPV.",
            related_model="NilaiKesiapan",
            related_id=instance.id,
            link=f"/kesiapan/{instance.id}/detail",
        )

        # 🔵 **Notif ke SEMUA SPV dalam unit ini**
        create_notification_for_role(
            role="SPV",
            unit=unit,
            title=f"SPV Memverifikasi: {peralatan.nama_peralatan}",
            message=f"Peralatan {peralatan.nama_peralatan} telah diverifikasi oleh SPV.",
            related_model="NilaiKesiapan",
            related_id=instance.id,
            link=f"/kesiapan/{instance.id}/detail",
        )

        return

    # ============================================================
    # AOCH Verifikasi → Diverifikasi AOCH
    # ============================================================
    if new == "Diverifikasi AOCH":

        if operator:
            create_notification_for_user(
                user=operator,
                title=f"AOCH Memverifikasi: {peralatan.nama_peralatan}",
                message="AOCH telah memverifikasi kesiapan Anda.",
                related_model="NilaiKesiapan",
                related_id=instance.id,
                link=f"/kesiapan/{instance.id}/detail",
            )

        create_notification_for_role(
            role="SPV",
            unit=unit,
            title=f"AOCH Memverifikasi: {peralatan.nama_peralatan}",
            message="AOCH telah memverifikasi hasil SPV.",
            related_model="NilaiKesiapan",
            related_id=instance.id,
            link=f"/kesiapan/{instance.id}/detail",
        )
        return

    # ============================================================
    # AOCH minta GM → Butuh Verif GM
    # ============================================================
    if new == "Butuh Verif GM":

        create_notification_for_role(
            role="GM",
            unit=None,
            title=f"Permintaan Verifikasi GM",
            message=f"AOCH meminta verifikasi GM untuk {peralatan.nama_peralatan}.",
            related_model="NilaiKesiapan",
            related_id=instance.id,
            link=f"/kesiapan/{instance.id}/detail",
        )
        return

    # ============================================================
    # FINAL oleh AOCH/GM → Final
    # ============================================================
    if new == "Final":

        if operator:
            create_notification_for_user(
                user=operator,
                title=f"STATUS FINAL: {peralatan.nama_peralatan}",
                message="Kesiapan Anda telah dinyatakan FINAL.",
                related_model="NilaiKesiapan",
                related_id=instance.id,
                link=f"/kesiapan/{instance.id}/detail",
            )

        create_notification_for_role(
            role="SPV",
            unit=unit,
            title=f"FINAL: {peralatan.nama_peralatan}",
            message="Status kesiapan telah final.",
            related_model="NilaiKesiapan",
            related_id=instance.id,
            link=f"/kesiapan/{instance.id}/detail",
        )

        create_notification_for_role(
            role="AOCH",
            unit=unit,
            title=f"FINAL: {peralatan.nama_peralatan}",
            message="Status kesiapan telah final.",
            related_model="NilaiKesiapan",
            related_id=instance.id,
            link=f"/kesiapan/{instance.id}/detail",
        )
        return
