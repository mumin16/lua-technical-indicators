function SUM(source,period)
local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period,-1 do
      local sum=0
      for j=0,period-1,1 do
           sum = sum+source[i-j];
      end
      out[i]=sum
  end
return out
end

