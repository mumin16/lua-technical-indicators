function EMA(source,period)
local multiplier=(2 / (period + 1) ) 
local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=period,table.getn(source),1 do
      if(i-1<=period) then out[i]=source[i] else out[i]=(source[i]-out[i-1]) * multiplier + out[i-1] end
  end
return out
end



