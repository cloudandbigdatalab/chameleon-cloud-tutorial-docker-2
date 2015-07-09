from django.http import HttpResponseRedirect, HttpResponse
from django.shortcuts import render

from .forms import ImageForm

from .opencv import featureMatch

def process(request):
    if request.method == 'POST':
        form = ImageForm(request.POST, request.FILES)
        if form.is_valid():
            resultFile = featureMatch(request.FILES['item'], request.FILES['scene'])
            with open(resultFile, "rb") as f:
                return HttpResponse(f.read(), content_type="image/jpeg")
    else:
        form = ImageForm()

    return render(request, 'opencv_process/process.html', {'form': form})

def result(request):
    return render(request, 'opencv_process/result.html')
