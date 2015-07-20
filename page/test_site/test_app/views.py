from django.shortcuts import render

def index(request):
    if request.method == 'POST':
        form = NameForm(request.POST)
        if form.is_valid():
            print (form.cleaned_data['post_text'])

            return HttpResponseRedirect('/')
    else:
        form = PostForm()

    return render(request, 'index.html', {'form': form})
