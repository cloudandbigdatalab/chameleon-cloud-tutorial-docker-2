from django import forms

class PostForm(forms.Form):
    post_text = forms.CharField(label='New Post', max_length=140)
