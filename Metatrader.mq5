#include<Trade\Trade.mqh>
CTrade trade;

string Status = "OFF";
int Count = 0;
double Position;
string Type = "wait";
double PositionStop;
bool PositionStopON;
int StopActive = 0;
int AvanceStartBuy = 9;
int AvanceStartSell = 9;
int AvanceMiddle = 1;
int AvanceTrailing = 1;
double GainLoss = 0;
bool Trade;

void PositionClose(ulong ticket)
  {     
      trade.PositionClose(ticket);
      Print("CloseTicket " + PositionGetDouble(POSITION_PROFIT));
      Status = "Position Closed";
      Type = "wait";
      PositionStop = 0.0;
      Position = 0.0;
      PositionStopON = false;
  }

void OnTick()
  {
  double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
  double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
  
   ObjectCreate(_Symbol,"Label1",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"Label1",OBJPROP_FONT,"Arial");
   ObjectGetInteger(0,"Label1",OBJPROP_FONTSIZE,60);
   ObjectSetString(_Symbol,"Label1",OBJPROP_TEXT,0,"Ask Price: "+ Ask);
   ObjectGetInteger(0,"Label1",OBJPROP_XDISTANCE,200);
   ObjectGetInteger(0,"Label1",OBJPROP_YDISTANCE,10);

  ulong ticket;
  if(Trade)
   { 
   
      Comment( "Positions: "+ PositionsTotal() + "\n" +
         Type +": " + Position + " - " + Status + " - " + GainLoss + "\n" + 
         "Stop: " + PositionStop +"\n" +
         "AvanceBuy: " + AvanceStartBuy + "\n" +
         "AvanceSell: " + AvanceStartSell + "\n" +
         "Trail: " + AvanceTrailing + "\n"
         );
         
      if(PositionStopON){
         if(Type == "BUY"){
            if(Ask > PositionStop){
               PositionStop = PositionStop + AvanceTrailing * _Point;
               GainLoss = PositionGetDouble(POSITION_PROFIT);
               Print("down :"+ PositionStop + " | " + GainLoss);           
            }
            if(Ask <= PositionStop){
               PositionClose(ticket);
               GainLoss = PositionGetDouble(POSITION_PROFIT);
            }
         }else{
            if(Bid < PositionStop){
               PositionStop = PositionStop - AvanceTrailing * _Point;
               GainLoss = PositionGetDouble(POSITION_PROFIT);
               Print("down :"+ PositionStop + " | " + GainLoss);          
            }
            if(Bid >= PositionStop){ 
               PositionClose(ticket);
               GainLoss = PositionGetDouble(POSITION_PROFIT);
            }
         }
      }      
   }

   for(int i=0; i<PositionsTotal();i++) 
   {
    if((ticket=PositionGetTicket(i))>0) 
     {
     if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY){
         Type = "BUY";
         Trade = true; 
         Position = PositionGetDouble(POSITION_PRICE_OPEN);
         GainLoss = PositionGetDouble(POSITION_PROFIT);
         if(!PositionStopON){
            if(Ask > (Position + AvanceStartBuy * _Point)){
               PositionStop = Position + AvanceStartBuy * _Point;
               PositionStopON = true; 
               Print("---- new trade "+Type+" ----");
               Print("position " + Position);
               Print("Positionstop " + PositionStop + " | " + PositionGetDouble(POSITION_PROFIT));
               Status = "ACTIVATED";
            }
         }       
      }
      else{
         Type = "SELL";
         Trade = true;
         Position=PositionGetDouble(POSITION_PRICE_OPEN);
         GainLoss = PositionGetDouble(POSITION_PROFIT);
         if(!PositionStopON){
            if(Bid < (Position - AvanceStartSell * _Point)){
               PositionStop = Position - AvanceStartSell * _Point;
               PositionStopON = true;
               Print("---- new trade "+Type+" ----");
               Print("position " + Position);
               Print("Positionstop "+ PositionStop + " | " + PositionGetDouble(POSITION_PROFIT));
               Status = "ACTIVATED";
            }
         }
      }      
     }
   }
}
