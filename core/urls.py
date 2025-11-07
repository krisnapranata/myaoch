from django.urls import path
from . import views_old

# from myaoch.core.views_old import (
#     operator_dashboard, input_kesiapan, operator_history,
#     spv_dashboard, verifikasi_spv,
#     aoch_dashboard, laporan_aoch,
#     gm_dashboard, gm_laporan,
#     dashboard_global, dashboard_api_view
# )

from core.view import (
    operator_dashboard, input_kesiapan, operator_history,
    spv_dashboard, verifikasi_spv,
    aoch_dashboard, laporan_aoch,
    gm_dashboard, gm_laporan,
    dashboard_view, api_view,
    auth_views, get_biaya_kemarin
)

urlpatterns = [
    path('', dashboard_view, name='dashboard'),
    path('dashboard/', dashboard_view, name='dashboard'),
    # path('api/dashboard/', views_old.dashboard_api_view, name='dashboard_api'),
    # path('api/dashboard/', dashboard_api_view, name='dasboard_api_view'),

    path('portal/login/', auth_views.login_view, name='portal_login'),
    path('portal/logout/', auth_views.logout_view, name='portal_logout'),
    # path('portal/dashboard/', dashboard_views.dashboard_view, name='portal_dashboard'),

    # Operator
    path('operator/dashboard/', operator_dashboard, name='dashboard_operator'),
    path('operator/input/', input_kesiapan, name='input_kesiapan'),
    path('operator/history/', operator_history, name='operator_history'),

    # SPV
    path('spv/dashboard/', spv_dashboard, name='dashboard_spv'),
    path('spv/verifikasi/', verifikasi_spv, name='verifikasi_spv'),

    # AOCH
    path('aoch/dashboard/', aoch_dashboard, name='dashboard_aoch'),
    path('aoch/laporan/', laporan_aoch, name='laporan_aoch'),

    # GM
    path('gm/dashboard/', gm_dashboard, name='dashboard_gm'),
    path('gm/laporan/', gm_laporan, name='gm_laporan'),

    # Dashboard Umum
    # path('dashboard/', dashboard_global, name='dashboard_global'),

    # API
    # path('api/dashboard/', dashboard_api_view, name='api_dashboard'),
    path('api/dashboard/', api_view, name='dasboard_api_view'),

    # ... route lain ...
    path('ajax/get_jumlah_alat/<int:peralatan_id>/',
         views_old.get_jumlah_alat, name='get_jumlah_alat'),

    path("api/get-biaya-kemarin/", get_biaya_kemarin, name="get_biaya_kemarin"),
]
