	--pricedata
	CLOSE = { };
	OPEN = { };
	HIGH = { };
	LOW =  { };
	VOLUME = { };
	MEDIAN = { };
	TYPICAL = { };
	WEIGHTED = { };

--Sum 
function SUM(source,period)
  local out={}
  for  i=1,#source-period+1,1 do
      local sum=0
      for j=0,period-1,1 do
         if j+i>#source then break else sum = sum+source[j+i] end
      end
      out[i]=sum
  end
return out
end  

--Simple Moving Avarage
function SMA(source,period)
local sum=SUM(source,period)
local out={} 
  for j=1,#sum,1 do out[j] = sum[j]/period end
return out
end

--Weighted Moving Avarage
function WMA(source,period)
local out={}
  for  i=1,#source-period+1,1 do
      local sum=0
      local div=0
      for j=0,period-1,1 do
           sum = sum+(source[i+j]*(j+1))
           div=div+j+1
      end
      out[i]=sum/div
  end
return out
end

--Standart Deviation
function STDDEV(source,period,deviation)
local sma=SMA(source,period)
local out={}
  for  i=1,#sma,1 do
      local sum=0
      for j=0,period-1,1 do
        if j+i>#sma then break else  sum = sum+ ((source[i+j+period-1]-sma[i+j])^2) end
      end
      out[i]=math.sqrt(sum/period)*deviation
  end
return out 
end

--Awesome Oscillator
--AO = SMA(median price, 5)-SMA(median price, 34)
function AO()
local sma5=SMA(MEDIAN,5)
local sma34=SMA(MEDIAN,34)
local out={}
  for  i=1,#sma34,1 do
    out[i]=sma5[i+#sma5-#sma34]-sma34[i]
  end
return out
end

--Accelerator/Decelerator Oscillator
--AC = AO-SMA(AO, 5)
function AC()
local ao=AO()
local ao5=SMA(ao,5)
local out={}
  for  i=1,#ao5,1 do
    out[i]=ao[i+#ao-#ao5]-ao5[i]
  end
return out
end

--Accumulation/Distribution
function AD()
local out={}  
    for  i=1,#CLOSE,1 do
      if i-1==0 then out[i]=(((CLOSE[i] - LOW[i]) - (HIGH[i] - CLOSE[i])) / (HIGH[i] - LOW[i])) * VOLUME[i] else out[i]=(((CLOSE[i] - LOW[i]) - (HIGH[i] - CLOSE[i])) / (HIGH[i] - LOW[i])) * VOLUME[i] + out[i-1] end
    end
return out  
end


CLOSE={139.952,
139.845,
139.694,
139.851,
139.778,
140.035,
140.193,
140.216,
140.184,
140.034,
140.17,
140.677,
140.667,
140.558,
140.955,
140.957,
140.757,
140.999,
141.159,
141.109,
141.06,
141.256,
141.202,
141.188,
141.09,
140.965,
141.049,
141.009,
141.562,
141.447,
141.474,
141.255,
141.192,
141.088,
141.197,
140.638,
140.258,
140.997,
140.393,
140.813,
140.536,
140.401,
140.481,
140.711,
140.99,
140.961,
140.851,
141.038,
140.891,
140.78
}



for k, v in pairs(STDDEV(CLOSE,10,2)) do
   print(k, v)
end