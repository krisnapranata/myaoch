from django.urls import path
from . import views_old, views_notif

from core.view import (
    operator_dashboard,
    input_kesiapan,
    operator_history,
    spv_dashboard,
    verifikasi_spv,
    aoch_dashboard,
    laporan_aoch,
    gm_dashboard,
    gm_laporan,
    dashboard_view,
    api_view,
    auth_views,
    get_biaya_kemarin,
    # operator
    operator_save_kesiapan,
    operator_save_all,
    # peralatan
    peralatan_list,
    peralatan_add,
    peralatan_edit,
    peralatan_delete,
    ajax_generate_kode,
    peralatan_detail_json,
    # energi
    energi_list,
    energi_add,
    energi_edit,
    energi_delete,
    energi_detail_json,
    energy_setting_update,


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
    path("operator/dashboard/", operator_dashboard, name="operator_dashboard"),
    path("operator/save/", operator_save_kesiapan,
         name="operator_save_kesiapan"),
    # path('operator/dashboard/', operator_dashboard, name='dashboard_operator'),
    path('operator/input/', input_kesiapan, name='input_kesiapan'),
    path('operator/history/', operator_history, name='operator_history'),
    path("operator/save-all/", operator_save_all,
         name="operator_save_all"),

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

    path("notif/open/<int:notif_id>/",
         views_notif.notif_read_and_go, name="notif_open"),
    path("notifikasi/", views_notif.notifikasi_list, name="notifikasi_list"),

    # Peralatan
    path("peralatan/", peralatan_list, name="peralatan_list"),
    path("peralatan/add/", peralatan_add, name="peralatan_add"),
    path("peralatan/<int:pk>/edit/", peralatan_edit, name="peralatan_edit"),
    path("peralatan/<int:pk>/delete/", peralatan_delete, name="peralatan_delete"),
    path("peralatan/generate-kode/", ajax_generate_kode, name="ajax_generate_kode"),
    path("peralatan/<int:pk>/json/", peralatan_detail_json,
         name="peralatan_detail_json"),

    # Energi
    path("energi/", energi_list, name="energi_list"),             # LIST
    path("energi/add/", energi_add, name="energi_add"),          # ADD (POST)
    path("energi/<int:pk>/edit/", energi_edit, name="energi_edit"),  # EDIT
    path("energi/<int:pk>/delete/", energi_delete,
         name="energi_delete"),  # DELETE
    path("energi/<int:pk>/json/", energi_detail_json,
         name="energi_detail_json"),  # AJAX JSON
    path("energi/setting/update/", energy_setting_update,
         name="energy_setting_update"),


]
