from flask import Flask, render_template
import json
app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template('home.html')

@app.route('/exercices/')
def exercices():
    return render_template('exercices.html')

if __name__ == "__main__":
  app.run(debug=True)
