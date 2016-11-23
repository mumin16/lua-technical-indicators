require "stddev"
require "sma"  

function BBandTop(source,period,deviation)
  local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end  

  local stddev=STDDEV(source,period,deviation)
  local sma=SMA(source,period)
  
  for  i=table.getn(source),period,-1 do
      out[i]=sma[i]+stddev[i]
  end

return out
end

function BBandBot(source,period,deviation)
  local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end  

  local stddev=STDDEV(source,period,deviation)
  local sma=SMA(source,period)
  
  for  i=table.getn(source),period,-1 do
      out[i]=sma[i]-stddev[i]
  end

return out
end


