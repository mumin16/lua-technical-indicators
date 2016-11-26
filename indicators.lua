	--dax daily Sep 27, 2016- Nov 24, 2016
	CLOSE = { };
	OPEN = { };
	HIGH = { };
	LOW =  { };
	VOLUME = { };
		
function ROC(source,period)
local out={}
  for  i=table.getn(source),period+1,-1 do
    out[i] = (source[i] / source[i - period] - 1) * 100;
  end
return out
end


function HHV(source,period)
local out={}
    for  i=table.getn(source),period,-1 do
      local highest=0
      for j=0,period-1,1 do
          if highest>source[i-j] then highest=highest else highest=source[i-j] end
      end
      out[i]=highest
    end
return out;
end

function LLV(source,period)
local out={}
    for  i=table.getn(source),period,-1 do
      local lowest=source[i]
      for j=0,period-1,1 do
          if lowest<source[i-j] then lowest=lowest else lowest=source[i-j] end
      end
      out[i]=lowest
    end
return out;
end

function SUM(source,period)
local out={}
  for  i=table.getn(source),period,-1 do
      local sum=0
      for j=0,period-1,1 do
           sum = sum+source[i-j];
      end
      out[i]=sum
  end
return out
end

function SMA(source,period)
local out={}
  for  i=table.getn(source),period,-1 do
      local sum=0
      for j=0,period-1,1 do
           sum = sum+source[i-j];
      end
      out[i]=sum/period
  end
return out
end

function WMA(source,period)
local out={}
  for  i=table.getn(source),period,-1 do
      local sum=0
      local div=0
      for j=0,period-1,1 do
           sum = sum+(source[i-j]*(period-j))
           div=div+j+1
      end
      out[i]=sum/div
  end
return out
end

function EMA(source,period)
local multiplier=(2 / (period + 1) ) 
local out={}
local sma=0
  for j=1,period,1 do
     sma= sma+source[j];
  end
  for  i=period,table.getn(source),1 do
      if(i-1<period) then out[i]=sma/period else out[i]=(source[i]-out[i-1]) * multiplier + out[i-1] end
  end
return out
end

function STDDEV(source,period,deviation)
local sma=SMA(source,period)
local out={}
  for  i=table.getn(source),period,-1 do
      local sum=0
      for j=0,period-1,1 do
           sum = sum+ ((source[i-j]-sma[i])^2) 
      end
      out[i]=math.sqrt(sum/period)*deviation
  end
return out 
end

function MEANDEV(source,period)
local out={}
  local sma=SMA(source,period)
  for  i=table.getn(source),period,-1 do
      local sum=0
      for j=0,period-1,1 do
           sum = sum+ math.abs(sma[i]-source[i-j]) 
      end
      
      out[i]=sum/period
  end
return out 
end

function BBandTop(source,period,deviation)
local out={}
  local stddev=STDDEV(source,period,deviation)
  local sma=SMA(source,period)
  for  i=table.getn(source),period,-1 do
      out[i]=sma[i]+stddev[i]
  end
return out
end

function BBandBot(source,period,deviation)
local out={}
  local stddev=STDDEV(source,period,deviation)
  local sma=SMA(source,period)
  for  i=table.getn(source),period,-1 do
      out[i]=sma[i]-stddev[i]
  end
return out
end

function CCI(source,period)
local out={}
  local meandev=MEANDEV(source,period)
  local sma=SMA(source,period)
  for  i=table.getn(source),period,-1 do
      out[i]=(source[i]-sma[i])/ (0.015*meandev[i])
  end
return out
end

function MOM(source,period)
local out={}
  for  i=table.getn(source),period+1,-1 do
    out[i] = (source[i] - source[i - period] );
  end
return out
end

function MEDIANPRICE()
local out={}
  for  i=table.getn(CLOSE),1,-1 do
      out[i]=(HIGH[i]+LOW[i])/2
  end
return out
end

function TYPICALPRICE()
local out={}
  for  i=table.getn(CLOSE),1,-1 do
      out[i]=(HIGH[i]+LOW[i]+CLOSE[i])/3
  end
return out
end

function WEIGHTEDCLOSE()
local out={}
  for  i=table.getn(CLOSE),1,-1 do
      out[i]=(HIGH[i]+LOW[i]+CLOSE[i]+CLOSE[i])/4
  end
return out
end

function TR(period)
local out={}
  for  i=table.getn(CLOSE),1,-1 do
    if i==1 then out[i]=0 else out[i]=math.max((HIGH[i]-LOW[i]),math.abs((CLOSE[i-1]-HIGH[i])),math.abs((CLOSE[i-1]-LOW[i]))) end
  end
  table.remove(out, 1) 
return out
end

function ATR(period)
local out={}
local tr=TR(period)
  out[period]=SMA(tr,period)[period]
  for  i=period+1,table.getn(tr),1 do
     out[i]=(out[i-1]*(period-1)+tr[i])/period
  end 
return out
end

function BEARS(source,period)
    source =source or LOW
    period = period or 13
local out={}  
    for  i=table.getn(source),period,-1 do
      out[i]=source[i]-EMA(source,period)[i]
    end
return out    
end

function BULLS(source,period)
    source =source or HIGH
    period = period or 13
local out={}  
    for  i=table.getn(source),period,-1 do
      out[i]=source[i]-EMA(source,period)[i]
    end
return out    
end

function AD()
local out={}  
    for  i=table.getn(CLOSE),1,-1 do
      out[i]=((CLOSE[i] - LOW[i]) - (HIGH[i] - CLOSE[i]) * VOLUME[i] / (HIGH[i] - LOW[i])) + out[i-1]
    end
return out    
end