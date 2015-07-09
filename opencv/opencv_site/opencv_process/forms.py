from django import forms

class ImageForm(forms.Form):
    item = forms.FileField()
    scene = forms.FileField()
