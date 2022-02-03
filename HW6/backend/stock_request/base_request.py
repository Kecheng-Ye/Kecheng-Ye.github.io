from flask_restful import Resource
from .util import *
import requests
import json

class base_req(Resource):
    def __init__(self, req_format, required_field):
        super().__init__()
        self.request = req_format
        self.required = required_field
        
    def get(self, stock_name):
        result = requests.get(self.request.format(stock_name, API_KEY)).json()
        
        if len(result) == 0:
            return ERROR
                
        return {key : self.required[key](result[key]) for key in result.keys() if key in self.required}
     
        