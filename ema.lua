function EMA(source,period)
multiplier=(2 / (period + 1) ) 
--EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day). 
out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=period,table.getn(source),1 do
      if(i-1<=period) then out[i]=source[i] else out[i]=(source[i]-out[i-1]) * multiplier + out[i-1] end
  end
return out
end



