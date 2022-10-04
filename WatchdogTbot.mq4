//+------------------------------------------------------------------+
//|                                                 WatchdogTbot.mq4 |
//|                                                        Fabio Sol |
//|                                      https://github.com/FabioSol |
//+------------------------------------------------------------------+
#property copyright "Fabio Sol"
#property link      "https://github.com/FabioSol"
#property version   "1.00"
#property strict

//--- input parameters
input int      minutes_alert;
input string      chat_id;
input int      magic;
input int      minutes_between_alerts;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   string message="WatchdogTbot is ON";
   Telegram(message);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   string message="WatchdogTbot is OFF";
   Telegram(message);

   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
//---
   double orderpl=0.0;

// looks for last order in history (closed operations)
   int  i=OrdersHistoryTotal()-1;
   bool found = FALSE;
   datetime last_act=OrderCloseTime();
   while(i>=0){
      if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
         {
         if(OrderMagicNumber()==magic)
            {
            found=TRUE;
            if(last_act<OrderCloseTime())
            {
               last_act=OrderCloseTime();
               orderpl=OrderProfit();
            }
            }
         }
      i--;
      
  
   }
// looks for last in active trades
   i=OrdersTotal()-1;
   int opencounter=0;
   double floating=0;
   bool open=False;
   while(i>=0){
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
         if(OrderMagicNumber()==magic)
            {
            found=TRUE;
            opencounter++;
            if(last_act<OrderOpenTime())
            {
               last_act=OrderOpenTime();
               open=True;
               orderpl=OrderProfit();
               
            }
            else{
               floating=floating+OrderProfit();
            }
            }
         }
      i--;
      
   
   }
   if(!found){
    Alert("not found: magic might be wrong or no trades made have been made");
   }
   
   float minutes = (TimeCurrent()-last_act)/60;
   
   //sending alerts
   
   if(minutes_alert<minutes)
      {
      
      if(open){
      
      string message="Bot: "+IntegerToString(magic)+" has been "+DoubleToStr(minutes,2)+" minutes inactive "+"("+DoubleToStr(minutes-minutes_alert,2)+" minutes over the limit). Last: [Open order: "+DoubleToStr(orderpl)+"]";
      if(opencounter>0)
      {
      message="Bot: "+IntegerToString(magic)+" has been "+DoubleToStr(minutes,2)+" minutes inactive "+"("+DoubleToStr(minutes-minutes_alert,2)+" minutes over the limit). Last: [Open order: "+DoubleToStr(orderpl)+"]. Still "+IntegerToString(opencounter)+" open orders. float:["+DoubleToStr(floating+orderpl)+"]";
      
      }
      
      Telegram(message);
      }
      else{
      
      string message="Bot: "+IntegerToString(magic)+" has been "+DoubleToStr(minutes,2)+" minutes inactive "+"("+DoubleToStr(minutes-minutes_alert,2)+" minutes over the limit). Last: [Closed order: "+DoubleToStr(orderpl)+"]";
      
      if(opencounter>0)
      {
      message="Bot: "+IntegerToString(magic)+" has been "+DoubleToStr(minutes,2)+" minutes inactive "+"("+DoubleToStr(minutes-minutes_alert,2)+" minutes over the limit). Last: [Closed order: "+DoubleToStr(orderpl)+"]. Still "+IntegerToString(opencounter)+" open orders. float:["+DoubleToStr(floating)+"]";
      
      }
      Telegram(message);
      }
      
      
      Sleep(minutes_between_alerts*1000*60);
      
      }

   
  }
//+------------------------------------------------------------------+


void Telegram(string message)
  {

   string token="5452471120:AAFtd0s10xf4pnte4rfE_UaQszQOblhM-WE";
   string base_url="https://api.telegram.org";
   string cookie=NULL,headers;
   char post[],result[];
   int res;
   string url=base_url+"/bot"+token+"/sendMessage?chat_id="+chat_id+"&text="+message;  
   ResetLastError();
   int timeout=4000; 
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
   
 
  }