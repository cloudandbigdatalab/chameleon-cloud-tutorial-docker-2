import socket
import psycopg2
from yattag import Doc
from yattag import indent
import markdown
import codecs
import sys

def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    
    doc, tag, text = Doc().tagtext()
    
    doc.asis('<!DOCTYPE html>')
    with tag('head'):
        doc.stag('meta', name = 'viewport', content = 'width=device-width, initial-scale=1')
        with tag('title'):
            text('Chameleon Docker Demo')
        doc.stag('link', rel = 'stylesheet', href = 
        'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css')
    with tag('body'):
        with tag('div', klass = 'container-fluid'):
            with tag('div', klass = 'row'):
                with tag('div', klass = 'col-xs-12 col-md-6 col-md-offset-3'):
                    with tag('h1', klass = 'text-center'):
                        text('Chameleon Cloud Docker Demo')
                    input_file = codecs.open("description.md", mode="r")
                    doc.asis(str(markdown.markdown(input_file.read())))
                    input_file.close()
            try:
                with tag('div', klass = 'row'):
                    with tag('div', klass = 'col-xs-12 col-md-2 col-md-offset-5'):
                        with tag('div', klass = 'list-group'):
                            conn = psycopg2.connect(host = socket.gethostbyname('postgres'), user = 'docker',
                            password = 'docker', database = 'docker')
                            cur = conn.cursor()
                            cur.execute('select name from demosite')
                            for row in cur.fetchall():
                                with tag('div', klass = 'list-group-item'):
                                    text(row[0])
                            cur.close()
                            conn.close()
            except:
                print "Postgres error:", sys.exc_info()
                with tag('div', klass = 'row'):
                    with tag('div', klass = 'col-xs-12 col-md-6 col-md-offset-3'):
                        with tag('div', klass = 'alert alert-warning text-center', role = 'alert'):
                            with tag('b'):
                                text('Error!')
                            text(' ')
                            text('Unable to retrieve database items.')
    return doc.getvalue()
