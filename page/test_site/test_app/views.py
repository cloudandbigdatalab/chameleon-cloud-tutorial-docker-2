from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.utils import timezone

import os

from .forms import PostForm
from .models import Post

def index(request):
    posts = Post.objects.all()

    if request.method == 'POST':
        form = PostForm(request.POST)
        if form.is_valid():
            p = Post(post_text=form.cleaned_data['post_text'], pub_date=timezone.now())
            p.save()

            return HttpResponseRedirect('/')
    else:
        form = PostForm()

    return render(request, 'test_app/index.html', {'form': form, 'posts': posts, 'title': os.environ['HOSTNAME']})
