from flask_restful import Resource
from .util import *
import requests
import json
from datetime import datetime
from dateutil.relativedelta import relativedelta

class base_req(Resource):
    def __init__(self, req_format, post_process=identity):
        super().__init__()
        self.request = req_format
        self.post_process = post_process
        
    def get(self, stock_name):
        result = requests.get(self.request.format(stock_name, API_KEY)).json()
        
        if len(result) == 0:
            return ERROR
        
        result = self.post_process(result)
        
        return result
     
class stock_history_request(base_req):
    def __init__(self, req_format):
        super().__init__(req_format)
        # self.post_process = self.transfer_data
    
    def transfer_data(self, data):
        result = []
        
        price = []
        volumn = []
        for i in range(len(data['t'])):
            price.append([data['t'][i] * 1000, data['c'][i]])
            volumn.append([data['t'][i] * 1000, data['v'][i]])
            
        result.append(price)
        result.append(volumn)
        
        return result
    
    def get(self, stock_name):
        end = datetime.now().date()
        delta = relativedelta(months=6, days=1)
        start = end - delta
        
        result = requests.get(self.request.format(stock_name, start.strftime("%s"), end.strftime("%s"), API_KEY)).json()
        
        if len(result) == 0:
            return ERROR
        
        result = self.post_process(result)
        
        return result
    
class stock_news_request(base_req):
    def __init__(self, req_format):
        super().__init__(req_format)
        # self.post_process = self.transfer_data
    
    def get(self, stock_name):
        end = datetime.now().date()
        delta = relativedelta(days=30)
        start = end - delta
        
        result = requests.get(self.request.format(stock_name, start.strftime('%Y-%m-%d'), end.strftime('%Y-%m-%d'), API_KEY)).json()
        
        if len(result) == 0:
            return ERROR
        
        result = self.post_process(result)
        
        return result