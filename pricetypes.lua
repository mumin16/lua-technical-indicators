function MEDIANPRICE(high,low)
local out={}
  for  i=table.getn(high),1,-1 do
      out[i]=(high[i]+low[i])/2
  end
return out
end

function TYPICALPRICE(high,low,close)
local out={}
  for  i=table.getn(high),1,-1 do
      out[i]=(high[i]+low[i]+close[i])/3
  end
return out
end

function WEIGHTEDCLOSE(high,low,close)
local out={}
  for  i=table.getn(high),1,-1 do
      out[i]=(high[i]+low[i]+close[i]+close[i])/4
  end
return out
end