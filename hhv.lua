function HHV(source,period)
  
  local out={}
  for  i=1,period-1,1 do
    out[i] = 0;
  end
  
    for  i=table.getn(source),period,-1 do
      local highest=0
      for j=0,period-1,1 do
          if highest>source[i-j] then highest=highest else highest=source[i-j] end
      end
      out[i]=highest
    end
    
return out;
end


--[[
HIGH={127.01,127.62,126.59,127.35,128.17,128.43,127.37,126.42,126.90,126.85,125.65,125.72,127.16,127.72,127.69,128.22,128.27,128.09,128.27,127.74,128.77,129.29,130.06,129.12,129.29,128.47,128.09,128.65,129.14,128.64}

for k, v in pairs(HHV(HIGH,14)) do
   print(k, v)
end
--]]