from app import app
from flask import render_template

@app.route('/')
@app.route('/helloworld', methods=('GET', 'POST'))
def index():
    return render_template('home.html')
