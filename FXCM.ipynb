#pip install fxcmpy==1.2.9
#pip install python-socketio==4.4
#pip install python-engineio==3.9
#pip install websocket-client==1.1.0

import fxcmpy
import socketio
import datetime as dt
import math

TOKEN = '4ffd2f8fb79858912386a852640c9ba7ce68cbdd'

con = fxcmpy.fxcmpy(access_token=TOKEN, log_level='error', log_file=None)

#configuration
globalSpreadBuy = 3
globalSpreadSell = 14
globalStop = 2

#global data
globalPositionOpen = 0
globalPositionTrailing = 0
globalPositionStop = 0
globalPositionType = ""
globalGross = 0
globalPrice = 0
globalMaxGross = 0

def priceConvert(price):
    price = format(price, '.5f')
    if len(str(price)) < 6 :
        price =  int(str(price) + "0")
        
    return int(str(str(price).replace(".", ""))[:6])

def priceConvertDot(price):
    return str(price)[:1] + "." + str(price)[1:]

def on_tick(data, df):
    #print("price changed")
    #print("Ask: {}".format(data['Rates'][0]))
    activePosition = getActivePosition(data['Rates'][0])
    print(activePosition)
    #if activePosition != null
     #   print(activePosition)

def getDifference(openPrice, actualPrice, isBuy):
    difference = 0
    openPrice = int(str(str(openPrice).replace(".", ""))[:6])
    actualPrice = int(str(str(actualPrice).replace(".", ""))[:6])
    
    if len(str(actualPrice)) < 6 :
        actualPrice =  int(str(actualPrice) + "0")
    elif len(str(openPrice)) < 6 :
        openPrice =  int(str(openPrice) + "0")    
    
    if isBuy: 
        difference = actualPrice - openPrice
    else:
        difference = openPrice - actualPrice
    
    return difference

def closeAllPositions():
    con.close_all()
    global globalMaxGross
    global globalSpreadBuy
    global globalSpreadSell
    global globalPositionType
    global globalGross
    global globalPrice
    global globalPositionOpen
    global globalPositionStop
    global globalPositionTrailing
    globalMaxGross = 0
    globalPositionType = ""
    globalGross = 0
    globalPrice = 0
    globalPositionOpen = 0
    globalPositionStop = 0
    globalPositionTrailing = 0

def getActivePosition(price):
    global globalMaxGross
    global globalSpreadBuy
    global globalSpreadSell
    global globalPositionType
    global globalGross
    global globalPrice
    global globalPositionOpen
    global globalPositionStop
    global globalPositionTrailing
    
    globalPrice =  priceConvert(price)
    
    trades = con.get_open_trade_ids()
    
    if not trades:
        return "Price % s" % (priceConvertDot(globalPrice))
    else:    
        pos = con.get_open_position(trades[0])  
        globalGross = pos.get_grossPL()
        globalPositionOpen = priceConvert(pos.get_open())        
                
        #difference = getDifference(pos.get_open(), price, pos.get_isBuy())    
        
        if pos.get_isBuy():
            globalPositionType = "Buy"
            globalPositionTrailing = globalPositionOpen + globalSpreadBuy
            
            if globalPrice > globalPositionTrailing:
                globalPositionTrailing = globalPrice
                if (globalPositionTrailing - globalStop) > globalPositionStop:
                    globalPositionStop = globalPositionTrailing - globalStop
            
            if globalPositionStop > 0:
                if globalPrice < globalPositionStop:
                    print("Closed at: " + str(globalGross))
                    closeAllPositions()
        else:
            globalPositionType = "Sell"
            globalPositionTrailing = globalPositionOpen - globalSpreadSell
            
            if globalPrice < globalPositionTrailing:
                globalPositionTrailing = globalPrice
                
                if (globalPositionTrailing + globalStop) < globalPositionStop or globalPositionStop == 0: 
                    globalPositionStop = globalPositionTrailing + globalStop
        
            if globalPositionStop > 0:
                if globalPrice > globalPositionStop:
                    print("Closed at: " + str(globalGross))
                    closeAllPositions()
                
        return "% s | Gross % s | Stop % s | Trailing % s | Actual % s | Open % s" % ( globalPositionType, globalGross, priceConvertDot(globalPositionStop), priceConvertDot(globalPositionTrailing), priceConvertDot(globalPrice), priceConvertDot(globalPositionOpen))

con.subscribe_market_data('EUR/USD',(on_tick,))
con.unsubscribe_market_data('EUR/USD')
con.get_accounts().T
con.get_last_price('EUR/USD')
sel = ['tradeId', 'amountK', 'currency', 'grossPL', 'isBuy']
con.get_open_positions()[sel]
con.get_open_positions_summary().T
con.get_closed_positions_summary().T
order = con.create_market_buy_order('EUR/USD',10)
order = con.create_market_sell_order('EUR/USD',10)
pos = con.get_open_position(140265045)
