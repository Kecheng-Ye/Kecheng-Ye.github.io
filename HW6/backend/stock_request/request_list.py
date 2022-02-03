from flask_restful import Resource, request
from .util import ERROR

class request_lst(Resource):
    def __init__(self, **req_list):
        super().__init__()
        self.req_list = req_list
        
    def get(self):
        args = request.args
        stock_name = args["stock_name"]
        result = {}
        
        for name, req in self.req_list.items():
            one_result = req.get(stock_name)
            if(one_result == ERROR):
                return ERROR
            
            result[name] = one_result

        return result