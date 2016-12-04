	--global pricedata
	OPEN = { };	HIGH = { };	LOW =  { };  CLOSE = { };	VOLUME = { };	MEDIAN = { };	TYPICAL = { };	WEIGHTED = { };


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
local sum=SUM(source,period)
local out={} 
  for j=1,#sum,1 do out[j] = sum[j]/period end
return out
end

--Weighted Moving Avarage
function WMA(source,period)
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
local multiplier=(2 / (period + 1) ) 
local out={}
  for  i=1,#source,1 do
      if i-1==0 then out[i]=source[i] else out[i]=(source[i]-out[i-1]) * multiplier + out[i-1] end
  end
return out
end

--Smoothed Moving Average
function SMMA(source,period)
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
function STDDEV(source,period,deviation)
local sma=SMA(source,period)
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

function BEARSPOWER(source,period)
local out={}
    for  i=1,#source,1 do
      out[i]=LOW[i]-EMA(source,period)[i]
    end
return out
end

function BULLSPOWER(source,period)
local out={}
    for  i=1,#source,1 do
      out[i]=HIGH[i]-EMA(source,period)[i]
    end
return out
end

function MOMENTUM(source,period)
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

function FORCE(source,period)
local out={}
   for  i=1,#source-period+1,1 do
     if i==1 then out[i]= VOLUME[i+period-1]*SMA(source,period)[i] 
     else out[i]=VOLUME[i+period-1]*(SMA(source,period)[i]- SMA(source,period)[i-1]) end
  end
return out
end

--On Balance Volume
function OBV(source)
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

function MACD(source,fast,slow,signal)
local fastema=EMA(source,fast)
local slowema=EMA(source,slow)
local out={}
  for  i=1,#slowema,1 do
    out[i] = fastema[i]-slowema[i];
  end
return out
end

function MACDSIGNAL(source,fast,slow,signal)
  return SMA(MACD(source,fast,slow),signal)
end

--Envelopes
function ENVELOPESUPPER(source,period,deviation)
local sma=SMA(source, period)
local out={}
  for  i=1,#sma,1 do
    out[i]=(1+deviation/100.0)*sma[i];
  end
return out
end

function ENVELOPESLOWER(source,period,deviation)
local sma=SMA(source, period)
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

--%K=(Price-L5)/(H5-L5)
--%D=100*((K1+K2+K3)/3)
function STOCHASTIC(Kperiod,Dperiod,slowing)
  local ExtMainBuffer={}
  local ExtLowesBuffer=LOWEST(LOW,Kperiod)
  local ExtHighesBuffer=HIGHEST(HIGH,Kperiod)
  local start=Kperiod+slowing;
--- main cycle
  for i=start+1, #CLOSE ,1 do
    
      sumlow=0.0;
      sumhigh=0.0;
      
      for k=(i-slowing+1),i,1 do
        
         sumlow =sumlow+(CLOSE[k]-ExtLowesBuffer[k]);
         sumhigh=sumhigh+(ExtHighesBuffer[k]-ExtLowesBuffer[k]);
        
      end 
      
      if sumhigh==0.0 then ExtMainBuffer[i-start]=100.0 else  ExtMainBuffer[i-start]=sumlow/sumhigh*100 end
  end
return ExtMainBuffer  
end

function STOCHASTICSIGNAL(Kperiod,Dperiod,slowing)
return SMA(STOCHASTIC(Kperiod,Dperiod,slowing),Dperiod)
end


--Triple Exponential Average
function TRIX(source,period)
local ema=EMA(source,period)
for i=1,period-1,1 do table.remove(ema,1) end
local ema2=EMA(ema,period)
for i=1,period-1,1 do table.remove(ema2,1) end
local ema3=EMA(ema2,period)
     
local out={}
  for  i=period,#ema3,1 do
    out[i-period+1]=(ema3[i] - ema3[i-1])/ ema3[i-1] 
  end
return out
end

function DEMA(source,period)
local ema=EMA(source,period)
for i=1,period-1,1 do table.remove(ema,1) end
local emaofema=EMA(ema,period)
local out={}
  for  i=period,#emaofema,1 do
    out[i-period+1]=2*ema[i]-emaofema[i]
  end
return out
end

function TEMA(source,period)
local ema=EMA(source,period)
for i=1,period-1,1 do table.remove(ema,1) end
local emaofema=EMA(ema,period)
for i=1,period-1,1 do table.remove(emaofema,1) end
local emaofemaofema=EMA(emaofema,period)

local out={}
  for  i=period,#emaofemaofema,1 do
    out[i-period+1]=3*ema[i+period-1]-3*emaofema[i]+emaofemaofema[i];
  end
return out
end

--Detrended Price Oscillator
function DPO(source,period)
   ExtMAPeriod=period/2+1;
