import datetime

API_KEY = "c7qumeiad3ia6nr4tkfg"
ERROR   = {"Error" : "error"}

identity = lambda x : x

# brief constant
brief_req               = "https://finnhub.io/api/v1/stock/profile2?symbol={}&token={}"
brief_required          = {"logo": identity, "name": identity, "ticker": identity, "exchange": identity, "ipo": identity, "finnhubIndustry": identity}

# summary constant
summary_req             = "https://finnhub.io/api/v1/quote?symbol={}&token={}"
summary_required        = {
                            "t"   : (lambda timestamp : datetime.datetime.fromtimestamp(timestamp).strftime("%d %B, %Y")),
                            "pc"  : identity,
                            "o"   : identity,
                            "h"   : identity,
                            "l"   : identity,
                            "d"   : identity,
                            "dp"  : identity
                        }

# Recommendation trend constant
recommend_req          = "https://finnhub.io/api/v1/stock/recommendation?symbol={}&token={}"
recommend_required     = {"strongSell" : identity, "sell" : identity, "hold" : identity, "buy": identity, "strongBuy" : identity}