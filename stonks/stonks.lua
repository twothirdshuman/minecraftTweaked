local output = term -- assuming term is a valid peripheral
---@type number, number
local width, height = output.getSize()

for x=1, width do
    for y=1, height do
        paintutils.drawPixel(x, y, colors.black)
    end
end

---@class Stock
---@field currency string 
---@field symbol string 
---@field prices number[]
---@field name string

---@param ticker string
---@param interval string
---@param range string
---@return Stock
local function getStockData(ticker, interval, range)
    local url = string.format("https://query1.finance.yahoo.com/v8/finance/chart/%s?interval=%s&range=%s",
        textutils.urlEncode(ticker), interval, range)

    local res = http.get(url, {
        ["User-Agent"] = "Mozilla/5.0 (Minecraft 21.0.1) Stonks/1.0.0"
    })

    if not res then error("Failed to fetch data") end

    local resText = res.readAll()
    local data = textutils.unserializeJSON(resText)

    ---@type Stock
    local ret = {
        currency = data.chart.result[1].meta.currency,
        symbol = data.chart.result[1].meta.symbol,
        prices = data.chart.result[1].indicators.quote[1].close,
        name = data.chart.result[1].meta.shortName
    }

    return ret
end

--- comment
--- @param nums number[]
local function getMinMax(nums) 
    local max = nums[1]
    local min = nums[1]

    for i=1, #nums do
        if nums[i] > max then
            max = nums[i]
        end
        if nums[i] < min then
            min = nums[i]
        end
    end

    return min, max
end

---@param stockData Stock
local function writeFirstLine(stockData) 
    term.setCursorPos(1, 1)
    term.setTextColor(colors.white)
    term.write(stockData.name)
    term.write(" "..stockData.symbol)
    local min, max = getMinMax(stockData.prices)
    term.setTextColor(colors.red)
    term.write(tostring(math.floor(min)))
    term.write(" ")
    term.setTextColor(colors.green)
    term.write(tostring(math.floor(max)))
    term.write(" ")
    term.setTextColor(colors.white)
    term.write("in "..stockData.currency)
end

---@param stockData Stock
local function drawToScreen(stockData) 
    writeFirstLine(stockData)
    local min, max = getMinMax(stockData.prices)
    local blockSizeValue = (max - min) / (height - 1)

    for x=1, width do
        local index = math.floor(#stockData.prices * ((x - 1) / (width - 1)))
        if index == 0 then
            index = 1
        end
        local priceToDraw = stockData.prices[index]
        if priceToDraw == nil then
            print(#stockData.prices)
            print(index)
        end
        local y = math.floor(((priceToDraw - min) / blockSizeValue) + 0.5) -- rounds
        local drawY = -y + height

        for tmp=drawY, height do
            paintutils.drawPixel(x, tmp, colors.green)
        end
    end
end

drawToScreen(getStockData("^OMX", "5m", "5d"))