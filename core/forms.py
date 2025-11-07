from django import forms
from .models import NilaiKesiapan


class NilaiKesiapanForm(forms.ModelForm):
    class Meta:
        model = NilaiKesiapan
        fields = '__all__'

    def clean(self):
        cleaned_data = super().clean()
        jumlah_alat_normal = cleaned_data.get("jumlah_alat_normal")
        peralatan = cleaned_data.get("peralatan")

        if peralatan and jumlah_alat_normal is not None:
            total_alat = peralatan.jumlah_alat or 1
            nilai = (jumlah_alat_normal / total_alat) * 100
            cleaned_data["nilai"] = round(nilai, 2)

        return cleaned_data


class ReadOnlyRupiahInput(forms.TextInput):
    template_name = "widgets/readonly_rupiah.html"

    def format_value(self, value):
        if value is None or value == "":
            return ""
        try:
            value = float(value)
            return "Rp {:,}".format(int(value)).replace(",", ".")
        except:
            return value
