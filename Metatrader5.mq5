//+------------------------------------------------------------------+
//|                                                Administrator.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

//--- input parameters
input int globalTrailing=4;
input int globalTrailingStop=2;
input int globalStopLoss=15;
input int globalSpread=3;

bool     test = false;
bool     globalPositionInit = true;
long     globalPositionTrailing;
double   globalTickValue;
ulong    globalTicket;
string   globalSymbol;
string   globalPositionSymbol;
long     globalPositionType;
string   globalPositionTypeString;
long     globalPositionOpen;
long     globalPositionStop;
double   globalGross;
long     globalPrice;
double   globalVolume;
long     globalTicks;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   initializeGlobals();
   globalSymbol = Symbol();
   globalTickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   
   createText("Type", "wait", 200);
   createText("Stop", "wait", 180);
   createText("Open", "wait", 160);
   createText("Price", "wait", 140);
   createText("Trail", "wait", 120);
   createText("Profit", "wait", 100);
   createText("Volume", "wait", 80);
   createText("Ticks", "wait", 60);
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(test)
     {
      ulong ticket = trade.Buy(0.01, Symbol(), SymbolInfoDouble(Symbol(), SYMBOL_ASK));
      //ulong ticket = trade.Sell(0.01, Symbol(), SymbolInfoDouble(Symbol(), SYMBOL_BID));
      test = false;
     }
   int total = PositionsTotal();
   if(total > 0)
     {
      globalTicket = PositionGetTicket(0);
      globalGross = PositionGetDouble(POSITION_PROFIT);
      globalPositionSymbol = PositionGetString(POSITION_SYMBOL);
      globalPositionOpen = priceConvert(PositionGetDouble(POSITION_PRICE_OPEN));
      globalPositionType = PositionGetInteger(POSITION_TYPE);
      if(globalPositionType == POSITION_TYPE_SELL){ globalPositionTypeString = "SELL"; }else{ globalPositionTypeString = "BUY"; }
      globalVolume = PositionGetDouble(POSITION_VOLUME);
      
      groupSetText();
      
      if(globalPositionType == POSITION_TYPE_SELL)
        {
         globalTicks = globalPositionOpen - globalPrice;
         globalPrice = priceConvert(SymbolInfoDouble(globalPositionSymbol, SYMBOL_ASK));
         if(globalPositionInit)
           {
            globalPositionStop = globalPositionOpen + globalStopLoss;
            globalPositionTrailing = globalPositionOpen - globalTrailing - globalSpread;
            globalPositionInit = false;
           }

         if(globalPrice <= globalPositionTrailing && globalGross > 0)
           {
            globalPositionTrailing = globalPrice - globalTrailing;
            globalPositionStop = globalPrice + globalTrailingStop;
           }

         if(globalPrice >= globalPositionStop)
           {
            bool result = trade.PositionClose(globalTicket);
            if(result)
              {
               initializeGlobals();
              }
            else
              {
               int error = GetLastError();
               Print("Error al cerrar la posición de venta. Código de error:", error);
              }
           }
        }
      else
         if(globalPositionType == POSITION_TYPE_BUY)
           {
            globalTicks = globalPrice - globalPositionOpen;
            globalPrice = priceConvert(SymbolInfoDouble(globalPositionSymbol, SYMBOL_BID));
            
            if(globalPositionInit)
              {
               globalPositionStop = globalPositionOpen - globalStopLoss;
               globalPositionTrailing = globalPositionOpen + globalTrailing + globalSpread;
               globalPositionInit = false;
              }

            if(globalPrice >= globalPositionTrailing && globalGross > 0)
              {
               globalPositionTrailing = globalPrice + globalTrailing;
               globalPositionStop = globalPrice - globalTrailingStop;
              }

            if(globalPrice <= globalPositionStop)
              {
               bool result = trade.PositionClose(globalTicket);
               if(result)
                 {
                  initializeGlobals();
                 }
               else
                 {
                  int error = GetLastError();
                  Print("Error al cerrar la posición de compra. Código de error:", error);
                 }
              }
           }
      Print("Ticket: ", globalTicket, " Apertura: ", globalPositionOpen, " Profit: ", globalGross, " Precio: ", globalPrice, " Trail: ", globalPositionTrailing, " Stop: ", globalPositionStop);
     }
   else
     {
      if(!globalPositionInit){initializeGlobals();}
     }
  }

