from django.db import models

class Post(models.Model):
    post_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')
