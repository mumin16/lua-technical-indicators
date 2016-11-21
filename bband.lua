  

function BBandTop(source,period,deviation)
  local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end  

local stddev_lua = assert(loadfile("stddev.lua")) stddev_lua()
local stddev={}
stddev=STDDEV(source,period,deviation)

local sma_lua = assert(loadfile("sma.lua")) sma_lua()
local sma={}
sma=SMA(source,period)
  
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

local stddev_lua = assert(loadfile("stddev.lua")) stddev_lua()
local stddev={}
stddev=STDDEV(source,period,deviation)

local sma_lua = assert(loadfile("sma.lua")) sma_lua()
local sma={}
sma=SMA(source,period)
  
  for  i=table.getn(source),period,-1 do
      out[i]=sma[i]-stddev[i]
  end

return out
end


