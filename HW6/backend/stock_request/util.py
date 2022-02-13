import datetime

API_KEY = "c7qumeiad3ia6nr4tkfg"
ERROR   = {"Error" : "error"}

identity = lambda x : x

# brief constant
brief_req               = "https://finnhub.io/api/v1/stock/profile2?symbol={}&token={}"


# summary constant
summary_req             = "https://finnhub.io/api/v1/quote?symbol={}&token={}"


# Recommendation trend constant
recommend_req           = "https://finnhub.io/api/v1/stock/recommendation?symbol={}&token={}"

# Stock charts
charts_req              = "https://finnhub.io/api/v1/stock/candle?symbol={}&resolution=D&from={}&to={}&token={}"
