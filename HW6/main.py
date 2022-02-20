from backend.stock_request import *
from flask import Flask, render_template
from flask import Flask
from flask_restful import Api, Resource, request, reqparse
from flask_cors import CORS
from flask_jsglue import JSGlue
import os


app = Flask(__name__, static_folder="frontend")
api = Api(app)

@app.route('/')
def home():
   return app.send_static_file("./main.html")

api.add_resource(request_lst, "/query", endpoint="query", 
                 resource_class_kwargs={
                    'brief'     : base_req(brief_req),
                    
                    'summary'   : request_lst(recommend=base_req(recommend_req, post_process=lambda x : x[0]), #only get the most recent day's recommendation
                                              summary=base_req(summary_req)),
                    
                    'charts'    : stock_history_request(charts_req),
                    
                    'news'      : stock_news_request(news_req)
                  }
               )
    
if __name__ == "__main__":
    app.run(host='127.0.0.1', port=8080, debug=True)
