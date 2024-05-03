from flask import Flask
import time

app = Flask(__name__)



@app.route('/')
def hello_world():
    j=1
    for i in range(300000000):
        j+=1
    result = "Helloworld" + str(j)
    return result


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)



