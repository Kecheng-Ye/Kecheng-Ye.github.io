from stock_request import *
from flask import Flask
from flask_restful import Api, Resource, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
api = Api(app)

def test_func(**argv): 
    print(argv)
    
def main():
    api.add_resource(request_lst, "/query", endpoint="query", 
                     resource_class_kwargs={'brief'     : base_req(brief_req, brief_required),
                                            'summary'   : base_req(summary_req, summary_required),
                                            'recommend' : base_req(recommend_req, recommend_required, post_process=lambda x : x[0]), #only get the most recent day's recommendation
                                            }
                    )
    app.run(debug=True)
    
if __name__ == "__main__":
    main()
