import MetaTrader5 as mt5
import time

if not mt5.initialize():
    print("Error al inicializar MetaTrader 5.")
    quit()
    
globalSpreadBuy = 3
globalSpreadSell = 3
globalTrailing = 3
globalTrailingStop = 2
globalSymbol = "EURUSD"
globalVolume = 0.10

globalLastPrice = 0
globalPositionOpen = 0
globalPositionStop = 0
globalPositionType = ""
globalGross = 0
globalPrice = 0
globalMaxGross = 0
globalPositionTrailingN = 0
globalPositionTrailingV = 0

def priceConvert(price):
    price = format(price, '.5f')
    if len(price) == 5:
        price += '0'
    return int(str(str(price).replace(".", ""))[:6])

def closePosition(pos):
    close_request = {
        "action": mt5.TRADE_ACTION_DEAL,
        "symbol": pos.symbol,
        "volume": globalVolume,
        "type": mt5.ORDER_TYPE_BUY if pos.type == 1 else mt5.ORDER_TYPE_SELL,
        "position": pos.ticket,
        "price": mt5.symbol_info_tick(pos.symbol).bid,
        "deviation": 20,
        "magic": 234000,
        "comment": 'Close trade',
        "type_time": mt5.ORDER_TIME_GTC,
        "type_filling": mt5.ORDER_FILLING_IOC,
    }

    # Envío de la orden de cierre al servidor de MetaTrader 5
    result = mt5.order_send(close_request)

    if result.retcode != mt5.TRADE_RETCODE_DONE:
        print("Error al cerrar la posición: ", result.comment)
    else:
        print("Posición cerrada con éxito. Resultado: ", result)
        global globalMaxGross
        global globalSpreadBuy
        global globalSpreadSell
        global globalPositionType
        global globalGross
        global globalPrice
        global globalPositionOpen
        global globalPositionStop
        global globalPositionTrailingN
        global globalPositionTrailingV
        globalMaxGross = 0
        globalPositionType = ""
        globalGross = 0
        globalPrice = 0
        globalPositionOpen = 0
        globalPositionStop = 0
        globalPositionTrailingN = 0
        globalPositionTrailingV = 0

def printInfo(type):
    if type == 1:
        print("-------------------")
        print("Tipo: "+str(globalPositionType))               
        print("Ganacia: "+str(globalGross))
        print("Open: "+str(globalPositionOpen))
        print("Precio: "+str(globalPrice))
        print("TrailingN: "+str(globalPositionTrailingN))
        print("TrailingV: "+str(globalPositionTrailingV))
        print("Stop: "+str(globalPositionStop))
        print("Diff: "+str(globalPositionTrailingV - globalPositionTrailingN))
        print("-------------------")
        
def getActivePosition(price):
    global globalMaxGross
    global globalSpreadBuy
    global globalSpreadSell
    global globalPositionType
    global globalGross
    global globalPrice
    global globalPositionOpen
    global globalPositionStop
    global globalPositionTrailingN
    global globalPositionTrailingV
    global globalTrailingStop
        
    globalPrice = priceConvert(price)
    
    trades = mt5.positions_get() 
    if trades:   
        pos = mt5.positions_get()[0] 
        globalGross = pos.profit
        globalPositionOpen = priceConvert(pos.price_open)           
        
        if pos.type == 1:
            globalPositionType = "Sell"
            globalPositionTrailingN = globalPositionTrailingN if globalPositionTrailingN > 0 else globalPositionOpen - globalSpreadSell
            globalPositionTrailingV = globalPositionTrailingV if globalPositionTrailingV > 0 else globalPositionTrailingN
                   
            if globalPrice < globalPositionTrailingN:
                globalPositionTrailingN = globalPrice
                
                if (globalPositionTrailingV - globalPositionTrailingN) >= globalTrailing: 
                    globalPositionStop = globalPositionTrailingN + globalTrailingStop
                    globalPositionTrailingV = globalPositionTrailingN
        
            if globalPositionStop > 0:
                if globalPrice >= globalPositionStop and globalGross > 0:
                    print("Closed at: " + str(globalGross))
                    closePosition(pos)
        else:
            globalPositionType = "Buy"
            globalPositionTrailingN = globalPositionTrailingN if globalPositionTrailingN > 0 else globalPositionOpen + globalSpreadSell
            globalPositionTrailingV = globalPositionTrailingV if globalPositionTrailingV > 0 else globalPositionTrailingN
            
            if globalPrice > globalPositionTrailingN:
                globalPositionTrailingN = globalPrice
                if (globalPositionTrailingN - globalPositionTrailingV) >= globalTrailing: 
                    globalPositionStop = globalPositionTrailingN - globalTrailingStop
                    globalPositionTrailingV = globalPositionTrailingN
                    print("New TrailingStop: "+ str(globalPositionStop))
                    
            if globalPositionStop > 0:
                if globalPrice <= globalPositionStop and globalGross > 0:
                    print("Closed at: " + str(globalGross))
                    closePosition(pos)  
        
        #printInfo(1)
        
    else:     
        globalMaxGross = 0
        globalGross = 0
        globalPositionOpen = 0
        globalPositionStop = 0
        globalPositionTrailingN = 0
        globalPositionTrailingV = 0
        
while True:
    tick = mt5.symbol_info_tick(globalSymbol)
    if tick is not None:

        if tick.bid != globalLastPrice:
            globalLastPrice = tick.bid
            getActivePosition(tick.bid)
            #print(priceConvert(tick.bid))
    #time.sleep(1)
