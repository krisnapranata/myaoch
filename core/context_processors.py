from core.models import Notifikasi


def notif_context(request):
    user = getattr(request, "appuser", None)
    if not user:
        return {}

    qs = Notifikasi.objects.filter(
        user=user, status_baca=False).order_by("-created_at")

    return {
        "notif_unread_count": qs.count(),
        "notif_list": qs[:7],
    }
