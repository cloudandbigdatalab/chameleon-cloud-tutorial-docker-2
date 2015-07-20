from django import forms

class PostForm(forms.Form):
    post_text = forms.CharField(label='Text', max_length=140)
