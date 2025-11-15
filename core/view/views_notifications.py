from django.http import JsonResponse
from django.contrib.auth.decorators import login_required
from core.view.decorators import appuser_required
from django.core.paginator import Paginator
from django.views.decorators.http import require_POST
import json
from core.models import Notifikasi, AppUser


def get_current_appuser(request):
    from core.models import AppUser
    appuser_id = request.session.get("appuser_id")

    if not appuser_id:
        return None

    try:
        return AppUser.objects.get(id=appuser_id, is_active=True)
    except AppUser.DoesNotExist:
        return None


@appuser_required
def notif_count(request):
    user = get_current_appuser(request)

    if not user:
        return JsonResponse({'unread': 0})
    count = Notifikasi.objects.filter(user=user, status_baca=False).count()
    return JsonResponse({'unread': count})


@appuser_required
def notif_list(request):
    user = get_current_appuser(request)
    if not user:
        return JsonResponse({'results': [], 'has_next': False})
    qs = Notifikasi.objects.filter(user=user).order_by('-created_at')
    page_num = int(request.GET.get('page', 1))
    paginator = Paginator(qs, 20)
    page = paginator.get_page(page_num)
    items = []
    for n in page:
        items.append({
            'id': n.id,
            'title': n.judul,
            'message': n.pesan,
            'jenis': n.jenis,
            'is_read': n.status_baca,
            'created_at': n.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            'link': n.link or '#',
        })
    return JsonResponse({'results': items, 'has_next': page.has_next()})


@require_POST
@appuser_required
def notif_mark_read(request):
    user = get_current_appuser(request)
    if not user:
        return JsonResponse({'ok': False}, status=400)
    body = json.loads(request.body.decode('utf-8') or '{}')
    notif_id = body.get('id')
    if notif_id == 'all':
        Notifikasi.objects.filter(
            user=user, status_baca=False).update(status_baca=True)
        return JsonResponse({'ok': True})
    else:
        Notifikasi.objects.filter(
            user=user, id=notif_id).update(status_baca=True)
        return JsonResponse({'ok': True})
