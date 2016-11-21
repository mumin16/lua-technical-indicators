  
--stdev of {1,2,3} = math.sqrt( (1-2)^2 + (2-2)^2 + (3-2)^2 ) 
--2 
function STDDEV(source,period,deviation)
local SMA_lua = assert(loadfile("sma.lua")) SMA_lua()
sma={}
sma=SMA(source,period)
  
 out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period,-1 do
      sum=0
      for j=0,period-1,1 do
           sum = sum+ ((source[i-j]-sma[i])^2) 
      end
      
      out[i]=math.sqrt(sum/period)*deviation
  end
return out 
end

