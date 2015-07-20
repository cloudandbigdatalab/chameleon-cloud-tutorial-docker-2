from django import forms

class PostForm(forms.Form):
    post_text = forms.CharField(max_length=140)
