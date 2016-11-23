require "sma" 
function MEANDEV(source,period)
local sma=SMA(source,period)
  
local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period,-1 do
      local sum=0
      for j=0,period-1,1 do
           sum = sum+ math.abs(sma[i]-source[i-j]) 
      end
      
      out[i]=sum/period
  end
return out 
end


--[[
price={23.98,23.92,23.79,23.67,23.54,23.36,23.65,23.72,24.16,23.91,23.81,23.92,23.74,24.68,24.94,24.93,25.10,25.12,25.20,25.06,24.50,24.31,24.57,24.62,24.49,24.37,24.41,24.35,23.75,24.09}
for k, v in pairs(MEANDEV(price,20)) do
   print(k, v)
end
--]]
