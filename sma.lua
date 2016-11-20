

function SMA(source,period)
out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  for  i=table.getn(source),period,-1 do
      sum={}
      sum[i]=source[i]
      for j=1,period-1,1 do
           sum[i] = sum[i]+source[i-j];
      end
      out[i]=sum[i]/period
  end
return out
end


