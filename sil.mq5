//+------------------------------------------------------------------+
//|                                                          sil.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
//--- buffers
double out[];
 int  indHandle;
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   //SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,out);
   

    
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
 

    int handle=FileOpen("data.txt", FILE_ANSI|FILE_TXT|FILE_WRITE);
  if(handle>0)
    {
    
     for(int i=rates_total-100; i<=rates_total-1; i++) 
     {
      FileWrite(handle,open[i], ",",high[i],",",low[i], ",",close[i], ",",tick_volume[i]);
     } 
     
     FileClose(handle);
    }

  
  
  
    // indHandle= iTriX(NULL, 0,  10,  PRICE_CLOSE );
  // indHandle= iDEMA( NULL, 0,  10, 0, PRICE_CLOSE  );
   //indHandle= iTEMA( NULL, 0,  10, 0, PRICE_CLOSE  );
  //indHandle= iChaikin( NULL, 0,    3,   10,   MODE_EMA,  VOLUME_TICK   );
  
  
  
  //--- check if all data calculated 
   if(BarsCalculated(indHandle)<rates_total) return(0); 
//--- we can copy not all data 
   int to_copy; 
   if(prev_calculated>rates_total || prev_calculated<=0) to_copy=rates_total; 
   else 
     { 
      to_copy=rates_total-prev_calculated; 
      //--- last value is always copied 
      to_copy++; 
     } 
//--- try to copy 
   if(CopyBuffer(indHandle,0,0,to_copy,out)<=0) return(0); 
   
 
    handle=FileOpen("out.txt", FILE_ANSI|FILE_TXT|FILE_WRITE);
      if(handle>0)
    {
     for(int i=to_copy-100; i<=to_copy-1; i++) 
     {
      FileWrite(handle,100+i-to_copy+1,"  ",out[i]);
     } 
    
     FileClose(handle);
    }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+