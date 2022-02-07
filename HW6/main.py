from backend.stock_request import *
from flask import Flask, render_template
from flask import Flask
from flask_restful import Api, Resource, request
from flask_cors import CORS
import os

app = Flask(__name__, static_folder="frontend")
CORS(app)
api = Api(app)

@app.route('/')
def home():
   return render_template('./main.html')

def main():
    api.add_resource(request_lst, "/query", endpoint="query", 
                     resource_class_kwargs={
                        'brief'     : base_req(brief_req),
                        'summary'   : request_lst(summary=base_req(summary_req), 
                                                  recommend=base_req(recommend_req, post_process=lambda x : x[0]))#only get the most recent day's recommendation
                        }
                    )
    
    app.run(debug=True) 
    
if __name__ == "__main__":
    main()
