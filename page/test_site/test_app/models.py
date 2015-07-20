from django.db import models

class Post(models.Model):
    post_text = models.CharField(max_length=140)
    pub_date = models.DateTimeField()
