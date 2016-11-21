

function WMA(source,period)
local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period,-1 do
      local sum=0
      local div=0
      for j=0,period-1,1 do
           sum = sum+(source[i-j]*(period-j))
           div=div+j+1
      end
      out[i]=sum/div
  end
return out
end


