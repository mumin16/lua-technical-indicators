--global pricedata
OPEN = { };	HIGH = { };	LOW =  { };  CLOSE = { };	VOLUME = { };	MEDIAN = { };	TYPICAL = { };	WEIGHTED = { };
--APPLIED_PRICE
PRICE_CLOSE=0 PRICE_OPEN=1 PRICE_HIGH=2 PRICE_LOW=3 PRICE_MEDIAN=4 PRICE_TYPICAL=5 PRICE_WEIGHTED=6
--MA_METHOD 
MODE_SMA=0 MODE_EMA=1 MODE_SMMA=2 MODE_LWMA=3
--test
BUY = { };	SELL = { };

function MEDIANPRICE()
local out={}
  for  i=1,#CLOSE,1 do
      out[i]=(HIGH[i]+LOW[i])/2
  end
return out
end

function TYPICALPRICE()
local out={}
  for  i=1,#CLOSE,1 do
      out[i]=(HIGH[i]+LOW[i]+CLOSE[i])/3
  end
return out
end

function WEIGHTEDCLOSE()
local out={}
  for  i=1,#CLOSE,1 do
      out[i]=(HIGH[i]+LOW[i]+CLOSE[i]+CLOSE[i])/4
  end
return out
end

function HIGHEST(source,period)  
local out={}
    for  i=1,#source,1 do
      local h=0
      for j=0,period-1,1 do
          if i-j<=0 or h>source[i-j] then h=h else  h=source[i-j] end
      end
      out[i]=h
    end
return out;
end

function LOWEST(source,period)
local out={}
    for  i=1,#source,1 do
      local l=source[i]
      for j=0,period-1,1 do
          if i-j<=0 or l<source[i-j] then l=l else  l=source[i-j] end
      end
      out[i]=l
    end
return out;
end

function SUM(source,period)
  local out={}
  for  i=1,#source-period+1,1 do
      local sum=0
      for j=0,period-1,1 do
         if j+i>#source then break else sum = sum+source[j+i] end
      end
      out[i]=sum
  end
return out
end  

