from django.shortcuts import redirect
from core.models import AppUser


class PortalAuthMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Biarkan login dan static file lewat
        allowed_paths = ['/portal/login/', '/portal/logout/', '/static/']
        if any(request.path.startswith(p) for p in allowed_paths):
            return self.get_response(request)

        user_id = request.session.get('appuser_id')
        if not user_id:
            return redirect('/portal/login/')

        try:
            request.appuser = AppUser.objects.get(id=user_id)
        except AppUser.DoesNotExist:
            del request.session['appuser_id']
            return redirect('/portal/login/')

        return self.get_response(request)
