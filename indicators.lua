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

--CCI = M/D
--D = TP — SMA(TP, N)
--M = SMA(D, N) * 0,015
function CCI(source,period)
local D={}
local sma=SMA(source,period)
  for  j=1,#sma,1 do
      D[j]=math.abs(source[j+period-1]-sma[j])
  end
local M={}
local smad=SMA(D,period)
  for  k=1,#smad,1 do
      M[k]=smad[k]*0.015
  end
local out={}  
  for  i=1,#smad,1 do
      out[i]=M[i]/D[i+period-1]
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
    end
return out  
end

function MACD(source,fast,slow)
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
function write()

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

for k, v in pairs(MACDSIGNAL(CLOSE,12,26,9)) do
   print(k, v)
end

end

write()