--Simple Moving Avarage
function SMA(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end  
local sum=SUM(source,period)
local out={} 
  for j=1,#sum,1 do out[j] = sum[j]/period end
return out
end

--Linear Weighted Moving Avarage
function LWMA(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end  
local out={}
  for  i=1,#source-period+1,1 do
      local sum=0
      local div=0
      for j=0,period-1,1 do
           sum = sum+(source[i+j]*(j+1))
           div=div+j+1
      end
      out[i]=sum/div
  end
return out
end

--Exponential Moving Avarage
function EMA(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end  
local multiplier=(2 / (period + 1) ) 
local out={}
  for  i=1,#source,1 do
      if i-1==0 then out[i]=source[i] else out[i]=(source[i]-out[i-1]) * multiplier + out[i-1] end
  end
return out
end

--Smoothed Moving Average
function SMMA(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end  
local out={}
local sma1=0
  for j=1,period,1 do
     sma1= sma1+source[j];
  end
  for  i=1,#source-period+1,1 do
      if i==1 then out[i]=sma1/period else out[i]=(out[i-1] * (period-1) +source[i+period-1])/period end
  end
return out
end

--Standart Deviation
function STDDEV(source,period,matype)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end   
local sma={}
if matype==0 then sma=SMA(source, period) 
elseif matype==1 then sma= EMA(source, period)
elseif matype==2 then sma= SMMA(source, period)
elseif matype==3 then sma= LWMA(source, period) end
local out={}
  for  i=1,#sma,1 do
      local sum=0
      for j=0,period-1,1 do
        sum = sum+ (source[i-j+period-1]-sma[i])^2 
      end
      out[i]=math.sqrt(sum/period)--*deviation
  end
return out 
end

--Bollinger Bands
function BANDSUPPER(source,period,deviation)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local sma=SMA(source,period)
local out={}
  for  i=1,#sma,1 do
      local sum=0
      for j=0,period-1,1 do
        sum = sum+ (source[i-j+period-1]-sma[i])^2 
      end
      out[i]=sma[i]+math.sqrt(sum/period)*deviation
  end
return out
end
function BANDSLOWER(source,period,deviation)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local sma=SMA(source,period)
local out={}
  for  i=1,#sma,1 do
      local sum=0
      for j=0,period-1,1 do
        sum = sum+ (source[i-j+period-1]-sma[i])^2 
      end
      out[i]=sma[i]-math.sqrt(sum/period)*deviation
  end
return out
end

function BEARSPOWER(period)
local out={}
    for  i=1,#CLOSE,1 do
      out[i]=LOW[i]-EMA(CLOSE,period)[i]
    end
return out
end

function BULLSPOWER(period)
local out={}
    for  i=1,#CLOSE,1 do
      out[i]=HIGH[i]-EMA(CLOSE,period)[i]
    end
return out
end

function MOMENTUM(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end  
local out={}
  for  i=1,#source,1 do
    if i+period>#source then break else out[i] = (source[i+period]*100/ source[i] ) end
  end
return out
end

function DEMARKER(period)
local DeMin={}
local DeMax={}
  for  i=1,#HIGH,1 do
    if i==1 or  HIGH[i] <= HIGH[i-1] then DeMax[i] = 0 else DeMax[i] = HIGH[i] - HIGH[i-1] end
    if i==1 or  LOW[i] >= LOW[i-1] then DeMin[i] = 0 else DeMin[i] =   LOW[i-1]-LOW[i] end
  end
local out={}
  for  i=1,#HIGH-period+1,1 do
    out[i]=SMA(DeMax, period)[i]/(SMA(DeMax, period)[i]+SMA(DeMin, period)[i])
  end
return out
end

function FORCE(source,period,matype)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end   
local sma={}
if matype==0 then sma=SMA(source, period) 
elseif matype==1 then sma= EMA(source, period)
elseif matype==2 then sma= SMMA(source, period)
elseif matype==3 then sma= LWMA(source, period) end
local out={}
   for  i=1,#source-period+1,1 do
     if i==1 then out[i]= VOLUME[i+period-1]*sma[i] 
     else out[i-1]=VOLUME[i+period-1]*(sma[i]- sma[i-1]) end
  end
return out
end

--On Balance Volume
function OBV(source)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local out={}
  for  i=1,#source,1 do
      if i==1 then out[i]=VOLUME[i] 
      elseif source[i]>source[i-1] then out[i]=out[i-1]+VOLUME[i] 
      elseif source[i]<source[i-1] then out[i]=out[i-1]-VOLUME[i] 
      elseif source[i]==source[i-1] then out[i]=out[i-1] 
      end
  end
return out
end

--Average True Range
function ATR(period)
local tr={}
  for  i=1,#CLOSE,1 do
    if i==1 then tr[i]=HIGH[i]-LOW[i] 
    else tr[i]=math.max((HIGH[i]-LOW[i]),math.abs((CLOSE[i-1]-HIGH[i])),math.abs((CLOSE[i-1]-LOW[i]))) end
  end
local out=SMA(tr,period)
return out
end

--Commodity Channel Index 
function CCI(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
  
local sma=SMA(source,period)

local mean={}
for  i=1,#sma,1 do  
  local sum=0
  for  j=period-1,0,-1 do
    if i>#sma then break else  sum=sum+math.abs(source[i+j]-sma[i]) end
  end
   mean[i]=sum/period
end

local out={}
  for k=1,#sma,1 do  
   out[k]=(source[k+period-1]-sma[k])/(0.015*mean[k])
  end

return out
end

--Money Flow Index
function MFI(period)
local pmf={}
local nmf={}
  for  i=1,#TYPICAL,1 do
    if i==1 then nmf[i]=0 pmf[i]=TYPICAL[i]*VOLUME[i]
    else
      if TYPICAL[i]>TYPICAL[i-1] then pmf[i]=TYPICAL[i]*VOLUME[i] nmf[i]=0  end
      if TYPICAL[i]<TYPICAL[i-1] then nmf[i]=TYPICAL[i]*VOLUME[i] pmf[i]=0  end
      if TYPICAL[i]==TYPICAL[i-1] then nmf[i]=0 pmf[i]=0  end
    end
  end
local spmf=SUM(pmf,period)
local snmf=SUM(nmf,period)
local out={}
  for  k=1,#spmf,1 do
    out[k]=100-(100/(1+(spmf[k]/snmf[k])))
  end
return out
end

--Relative Strength Index
function RSI(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local g={}
local l={}
  for  i=2,#source,1 do
      if source[i]>source[i-1] then g[i-1]=source[i]-source[i-1] l[i-1]=0  end
      if source[i]<source[i-1] then l[i-1]=source[i-1]-source[i] g[i-1]=0  end
      if source[i]==source[i-1] then l[i-1]=0 g[i-1]=0  end
  end
local ag={0}
local al={0}  
local out={}
  for  j=1,period,1 do
      ag[1]=ag[1]+g[j]
      al[1]=al[1]+l[j]
  end
ag[1]=ag[1]/period
al[1]=al[1]/period
   
  for  k=2,#g-period+1,1 do
    ag[k]=(ag[k-1]*(period-1)+g[k+period-1])/period
    al[k]=(al[k-1]*(period-1)+l[k+period-1])/period
  end
  
  for  m=1,#ag,1 do
    out[m]=100-(100/(1+(ag[m]/al[m])))
  end
return out
end

--Relative Vigor Index
function RVI(period)
local MovAverage={}
local RangeAverage={}
  for  i=4,#CLOSE,1 do
    MovAverage[i-3]=((CLOSE[i]-OPEN[i])+2*(CLOSE[i-1]-OPEN[i-1])+2*(CLOSE[i-2]-OPEN[i-2])+(CLOSE[i-3]-OPEN[i-3]))/6
    RangeAverage[i-3]=((HIGH[i]-LOW[i])+2*(HIGH[i-1]-LOW[i-1])+2*(HIGH[i-2]-LOW[i-2])+(HIGH[i-3]-LOW[i-3]))/6   
  end
local NUM = SUM(MovAverage, period)
local DENUM = SUM(RangeAverage,period)
local out={}
  for  j=1,#CLOSE-period+1-3,1 do
    out[j]= NUM[j] / DENUM[j]  
  end
return out
end

--Awesome Oscillator
function AO()
local sma5=SMA(MEDIAN,5)
local sma34=SMA(MEDIAN,34)
local out={}
  for  i=1,#sma34,1 do
    out[i]=sma5[i+#sma5-#sma34]-sma34[i]
  end
return out
end

--Accelerator/Decelerator Oscillator
function AC()
local ao=AO()
local ao5=SMA(ao,5)
local out={}
  for  i=1,#ao5,1 do
    out[i]=ao[i+#ao-#ao5]-ao5[i]
  end
return out
end

--Accumulation/Distribution
function AD()
local out={}  
    for  i=1,#CLOSE,1 do
      if i-1==0 then out[i]=(((CLOSE[i] - LOW[i]) - (HIGH[i] - CLOSE[i])) / (HIGH[i] - LOW[i])) * VOLUME[i] 
      else out[i]=(((CLOSE[i] - LOW[i]) - (HIGH[i] - CLOSE[i])) / (HIGH[i] - LOW[i])) * VOLUME[i] + out[i-1] end
    
      if out[i]~=out[i] then out[i]=out[i-1] end
    end
return out  
end

function MACD(source,fast,slow)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local fastema=EMA(source,fast)
local slowema=EMA(source,slow)
local out={}
  for  i=1,#slowema,1 do
    out[i] = fastema[i]-slowema[i];
  end
return out
end

function MACDSIGNAL(source,fast,slow,signal)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end   
  return SMA(MACD(source,fast,slow),signal)
end

--Envelopes
function ENVELOPESUPPER(source,period,deviation,matype)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end  
local sma={}
if matype==0 then sma=SMA(source, period) 
elseif matype==1 then sma= EMA(source, period)
elseif matype==2 then sma= SMMA(source, period)
elseif matype==3 then sma= LWMA(source, period) end

local out={}
  for  i=1,#sma,1 do
    out[i]=(1+deviation/100.0)*sma[i];
  end
return out
end

function ENVELOPESLOWER(source,period,deviation,matype)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local sma={}
if matype==0 then sma=SMA(source, period) 
elseif matype==1 then sma= EMA(source, period)
elseif matype==2 then sma= SMMA(source, period)
elseif matype==3 then sma= LWMA(source, period) end
local out={}
  for  i=1,#sma,1 do
    out[i]=(1-deviation/100.0)*sma[i];
  end
return out
end

--Williams' Percent Range
function WPR(period)
local hh=HIGHEST(HIGH,period)
local ll=LOWEST(LOW,period)
local out={}
  for  i=1,#hh-period+1,1 do
    out[i]=(hh[i+period-1]-CLOSE[i+period-1])/(hh[i+period-1]-ll[i+period-1]) * -100
  end
return out
end

--Moving Average of Oscillator indicator 
function OSMA(source,fast_ema_period,slow_ema_period,signal_period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local macd=MACD(source,fast_ema_period,slow_ema_period)
local signal=MACDSIGNAL(source,fast_ema_period,slow_ema_period,signal_period)
local out={}   
  for  j=1,#macd-#signal,1 do
    out[j]=macd[j]
  end
  for  i=1,#signal,1 do
    out[i+#macd-#signal]=macd[i+signal_period-1]-signal[i] 
  end
return out
end

--Stochastic
function STOCHASTIC(Kperiod,slowing)
  local ExtMainBuffer={}
  local ExtLowesBuffer=LOWEST(LOW,Kperiod)
  local ExtHighesBuffer=HIGHEST(HIGH,Kperiod)
  local start=Kperiod+slowing;
--- main cycle
  for i=start+1, #CLOSE ,1 do
    
      local sumlow=0.0;
      local sumhigh=0.0;
      
      for k=(i-slowing+1),i,1 do
        
         sumlow =sumlow+(CLOSE[k]-ExtLowesBuffer[k]);
         sumhigh=sumhigh+(ExtHighesBuffer[k]-ExtLowesBuffer[k]);
        
      end 
      
      if sumhigh==0.0 then ExtMainBuffer[i-start]=100.0 else  ExtMainBuffer[i-start]=sumlow/sumhigh*100 end
  end
return ExtMainBuffer  
end

function STOCHASTICSIGNAL(Kperiod,Dperiod,slowing,matype)
local sma={}
if matype==0 then sma=SMA(STOCHASTIC(Kperiod,Dperiod,slowing),Dperiod)
elseif matype==1 then sma= EMA(STOCHASTIC(Kperiod,Dperiod,slowing),Dperiod)
elseif matype==2 then sma= SMMA(STOCHASTIC(Kperiod,Dperiod,slowing),Dperiod)
elseif matype==3 then sma= LWMA(STOCHASTIC(Kperiod,Dperiod,slowing),Dperiod) end  
return sma
end


--Triple Exponential Average
function TRIX(source,period)
local ema=EMA(source,period)
for _=1,period-1,1 do table.remove(ema,1) end
local ema2=EMA(ema,period)
for _=1,period-1,1 do table.remove(ema2,1) end
local ema3=EMA(ema2,period)
     
local out={}
  for  i=period,#ema3,1 do
    out[i-period+1]=(ema3[i] - ema3[i-1])/ ema3[i-1] 
  end
return out
end

--Double Exponential Moving Average
function DEMA(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local ema=EMA(source,period)
for _=1,period-1,1 do table.remove(ema,1) end
local emaofema=EMA(ema,period)
local out={}
  for  i=period,#emaofema,1 do
    out[i-period+1]=2*ema[i]-emaofema[i]
  end
return out
end

--Triple Exponential Moving Average
function TEMA(source,period)
local ema=EMA(source,period)
for _=1,period-1,1 do table.remove(ema,1) end
local emaofema=EMA(ema,period)
for _=1,period-1,1 do table.remove(emaofema,1) end
local emaofemaofema=EMA(emaofema,period)

local out={}
  for  i=period,#emaofemaofema,1 do
    out[i-period+1]=3*ema[i+period-1]-3*emaofema[i]+emaofemaofema[i];
  end
return out
end

--Detrended Price Oscillator
function DPO(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local   ExtMAPeriod=period/2+1;
local sma=SMA(source,ExtMAPeriod)
local out={} 
  for j=1,#sma,1 do out[j] = source[j+ExtMAPeriod-1]-sma[j] end
return out
end

--Chaikin Oscillator
function CHAIKIN(fast,slow,matype)
local ad=AD()
--MODE_SMA=0 MODE_EMA=1 MODE_SMMA=2 MODE_LWMA=3
local fastad={}
local slowad={}
if matype==0 then fastad= SMA(ad,fast) slowad= SMA(ad,slow) 
elseif matype==1 then fastad= EMA(ad,fast) slowad= EMA(ad,slow)
elseif matype==2 then fastad= SMMA(ad,fast) slowad= SMMA(ad,slow)
elseif matype==3 then fastad= LWMA(ad,fast) slowad= LWMA(ad,slow) end
local out={}
local diff=#fastad-#slowad
  for  i=diff+1,#slowad,1 do
    out[i-diff]=fastad[i+diff]-slowad[i]
  end 
return out
end

--Rate Of Change 
function ROC(source,period)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end
local out={}
  for  i=period+1 , #source,1 do
    out[i-period] = (source[i]-source[i-period])/source[i] * 100;
  end
return out
end

--Price and Volume Trend
function PVT()
local out={}
  for  i=1 , #CLOSE,1 do
    if i==1 then out[i] =0 else out[i] = ((CLOSE[i]-CLOSE[i-1])/CLOSE[i-1])*VOLUME[i]+out[i-1] end
  end
return out
end


--Accumulation Swing Index
function ASI(InpT)
 local ExtTpoints= InpT

      local pos=2;
      local ExtASIBuffer={}
      ExtASIBuffer[1]=0.0;
      local ExtSIBuffer={}
      ExtSIBuffer[1]=0.0;
      local ExtTRBuffer={}
      ExtTRBuffer[1]=HIGH[1]-LOW[1];
     
     
  for i=pos, #CLOSE,1 do
     
      --get some data
      local dPrevClose=CLOSE[i-1];
      local dPrevOpen=OPEN[i-1];
      local dClose=CLOSE[i];
      local dHigh=HIGH[i];
      local dLow=LOW[i];
      --- fill TR buffer
      ExtTRBuffer[i]=math.max(dHigh,dPrevClose)-math.min(dLow,dPrevClose);
      local ER=0.0;
      if(true~=(dPrevClose>=dLow and dPrevClose<=dHigh)) then
        
         if(dPrevClose>dHigh) then ER=math.abs(dHigh-dPrevClose); end
         if(dPrevClose<dLow)  then ER=math.abs(dLow-dPrevClose); end
      end  
      local K=math.max(math.abs(dHigh-dPrevClose),math.abs(dLow-dPrevClose));
      local SH=math.abs(dPrevClose-dPrevOpen);
      local R=ExtTRBuffer[i]-0.5*ER+0.25*SH;
      --- calculate SI value
      if R==0.0 or ExtTpoints==0.0 then ExtSIBuffer[i]=0.0;
      else     ExtSIBuffer[i]=50*(dClose-dPrevClose+0.5*(dClose-OPEN[i])+
                              0.25*(dPrevClose-dPrevOpen))*(K/ExtTpoints)/R;
      end
      --- write down ASI buffer value
      ExtASIBuffer[i]=ExtASIBuffer[i-1]+ExtSIBuffer[i];
  end
  return ExtASIBuffer
end

--MASS INDEX
function MI(ExtPeriodEMA,ExtSecondPeriodEMA,ExtSumPeriod)
local function ExponentialMA( position, period, prev_value, price)
   local result=0.0;
   if(period>0) then
      local pr=2.0/(period+1.0);
      result=price[position]*pr+prev_value*(1-pr);
    end
return(result);
end
local posMI=ExtSumPeriod+ExtPeriodEMA+ExtSecondPeriodEMA-3;
local ExtHLBuffer={}
ExtHLBuffer[1] = HIGH[1]-LOW[1]
local ExtEHLBuffer={}
ExtEHLBuffer[1] =0
local ExtEEHLBuffer={}
ExtEEHLBuffer[1] =0
local ExtMIBuffer={}
  for  i=2 , #CLOSE+1,1 do
    if i>#CLOSE then ExtHLBuffer[i] = 0 else ExtHLBuffer[i] = HIGH[i]-LOW[i] end
    ExtEHLBuffer[i]=ExponentialMA(i,ExtPeriodEMA,ExtEHLBuffer[i-1],ExtHLBuffer);
    ExtEEHLBuffer[i]=ExponentialMA(i,ExtSecondPeriodEMA,ExtEEHLBuffer[i-1],ExtEHLBuffer);
    local dTmp=0.0;
    if i-1>posMI then 
      for j=1,ExtSumPeriod,1 do--&& i>=posMI;j++)
              dTmp=dTmp+ExtEHLBuffer[i-j]/ExtEEHLBuffer[i-j];
      end        
      ExtMIBuffer[i-posMI-1]=dTmp;
    end
    
  end

return  ExtMIBuffer
end 


function PLUSDI(period)
  local    ExtPDBuffer={};
  --local    ExtNDBuffer={}; 
 

      local  start=2;
     
--- main cycle
  for i=start,#CLOSE,1 do
     
      --- get some data
      local Hi    =HIGH[i];
      local prevHi=HIGH[i-1];
      local Lo    =LOW[i];
      local prevLo=LOW[i-1];
      local prevCl=CLOSE[i-1];
      --- fill main positive and main negative buffers
      local dTmpP=Hi-prevHi;
      local dTmpN=prevLo-Lo;
      if(dTmpP<0.0)  then dTmpP=0.0; end
      if(dTmpN<0.0)  then dTmpN=0.0; end
      if(dTmpP>dTmpN) then dTmpN=0.0;
      else
        
         if(dTmpP<dTmpN) then dTmpP=0.0;
         else
           
            dTmpP=0.0;
            --dTmpN=0.0;
         end
      end
      --- define TR
      local tr=math.max(math.max(math.abs(Hi-Lo),math.abs(Hi-prevCl)),math.abs(Lo-prevCl));
      ---
      if(tr~=0.0) then
        
         ExtPDBuffer[i]=100.0*dTmpP/tr;
         --ExtNDBuffer[i]=100.0*dTmpN/tr;
        
      else
        
         ExtPDBuffer[i]=0.0;
         --ExtNDBuffer[i]=0.0;
      end
  end
 
 ExtPDBuffer[1]=0
 local out={}
 out=EMA(ExtPDBuffer,period);
--for i=1, period-1,1 do table.remove(out,1) end

return out
end


function MINUSDI(period)
  --local    ExtPDBuffer={};
  local    ExtNDBuffer={}; 


      local  start=2;
     
--- main cycle
  for i=start,#CLOSE,1 do
     
      --- get some data
      local Hi    =HIGH[i];
      local prevHi=HIGH[i-1];
      local Lo    =LOW[i];
      local prevLo=LOW[i-1];
      local prevCl=CLOSE[i-1];
      --- fill main positive and main negative buffers
      local dTmpP=Hi-prevHi;
      local dTmpN=prevLo-Lo;
      if(dTmpP<0.0)  then dTmpP=0.0; end
      if(dTmpN<0.0)  then dTmpN=0.0; end
      if(dTmpP>dTmpN) then dTmpN=0.0;
      else
        
         if(dTmpP<dTmpN) then dTmpP=0.0;
         else
           
            --dTmpP=0.0;
            dTmpN=0.0;
         end
      end
      --- define TR
      local tr=math.max(math.max(math.abs(Hi-Lo),math.abs(Hi-prevCl)),math.abs(Lo-prevCl));
      ---
      if(tr~=0.0) then
        
         --ExtPDBuffer[i]=100.0*dTmpP/tr;
         ExtNDBuffer[i]=100.0*dTmpN/tr;
        
      else
        
         --ExtPDBuffer[i]=0.0;
         ExtNDBuffer[i]=0.0;
      end
  end
 
 ExtNDBuffer[1]=0
 local out={}
 out=EMA(ExtNDBuffer,period);
--for i=1, period-1,1 do table.remove(out,1) end

return out
end


--Average Directional Index
function ADX(ExtADXPeriod)
  local ExtTmpBuffer={}
      local ExtPDIBuffer=PLUSDI(ExtADXPeriod)
      local ExtNDIBuffer=MINUSDI(ExtADXPeriod)
      
  for i=1,#CLOSE,1 do
      --- fill ADXTmp buffer
      local dTmp=ExtPDIBuffer[i]+ExtNDIBuffer[i];
      if(dTmp~=0.0) then
         dTmp=100.0*math.abs((ExtPDIBuffer[i]-ExtNDIBuffer[i])/dTmp);
      else
         dTmp=0.0;
      end
      ExtTmpBuffer[i]=dTmp;
  end
     
     
           --- fill smoothed ADX buffer
    local  ExtADXBuffer=EMA(ExtTmpBuffer,ExtADXPeriod);
      
return ExtADXBuffer
end

--Chaikin Volatility
function CHV(ExtCHVPeriod,ExtSmoothPeriod,matype)
local ExtSHLBuffer={}

--- fill H-L(i) buffer 
    local ExtHLBuffer={}
    for i=1 ,#CLOSE,1 do ExtHLBuffer[i]=HIGH[i]-LOW[i] end
--- calculate smoothed H-L(i) buffer
    if matype==0 then ExtSHLBuffer= SMA(ExtHLBuffer,ExtSmoothPeriod)
    elseif matype==1 then ExtSHLBuffer= EMA(ExtHLBuffer,ExtSmoothPeriod) end
--- calculate CHV buffer
    local ExtCHVBuffer={}
    if ExtCHVPeriod>=ExtSmoothPeriod then limit=ExtCHVPeriod else limit=ExtSmoothPeriod end
    for i=1+limit ,#CLOSE-limit+1,1 do     
        ExtCHVBuffer[i]=100.0*(ExtSHLBuffer[i]-ExtSHLBuffer[i-ExtCHVPeriod])/ExtSHLBuffer[i-ExtCHVPeriod];  
    end 
return ExtCHVBuffer
end


  
--Adaptive Moving Average
function AMA(price,amaperiod,ExtFastPeriodEMA,ExtSlowPeriodEMA)
if type(price)==type(1) then 
  if price==0 then price=CLOSE elseif price==1 then price=OPEN elseif price==2 then price=HIGH 
  elseif price==3 then price=LOW elseif price==4 then price=MEDIAN elseif price==5 then price=TYPICAL
  elseif price==6 then price=WEIGHTED end
end    
local function CalculateER(nPosition,PriceData,ExtPeriodAMA)
   local dSignal=math.abs(PriceData[nPosition]-PriceData[nPosition-ExtPeriodAMA]);
   local dNoise=0.0;
   for delta=0,ExtPeriodAMA-1,1 do
      dNoise=dNoise+math.abs(PriceData[nPosition-delta]-PriceData[nPosition-delta-1]); end
   if(dNoise~=0.0) then return(dSignal/dNoise); end
   return(0.0);
end

--- calculate ExtFastSC & ExtSlowSC
local ExtFastSC=2.0/(ExtFastPeriodEMA+1.0);
local ExtSlowSC=2.0/(ExtSlowPeriodEMA+1.0);

--- main cycle
  local ExtAMABuffer={} 
  for i=1+amaperiod,#CLOSE,1 do
      --- calculate SSC
      local dCurrentSSC=(CalculateER(i,price,amaperiod)*(ExtFastSC-ExtSlowSC))+ExtSlowSC;
      --- calculate AMA
      local dPrevAMA=0
      if i~=1+amaperiod then dPrevAMA=ExtAMABuffer[i-amaperiod-1] else dPrevAMA=price[i-1] end
      ExtAMABuffer[i-amaperiod]=math.pow(dCurrentSSC,2)*(price[i]-dPrevAMA)+dPrevAMA;
  end
return ExtAMABuffer
end


--Fractal Adaptive Moving Average
function FAMA(price,InpPeriodFrAMA)
if type(price)==type(1) then 
  if price==0 then price=CLOSE elseif price==1 then price=OPEN elseif price==2 then price=HIGH 
  elseif price==3 then price=LOW elseif price==4 then price=MEDIAN elseif price==5 then price=TYPICAL
  elseif price==6 then price=WEIGHTED end
end    
local function iHighest( StartPos,  Depth)   
   local res=HIGH[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(HIGH[i]>res) then
         res=HIGH[i]; end
    end
return(res);
end
local function iLowest( StartPos,  Depth)
   local res=LOW[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(LOW[i]<res) then
         res=LOW[i]; end
    end
return(res);
end  
  
--- main cycle  
local limit=2*InpPeriodFrAMA
local FrAmaBuffer={}
FrAmaBuffer[1]=price[limit-1];

  for i=limit,#price,1 do
     
      local Hi1=iHighest(i,InpPeriodFrAMA);
      local Lo1=iLowest(i,InpPeriodFrAMA);
      local Hi2=iHighest(i-InpPeriodFrAMA,InpPeriodFrAMA);
      local Lo2=iLowest(i-InpPeriodFrAMA,InpPeriodFrAMA);
      local Hi3=iHighest(i,2*InpPeriodFrAMA);
      local Lo3=iLowest(i,2*InpPeriodFrAMA);
      local N1=(Hi1-Lo1)/InpPeriodFrAMA;
      local N2=(Hi2-Lo2)/InpPeriodFrAMA;
      local N3=(Hi3-Lo3)/(2*InpPeriodFrAMA);
      local D=(math.log(N1+N2)-math.log(N3))/math.log(2.0);
      local ALFA=math.exp(-4.6*(D-1.0));
      FrAmaBuffer[i-limit+2]=ALFA*price[i]+(1-ALFA)*FrAmaBuffer[i-1-limit+2];
  end  
return FrAmaBuffer
end

--Price Channel
function PCUP(period)
local function iHighest( StartPos,  Depth)   
   local res=HIGH[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(HIGH[i]>res) then
         res=HIGH[i]; end
    end
return(res);
end
local out={}
  for i=period+1 ,#HIGH,1 do
  out[i-period]=iHighest(i,period);
  end
return out
end

function PCDOWN(period)
local function iLowest( StartPos,  Depth)
   local res=LOW[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(LOW[i]<res) then
         res=LOW[i]; end
    end
return(res);
end 
local out={}
  for i=period+1 ,#LOW,1 do
  out[i-period]=iLowest(i,period);
  end
return out
end
function PCMID(period)
local up=PCUP(period)
local down=PCDOWN(period)
local out={}
   for i=1,#up,1 do
     out[i]=(up[i]+down[i])/2
    end
return out
end

--Ichimoku Kinko Hyo
-- Tenkan-sen
function TENKAN(InpTenkan)
local function iHighest( StartPos,  Depth)   
   local res=HIGH[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(HIGH[i]>res) then
         res=HIGH[i]; end
    end
return(res);
end
local function iLowest( StartPos,  Depth)
   local res=LOW[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(LOW[i]<res) then
         res=LOW[i]; end
    end
return(res);
end 

  local ExtTenkanBuffer={}
  for i=InpTenkan+1 ,#CLOSE,1 do
      local _high=iHighest(i,InpTenkan);
      local _low=iLowest(i,InpTenkan);
      ExtTenkanBuffer[i-InpTenkan]=(_high+_low)/2.0;
  end
return ExtTenkanBuffer
end

-- Kijun-sen
function KIJUN(InpKijun)
local function iHighest( StartPos,  Depth)   
   local res=HIGH[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(HIGH[i]>res) then
         res=HIGH[i]; end
    end
return(res);
end
local function iLowest( StartPos,  Depth)
   local res=LOW[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(LOW[i]<res) then
         res=LOW[i]; end
    end
return(res);
end 

  local ExtKijunBuffer={}
  for i=InpKijun+1 ,#CLOSE,1 do
      local _high=iHighest(i,InpKijun);
      local _low=iLowest(i,InpKijun);
      ExtKijunBuffer[i-InpKijun]=(_high+_low)/2.0;
  end
return ExtKijunBuffer
end

-- Senkou Span A
function SPANA(InpTenkan,InpKijun)
  
  local ExtSpanABuffer={}
  local ExtTenkanBuffer=TENKAN(InpTenkan)
  local ExtKijunBuffer=KIJUN(InpKijun)
  
  local fark=InpKijun-InpTenkan
  for i=1,#ExtKijunBuffer,1 do
  ExtSpanABuffer[i]=(ExtTenkanBuffer[i+fark]+ExtKijunBuffer[i])/2.0;
  end
  
return ExtSpanABuffer
end

-- Senkou Span B
function SPANB(InpSenkou)
local function iHighest( StartPos,  Depth)   
   local res=HIGH[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(HIGH[i]>res) then
         res=HIGH[i]; end
    end
return(res);
end
local function iLowest( StartPos,  Depth)
   local res=LOW[StartPos];
   for i=StartPos-Depth+1,StartPos,1 do
      if(LOW[i]<res) then
         res=LOW[i]; end
    end
return(res);
end 

  local ExtSpanBBuffer={}
  for i=InpSenkou+1 ,#CLOSE,1 do
      local _high=iHighest(i,InpSenkou);
      local _low=iLowest(i,InpSenkou);
      ExtSpanBBuffer[i-InpSenkou]=(_high+_low)/2.0;
  end
return ExtSpanBBuffer
end

--Aroon-Up = ((25 - Days Since 25-day High)/25) x 100
--Aroon-Down = ((25 - Days Since 25-day Low)/25) x 100
-- Aroon
function AROONUP(period)
local function HighestSince( StartPos,  Depth)   
   local res=HIGH[StartPos-Depth+1]
   local ago=Depth
   for i=1,Depth,1 do
     if HIGH[StartPos-Depth+i]>res then  res=HIGH[StartPos-Depth+i] ago=Depth-i end
    end
return(ago);
end
  local out={}
  for i=period ,#CLOSE,1 do
      local hsince=HighestSince(i,period);
      out[i-period+1] = ((period - hsince)/period) * 100
  end
return out
end
function AROONDOWN(period)
local function LowestSince( StartPos,  Depth)   
   local res=LOW[StartPos-Depth+1]
   local ago=Depth
   for i=1,Depth,1 do
     if LOW[StartPos-Depth+i]<res then  res=LOW[StartPos-Depth+i] ago=Depth-i end
    end
return(ago);
end
  local out={}
  for i=period ,#CLOSE,1 do
      local lsince=LowestSince(i,period);
      out[i-period+1] = ((period - lsince)/period) * 100
  end
return out
end


--Variable Index Dynamic Average
function VIDYA(source,InpPeriodCMO,InpPeriodEMA)
if type(source)==type(1) then 
  if source==0 then source=CLOSE elseif source==1 then source=OPEN elseif source==2 then source=HIGH 
  elseif source==3 then source=LOW elseif source==4 then source=MEDIAN elseif source==5 then source=TYPICAL
  elseif source==6 then source=WEIGHTED end
end    
local function CalculateCMO( Position,  PeriodCMO,  price)
   local resCMO=0.0;
   local UpSum=0.0 local DownSum=0.0;
   if Position>=PeriodCMO then --and ArrayRange(price,0)>Position then     
      for i=0,PeriodCMO-1,1 do
         local diff=source[Position-i]-price[Position-i-1];
         if(diff>0.0) then UpSum=UpSum+diff;  else  DownSum=DownSum+-(diff); end        
      end
      if(UpSum+DownSum~=0.0) then resCMO=(UpSum-DownSum)/(UpSum+DownSum); end     
   end
   return(resCMO);
end
  
--- main cycle
local VIDYA_Buffer={}
for i=1,InpPeriodCMO+InpPeriodEMA-1,1 do
VIDYA_Buffer[i]=CLOSE[i]
end
--- calculate smooth factor
   local ExtF=2.0/(1.0+InpPeriodEMA);
   for i=InpPeriodCMO+InpPeriodEMA,#CLOSE,1 do
      --- calculate CMO and get absolute value
      local mulCMO=math.abs(CalculateCMO(i,InpPeriodCMO,source));
      --- calculate VIDYA
      VIDYA_Buffer[i]=source[i]*ExtF*mulCMO+VIDYA_Buffer[i-1]*(1-ExtF*mulCMO); 
   end 
return VIDYA_Buffer
end

--Volume Rate of Change
function VROC(ExtPeriodVROC)
local ExtVROCBuffer={}   
   for i=ExtPeriodVROC,#CLOSE,1 do
      -- getting some data
      local PrevVolume=VOLUME[i-(ExtPeriodVROC-1)];
      local CurrVolume=VOLUME[i];
      --- fill ExtVROCBuffer
      if(PrevVolume~=0.0) then
         ExtVROCBuffer[i-ExtPeriodVROC+1]=100.0*(CurrVolume-PrevVolume)/PrevVolume;
      else
         ExtVROCBuffer[i-ExtPeriodVROC+1]=ExtVROCBuffer[i-1];
      end
   end
return ExtVROCBuffer
end

--Parabolic Sar
function PSAR(ExtSarStep,ExtSarMaximum)
local function GetHigh( nPosition, nStartPeriod, HiData)
   --- calculate
   local result=HiData[nStartPeriod];
   for i=nStartPeriod,nPosition,1 do if(result<HiData[i]) then result=HiData[i] end end
   return(result);
end  
local function GetLow( nPosition, nStartPeriod, LoData)
   --- calculate
   local result=LoData[nStartPeriod];
   for i=nStartPeriod,nPosition,1 do if(result>LoData[i]) then result=LoData[i] end end
   return(result);
end   
local ExtAFBuffer={}      
local ExtSARBuffer={}  
local ExtEPBuffer={}  
      --- first pass, set as SHORT
      pos=2;
      ExtAFBuffer[1]=ExtSarStep;
      ExtAFBuffer[2]=ExtSarStep;
      ExtSARBuffer[1]=HIGH[1];
      local ExtLastRevPos=1;
      local ExtDirectionLong=false;
      ExtSARBuffer[2]=GetHigh(pos,ExtLastRevPos,HIGH);
      ExtEPBuffer[1]=LOW[pos];
      ExtEPBuffer[2]=LOW[pos];
      
---main cycle
for i=pos, #CLOSE-1,1 do
     
      --- check for reverse
    if(ExtDirectionLong) then
        
         if(ExtSARBuffer[i]>LOW[i]) then
            --- switch to SHORT
            ExtDirectionLong=false;
            ExtSARBuffer[i]=GetHigh(i,ExtLastRevPos,HIGH);
            ExtEPBuffer[i]=LOW[i];
            ExtLastRevPos=i;
            ExtAFBuffer[i]=ExtSarStep;
         end
        
    else
        
         if(ExtSARBuffer[i]<HIGH[i]) then
            --- switch to LONG
            ExtDirectionLong=true;
            ExtSARBuffer[i]=GetLow(i,ExtLastRevPos,LOW);
            ExtEPBuffer[i]=HIGH[i];
            ExtLastRevPos=i;
            ExtAFBuffer[i]=ExtSarStep;
         end
    end
    
      --- continue calculations
      if(ExtDirectionLong) then
        
         --- check for new High
         if(HIGH[i]>ExtEPBuffer[i-1] and i~=ExtLastRevPos) then
           
            ExtEPBuffer[i]=HIGH[i];
            ExtAFBuffer[i]=ExtAFBuffer[i-1]+ExtSarStep;
            if(ExtAFBuffer[i]>ExtSarMaximum) then
               ExtAFBuffer[i]=ExtSarMaximum; end
           
         else
           
            --- when we haven't reversed
            if(i~=ExtLastRevPos) then
              
               ExtAFBuffer[i]=ExtAFBuffer[i-1];
               ExtEPBuffer[i]=ExtEPBuffer[i-1];
             end
         end
         --- calculate SAR for tomorrow
         ExtSARBuffer[i+1]=ExtSARBuffer[i]+ExtAFBuffer[i]*(ExtEPBuffer[i]-ExtSARBuffer[i]);
         --- check for SAR
         if(ExtSARBuffer[i+1]>LOW[i] or ExtSARBuffer[i+1]>LOW[i-1]) then
            ExtSARBuffer[i+1]=math.min(LOW[i],LOW[i-1]); end
        
      else
        
         --- check for new Low
         if(LOW[i]<ExtEPBuffer[i-1] and i~=ExtLastRevPos) then
           
            ExtEPBuffer[i]=LOW[i];
            ExtAFBuffer[i]=ExtAFBuffer[i-1]+ExtSarStep;
            if(ExtAFBuffer[i]>ExtSarMaximum) then
               ExtAFBuffer[i]=ExtSarMaximum; end
           
         else
           
            --- when we haven't reversed
            if(i~=ExtLastRevPos) then
             
               ExtAFBuffer[i]=ExtAFBuffer[i-1];
               ExtEPBuffer[i]=ExtEPBuffer[i-1];
             end
          end 
         --- calculate SAR for tomorrow
         ExtSARBuffer[i+1]=ExtSARBuffer[i]+ExtAFBuffer[i]*(ExtEPBuffer[i]-ExtSARBuffer[i]);
         --- check for SAR
         if(ExtSARBuffer[i+1]<HIGH[i] or ExtSARBuffer[i+1]<HIGH[i-1]) then
            ExtSARBuffer[i+1]=math.max(HIGH[i],HIGH[i-1]); end
       end    
end  
return ExtSARBuffer
end

function CROSS(source,destination) 
local cross={}
 
if type(source)==type(cross) and type(destination)==type(1) then
    for i=2,#source,1 do
       if source[i]>destination and source[i-1]<=destination then cross[i-1]=1 else cross[i-1]=0 end
    end    
end
  
if type(source)==type(1) and type(destination)==type(cross) then
    for i=2,#destination,1 do
       if source>destination[i] and source<=destination[i-1] then cross[i-1]=1 else cross[i-1]=0 end
    end    
end

if type(source)==type(cross) and type(destination)==type(cross) then
  local lendiff=math.abs(#source-#destination)  
  if #source>#destination then 
    for i=2,#destination,1 do
       if source[i+lendiff]>destination[i] and source[i+lendiff-1]<=destination[i-1] then cross[i-1]=1 else cross[i-1]=0 end
    end  
  else
    for i=2,#source,1 do
       if source[i]>destination[i+lendiff] and source[i-1]<=destination[i+lendiff-1] then cross[i-1]=1 else cross[i-1]=0 end
    end  
  end
end

return cross 
end

function REPORT(buy,sell)

  local lendiffbuy=math.abs(#CLOSE-#buy)
  local lendiffsell=math.abs(#CLOSE-#sell)
  local ilkyatirim=0--tl
  local lastpos=0--1 al 0 sat
  local alfiyat=0--tl
  local satfiyat=0--tl
  local kapafiyat=0--tl
  local toplamkz=0
--print("RAPOR")
for i=1 ,#CLOSE,1 do
   if buy[i]==1 and lastpos==0 then 
     lastpos=1 alfiyat=CLOSE[lendiffbuy+i] if satfiyat==0 then ilkyatirim=alfiyat end  --print("al",CLOSE[lendiffbuy+i]) 
   end
   if sell[i]==1 and lastpos==1 then 
     lastpos=0 satfiyat=CLOSE[lendiffsell+i] 
     --print("sat",CLOSE[lendiffsell+i]) print("K/Z",satfiyat-alfiyat)  
     toplamkz=toplamkz+satfiyat-alfiyat --print(toplamkz) 
  end
end
  
  --kapaportfoy
  if lastpos==1 then kapafiyat=CLOSE[#CLOSE]  --print("kapa",CLOSE[#CLOSE]) print("K/Z",kapafiyat-alfiyat) 
      toplamkz=toplamkz+kapafiyat-alfiyat --print(toplamkz) 
  end

return toplamkz/ilkyatirim*100;
end


function write()
--C:\\Users\\x64\\AppData\\Roaming\\MetaQuotes\\Terminal\\BB190E062770E27C3E79391AB0D1A117\\MQL4\\Files\\
local i=1
for line in io.lines("data.txt") do
    local open, high, low, close, volume = line:match("%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.+)")
    OPEN[i]=tonumber(open)
    HIGH[i]=tonumber(high)
    LOW[i]=tonumber(low)
    CLOSE[i]=tonumber(close)
    VOLUME[i]=tonumber(volume)
    i=i+1
end

MEDIAN=MEDIANPRICE()
TYPICAL=TYPICALPRICE()
WEIGHTED=WEIGHTEDCLOSE()


--for OPT1=5,95,5 do
--BUY=CROSS(MOMENTUM(PRICE_CLOSE,OPT1),100)
--SELL=CROSS(100,MOMENTUM(PRICE_CLOSE,OPT1))
--print(REPORT(BUY,SELL))
--end

for k, v in pairs(PSAR(0.02,0.2)) do
   print(k, v)
end



end

write()