from flask_restful import Resource, request
from .util import ERROR

class request_lst(Resource):
    def __init__(self, **req_list):
        super().__init__()
        self.req_list = req_list
        
    def get(self):
        args = request.args
        stock_name = args["stock_name"]
        section = args["section"]
        
        result = {}
        
        if isinstance(self.req_list[section], request_lst):
            result = self.get_all(self.req_list[section], stock_name)
        else:
            result = self.req_list[section].get(stock_name)
 
        return result
        
    def get_all(self, sub_list, stock_name):
        result = {}
        
        for name, req in sub_list.req_list.items():
            one_result = req.get(stock_name)
            if(one_result == ERROR):
                return ERROR
            
            result[name] = one_result
            
        return result
