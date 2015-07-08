from django.http import HttpResponse

def process(request):
    return HttpResponse("You're at the image process page.")
