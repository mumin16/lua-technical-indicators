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
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   SetIndexStyle(0,DRAW_LINE);
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

  

    int handle=FileOpen("data.txt", FILE_TXT|FILE_WRITE);
  if(handle>0)
    {
    
     for(int i=rates_total-1; i>=0; i--) 
     {
      FileWrite(handle,open[i], ",",high[i],",",low[i], ",",close[i], ",",tick_volume[i]);
     } 
     
     FileClose(handle);
    }

     for(int i=rates_total-1; i>=0; i--) 
     {
      //out[i]=iMA(NULL,0,10,0,MODE_SMA,PRICE_CLOSE,i);
      //out[i]=iMA(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,i);
      //out[i]=iMA(NULL,0,10,0,MODE_LWMA,PRICE_CLOSE,i);
      //out[i]=iMA(NULL,0,10,0,MODE_SMMA,PRICE_CLOSE,i);
      //out[i]=iStdDev(NULL,0,10,0,MODE_SMA,PRICE_CLOSE,i);
      //out[i]=iBands(NULL,0,10,2,0,PRICE_CLOSE,MODE_UPPER,i);
      //out[i]=iBands(NULL,0,10,2,0,PRICE_CLOSE,MODE_LOWER,i);
      //out[i]=iBearsPower(NULL,0,10,PRICE_CLOSE,i);;
      //out[i]=iBullsPower(NULL,0,10,PRICE_CLOSE,i);
      //out[i]=iMomentum(NULL,0,10,PRICE_CLOSE,i);
      //out[i]=iDeMarker(NULL,0,10,i);
      //out[i]=iForce(NULL,0,10,MODE_SMA,PRICE_CLOSE,i);
      //out[i]=iOBV(NULL,0,PRICE_CLOSE,i);
      //out[i]=iATR(NULL,0,10,i);
      //out[i]=iRVI(NULL,0,10,MODE_MAIN,i);
      //out[i]=iAO(NULL,0,i);
      //out[i]=iAD(NULL,0,i); 
      //out[i]=iAC(NULL,0,i);;
      //int val_index=iHighest(NULL,0,MODE_CLOSE,10,i);
      //out[i]=close[val_index];
      //int val_index=iLowest(NULL,0,MODE_CLOSE,10,i);
      //out[i]=close[val_index];
      //out[i]=iMFI(NULL,0,10,i);
      //out[i]=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      //out[i]=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i);      
      
      out[i]=iRSI(NULL,0,10,PRICE_CLOSE,i);
      
     
      
      
      
     } 
  
    handle=FileOpen("out.txt", FILE_CSV|FILE_WRITE, ' ');
      if(handle>0)
    {
     for(int i=rates_total-1; i>=0; i--) 
     {
      FileWrite(handle, MathAbs(i-rates_total),out[i]);
     } 
     
     FileClose(handle);
    }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+