local sma=SMA(source,ExtMAPeriod)
local out={} 
  for j=1,#sma,1 do out[j] = source[j+ExtMAPeriod-1]-sma[j] end
return out
end

function CHAIKIN(fast,slow)
local ad=AD()
local fastad=EMA(ad,fast)
local slowad=EMA(ad,slow)
local out={}
  for  i=1,#slowad,1 do
    out[i]=fastad[i]-slowad[i]
  end 
return out
end

--Rate of Change 
function ROC(source,period)
local out={}
  for  i=period+1 , #source,1 do
    out[i-period] = (source[i]-source[i-period])/source[i] * 100;
  end
return out
end

--MASS INDEX
function MI(ema1period,ema2period,massperiod)
local hl={}
  for  i=1 , #CLOSE,1 do
    hl[i] = HIGH[i]-LOW[i]
  end
local ema=EMA(hl,ema1period)
local emaofema=EMA(ema,ema2period)
local ratio={}
  for  j=1 , #emaofema,1 do
    ratio[j] = ema[j]/emaofema[j] 
  end
return SUM(ratio,massperiod)
end 

--PLUSDI=100*(sumplusdm/sumtr)
function PLUSDI(period)
local plusdm={}
  for i=2,#CLOSE,1 do
    if HIGH[i]-HIGH[i-1]>LOW[i-1]-LOW[i] then plusdm[i-1]=math.max(HIGH[i]-HIGH[i-1],0) else plusdm[i-1]=0 end
  end
  
local sumplusdm={}
local sum=0
  for i=1,period,1 do
    sum=sum+plusdm[i]
  end
sumplusdm[1]=sum
  for i=1,#plusdm-period,1 do
    sumplusdm[i+1]=sumplusdm[i]-(sumplusdm[i]/period)+plusdm[i+period]
  end

local tr={}
  for i=2,#CLOSE,1 do
      tr[i-1]=math.max(HIGH[i]-LOW[i],math.abs(HIGH[i]-CLOSE[i-1]),math.abs(LOW[i]-CLOSE[i-1])) 
  end

local sumtr={}
sum=0
  for i=1,period,1 do
    sum=sum+tr[i]
  end
sumtr[1]=sum
  for i=1,#tr-period,1 do
    sumtr[i+1]=sumtr[i]-(sumtr[i]/period)+tr[i+period]
  end
  
local out={}
  for i=1,#sumtr,1 do
      out[i]=100*(sumplusdm[i]/sumtr[i])
  end
return out
end

--MINUSDI=100*(summinusdm/sumtr)
function MINUSDI(period)
local minusdm={}
  for i=2,#CLOSE,1 do
    if LOW[i-1]-LOW[i]>HIGH[i]-HIGH[i-1] then minusdm[i-1]=math.max(LOW[i-1]-LOW[i],0) else minusdm[i-1]=0 end
  end
  
local summinusdm={}
local sum=0
  for i=1,period,1 do
    sum=sum+minusdm[i]
  end
summinusdm[1]=sum
  for i=1,#minusdm-period,1 do
    summinusdm[i+1]=summinusdm[i]-(summinusdm[i]/period)+minusdm[i+period]
  end

local tr={}
  for i=2,#CLOSE,1 do
      tr[i-1]=math.max(HIGH[i]-LOW[i],math.abs(HIGH[i]-CLOSE[i-1]),math.abs(LOW[i]-CLOSE[i-1])) 
  end

local sumtr={}
sum=0
  for i=1,period,1 do
    sum=sum+tr[i]
  end
sumtr[1]=sum
  for i=1,#tr-period,1 do
    sumtr[i+1]=sumtr[i]-(sumtr[i]/period)+tr[i+period]
  end
  
local out={}
  for i=1,#sumtr,1 do
      out[i]=100*(summinusdm[i]/sumtr[i])
  end
return out
end


--Average Directional Index
function ADX(period)
local plusdi=PLUSDI(period)
local minusdi=MINUSDI(period)
local diff={}
  for i=1,#minusdi,1 do
      diff[i]=math.abs(plusdi[i]-minusdi[i])
  end
local sum={}
  for i=1,#minusdi,1 do
      sum[i]=plusdi[i]+minusdi[i]
  end  
local dx={}
  for i=1,#minusdi,1 do
      dx[i]=100*(diff[i]/sum[i])
  end 
 local out={}
 local sma1=0
  for i=1,period,1 do
      sma1=sma1+dx[i]
  end 
  out[1]=sma1/period
  for i=1,#dx-period,1 do
      out[i+1]=((out[i]*(period-1))+dx[i+period-1])/period
  end   
return out
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



for k, v in pairs(ROC(CLOSE,12)) do
   print(k, v)
end

end

write()