//+------------------------------------------------------------------+
//| PRICE CONVERT                                                    |
//+------------------------------------------------------------------+
long priceConvert(double price)
  {
   string price_str = DoubleToString(price, 5);
   string parts[];
   int count = StringSplit(price_str, '.', parts);
   if(StringLen(parts[1])==4)
     {
      parts[1] = parts[1] + "0";
     }
   long price_int = StringToInteger(parts[0] + parts[1]);
   return price_int;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| RESET INIT                                                       |
//+------------------------------------------------------------------+
void initializeGlobals()
  {
   globalPositionInit = true;
   globalPositionTrailing = 0;
   globalTickValue = 0;
   globalTicket = 0;
   globalSymbol = "";
   globalPositionSymbol = "";
   globalPositionType = 0;
   globalPositionTypeString = "wait";
   globalPositionOpen = 0;
   globalPositionStop = 0;
   globalGross = 0;
   globalPrice = 0;
   globalVolume = 0;
   globalTicks = 0;
   groupSetText();
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| UPDATE STOPLOSS                                                  |
//+------------------------------------------------------------------+
void setStopLoss()
  {
   double priceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double newStopLoss = priceOpen - globalStopLoss * tickSize;
   trade.OrderModify(globalTicket, 0, priceOpen, newStopLoss, 0, CLR_NONE);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Create Text                                                       |
//+------------------------------------------------------------------+
void createText(string name, string value, int y)
  {
   string name1 = name+"_name";
   string name2 = name+"_value"; 
   int textLabel1 = ObjectCreate(0, name1, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name1, OBJPROP_XDISTANCE, 120);
   ObjectSetInteger(0, name1, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name1, OBJPROP_CORNER, CORNER_RIGHT_LOWER);
   ObjectSetInteger(0, name1, OBJPROP_XSIZE, 120);
   ObjectSetInteger(0, name1, OBJPROP_YSIZE, 20);
   ObjectSetInteger(0, name1, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name1, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetString(0, name1, OBJPROP_TEXT, name+": ");
   
   int textLabel2 = ObjectCreate(0, name2, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name2, OBJPROP_XDISTANCE, 50);
   ObjectSetInteger(0, name2, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name2, OBJPROP_CORNER, CORNER_RIGHT_LOWER);
   ObjectSetInteger(0, name2, OBJPROP_XSIZE, 120);
   ObjectSetInteger(0, name2, OBJPROP_YSIZE, 20);
   ObjectSetInteger(0, name2, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name2, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetString(0, name2, OBJPROP_TEXT, value);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Set Text                                                       |
//+------------------------------------------------------------------+
void setText(string name, string value)
  {
   string name1 = name+"_name";
   string name2 = name+"_value"; 
   ObjectSetString(0, name1, OBJPROP_TEXT, name+":");
   ObjectSetString(0, name2, OBJPROP_TEXT, value);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Group Set Text                                                       |
//+------------------------------------------------------------------+
void groupSetText()
  {
   setText("Type", globalPositionTypeString);
   setText("Stop", IntegerToString(globalPositionStop));
   setText("Open", IntegerToString(globalPositionOpen));
   setText("Price", IntegerToString(globalPrice));
   setText("Trail", IntegerToString(globalPositionTrailing));
   setText("Profit", StringFormat("%.2f", globalGross));
   setText("Volume", StringFormat("%.2f", globalVolume));
   setText("Ticks", IntegerToString(globalTicks));
  }
//+------------------------------------------------------------------+
