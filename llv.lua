function LLV(source,period)
  
  local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  
    for  i=table.getn(source),period,-1 do
      local lowest=source[i]
      for j=0,period-1,1 do
          if lowest<source[i-j] then lowest=lowest else lowest=source[i-j] end
      end
      out[i]=lowest
    end
    
return out;
end


--[[
LOW={125.36,126.16,124.93,126.09,126.82,126.48,126.03,124.83,126.39,125.72,124.56,124.57,
125.07,126.86,126.63,126.80,126.71,126.80,126.13,125.92,126.99,127.81,128.47,128.06,
127.61,127.60,127.00,126.90,127.49,127.40}

for k, v in pairs(LLV(LOW,14)) do
   print(k, v)
end
--]]