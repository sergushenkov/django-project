from django.shortcuts import render, HttpResponse

def test(request):
    return render(request, 'products/test.html')

def index(request):
    return render(request, 'products/index.html')

def products(request):
    return render(request, 'products/products.html')