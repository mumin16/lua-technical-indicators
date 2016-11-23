require "sma"   

function STDDEV(source,period,deviation)
local sma=SMA(source,period)
  
  local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period,-1 do
      local sum=0
      for j=0,period-1,1 do
           sum = sum+ ((source[i-j]-sma[i])^2) 
      end
      
      out[i]=math.sqrt(sum/period)*deviation
  end
return out 
end

