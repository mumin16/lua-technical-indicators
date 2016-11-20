
--WMA = (P1 * 5) + (P2 * 4) + (P3 * 3) + (P4 * 2) + (P5 * 1) / (5 + 4+ 3 + 2 + 1)
function WMA(source,period)
out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period,-1 do
      sum=0
      div=0
      for j=0,period-1,1 do
           sum = sum+(source[i-j]*(period-j))
           div=div+j+1
      end
      out[i]=sum/div
  end
return out
end


