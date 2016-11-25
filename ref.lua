function REF(source,period)
local out={}
  for  i=table.getn(source),period+1,-1 do
      out[i-period]=source[i-period]
  end
return out
end


