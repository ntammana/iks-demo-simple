from flask import Flask
from flask import render_template

app = Flask(__name__)

@app.route('/')
@app.route('/helloworld', methods=('GET', 'POST'))
def index():
    return render_template('home.html')

if __name__ == '__main__':
    app.run()
