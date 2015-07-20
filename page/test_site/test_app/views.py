from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.utils import timezone

import os

from .forms import PostForm
from .models import Post

def index(request):
    context = {}

    context['posts'] = Post.objects.all()
    context['title'] = os.environ['HOSTNAME']

    if request.method == 'POST':
        form = PostForm(request.POST)
        if form.is_valid():
            p = Post(post_text=form.cleaned_data['post_text'], pub_date=timezone.now())
            p.save()

            return HttpResponseRedirect('/')
    else:
        context['form'] = PostForm()

    return render(request, 'test_app/index.html', context)
