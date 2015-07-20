from django import forms

class PostForm(forms.Form):
    post_text = forms.CharField(label='', max_length=140)
