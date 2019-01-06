OPEN={}
HIGH={}
LOW={}
CLOSE={}
VOLUME={}

local i=1
for line in io.lines("GBPJPY60.csv") do
    local date, time, open, high, low, close, volume = line:match("%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.+)")
    OPEN[i]=open
    HIGH[i]=high
    LOW[i]=low
    CLOSE[i]=close
    VOLUME[i]=volume
    i=i+1
end

for k, v in pairs(VOLUME) do
   print(k, v)
end



--for mt5 (ansi)

OPEN={} HIGH={} LOW={} CLOSE={} VOLUME={}
local i=1
for line in io.lines("USDTRYH1.csv") do
    local date, open, high, low, close, volume,io_ = 
    line:match("%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.-),%s*(.+),")
    OPEN[i]=open HIGH[i]=high LOW[i]=low CLOSE[i]=close VOLUME[i]=volume
    i=i+1
end

for k, v in pairs(VOLUME) do
   print(k, v)
end
