function ROC(source,period)
local out={}
  for  i=1,period,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period+1,-1 do
    out[i] = (source[i] / source[i - period] - 1) * 100;
  end
return out
end


