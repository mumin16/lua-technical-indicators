	--pricedata
	OPEN = { };
	HIGH = { };
	LOW =  { };
  CLOSE = { };
	VOLUME = { };
	MEDIAN = { };
	TYPICAL = { };
	WEIGHTED = { };

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

--Exponential Moving Avarage
function EMA(source,period)
local multiplier=(2 / (period + 1) ) 
local out={}
  for  i=1,#source,1 do
      if i-1==0 then out[i]=source[i] else out[i]=(source[i]-out[i-1]) * multiplier + out[i-1] end
  end
return out
end

--Smoothed Moving Average
function SMMA(source,period)
local out={}
local sma1=0
  for j=1,period,1 do
     sma1= sma1+source[j];
  end
  for  i=1,#source-period+1,1 do
      if i==1 then out[i]=sma1/period else out[i]=(out[i-1] * (period-1) +source[i+period-1])/period end
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
        sum = sum+ (source[i-j+period-1]-sma[i])^2 
      end
      out[i]=math.sqrt(sum/period)--*deviation
  end
return out 
end

--Bollinger Bands
function BANDSUPPER(source,period,deviation)
local sma=SMA(source,period)
local out={}
  for  i=1,#sma,1 do
      local sum=0
      for j=0,period-1,1 do
        sum = sum+ (source[i-j+period-1]-sma[i])^2 
      end
      out[i]=sma[i]+math.sqrt(sum/period)*deviation
  end
return out
end
function BANDSLOWER(source,period,deviation)
local sma=SMA(source,period)
local out={}
  for  i=1,#sma,1 do
      local sum=0
      for j=0,period-1,1 do
        sum = sum+ (source[i-j+period-1]-sma[i])^2 
      end
      out[i]=sma[i]-math.sqrt(sum/period)*deviation
  end
return out
end

function BEARSPOWER(source,period)
local out={}
    for  i=1,#source,1 do
      out[i]=LOW[i]-EMA(source,period)[i]
    end
return out
end

function BULLSPOWER(source,period)
local out={}
    for  i=1,#source,1 do
      out[i]=HIGH[i]-EMA(source,period)[i]
    end
return out
end

function MOMENTUM(source,period)
local out={}
  for  i=1,#source,1 do
    if i+period>#source then break else out[i] = (source[i+period]*100/ source[i] ) end
  end
return out
end

function DEMARKER(period)
local DeMin={}
local DeMax={}
  for  i=1,#HIGH,1 do
    if i==1 or  HIGH[i] <= HIGH[i-1] then DeMax[i] = 0 else DeMax[i] = HIGH[i] - HIGH[i-1] end
    if i==1 or  LOW[i] >= LOW[i-1] then DeMin[i] = 0 else DeMin[i] =   LOW[i-1]-LOW[i] end
  end

local out={}
  for  i=1,#HIGH-period+1,1 do
    out[i]=SMA(DeMax, period)[i]/(SMA(DeMax, period)[i]+SMA(DeMin, period)[i])
  end
return out
end

--FORCE(i) = VOLUME (i) * ((MA (ApPRICE, N, i) - MA (ApPRICE, N, i-1))
function FORCE(source,period)
local out={}
 
return out
end

--Awesome Oscillator
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


CLOSE={140.558,
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
140.78,
140.701,
140.565,
140.128,
139.506,
139.855,
140.087,
139.896,
140.145,
139.904,
139.879,
139.863,
139.555,
139.496,
139.263,
139.677,
139.818,
139.752,
139.33,
139.436,
139.435,
139.401,
139.375,
139.122,
138.92,
138.841,
138.542,
138.808,
138.87,
138.933,
138.937,
138.775,
138.956,
139.057,
139.29,
139.797,
140.392,
140.253,
140.489,
140.795,
141.054,
141.052,
141.196,
141.042,
140.745,
140.455,
140.41,
140.434,
140.34,
140.519,
140.454,
140.204,
140.123,
140.169,
140.516,
140.701,
140.682,
140.687,
140.591,
141.08,
141.173,
140.502,
141.072,
141.114
}

HIGH={140.78,
141.04,
141.115,
140.957,
141.049,
141.173,
141.274,
141.231,
141.272,
141.282,
141.228,
141.208,
141.109,
141.09,
141.055,
141.62,
141.729,
141.601,
141.549,
141.493,
141.285,
141.402,
141.258,
140.641,
141.027,
140.994,
140.912,
140.834,
140.616,
140.52,
140.714,
140.994,
141.131,
141.088,
141.041,
141.038,
141.091,
140.919,
140.824,
140.698,
140.286,
139.955,
140.159,
140.143,
140.193,
140.161,
140.119,
140.065,
140.029,
139.762,
139.598,
139.78,
140.056,
139.917,
139.905,
139.542,
139.537,
139.45,
139.421,
139.386,
139.197,
138.976,
138.892,
139.003,
139.185,
138.975,
139.029,
138.975,
138.984,
139.162,
139.414,
139.833,
140.478,
140.452,
140.62,
141.04,
141.309,
141.322,
141.245,
141.359,
141.039,
140.757,
140.587,
140.499,
140.452,
140.525,
140.556,
140.517,
140.366,
140.243,
140.629,
140.959,
140.852,
140.86,
140.719,
141.083,
141.508,
141.228,
141.076,
141.408
}

LOW={
 140.397,
140.551,
140.877,
140.695,
140.705,
140.968,
140.945,
140.94,
140.91,
141.157,
141.102,
141.079,
140.957,
140.923,
140.919,
140.947,
141.415,
141.41,
141.215,
141.157,
141.006,
141.075,
140.558,
139.951,
140.241,
140.23,
140.377,
140.349,
140.288,
140.096,
140.339,
140.64,
140.78,
140.741,
140.558,
140.817,
140.729,
140.566,
140.496,
139.906,
139.486,
139.311,
139.845,
139.742,
139.755,
139.812,
139.664,
139.709,
139.464,
139.302,
139.012,
139.134,
139.593,
139.642,
139.075,
139.166,
139.334,
139.3,
139.309,
139.113,
138.844,
138.79,
138.5,
138.542,
138.805,
138.813,
138.857,
138.708,
138.746,
138.885,
139.035,
139.18,
139.779,
140.134,
140.249,
140.482,
140.741,
141.009,
140.783,
140.966,
140.667,
140.444,
140.397,
140.341,
140.271,
140.337,
140.423,
139.959,
140.09,
140.026,
140.158,
140.423,
140.538,
140.5,
140.418,
140.541,
140.95,
140.333,
140.463,
140.86 
  }

function write()

for k, v in pairs(DEMARKER(10)) do
   print(k, v)
end

end

write()