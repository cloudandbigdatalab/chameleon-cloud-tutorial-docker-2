from django.shortcuts import render

from .forms import PostForm

def index(request):
    if request.method == 'POST':
        form = NameForm(request.POST)
        if form.is_valid():
            print (form.cleaned_data['post_text'])

            return HttpResponseRedirect('/')
    else:
        form = PostForm()

    return render(request, 'test_app/index.html', {'form': form})
