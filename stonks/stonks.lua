local monitor, ticker, interval, range = ... 

local output = peripheral.wrap(monitor) 
---@type number, number
output.setTextScale(1.5)
local width, height = output.getSize()
local function clear() 
    for x=1, width do
        for y=1, height do
            output.clear()
            -- paintutils.drawPixel(x, y, colors.black)
        end
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

    local prices = {}
    for i=1,#data.chart.result[1].indicators.quote[1].close do 
        if data.chart.result[1].indicators.quote[1].close[i] == nil then
            for j=i,1,-1 do
                if data.chart.result[1].indicators.quote[1].close[j] ~= nil then
                    table.insert(prices, data.chart.result[1].indicators.quote[1].close[j])
                    break
                end
            end
        else 
            table.insert(prices, data.chart.result[1].indicators.quote[1].close[i])
        end
    end

    ---@type Stock
    local ret = {
        currency = data.chart.result[1].meta.currency,
        symbol = data.chart.result[1].meta.symbol,
        prices = prices,
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
    output.setCursorPos(1, 1)
    output.setTextColor(colors.white)
    output.write(stockData.name)
    output.write(" "..stockData.symbol)
    output.write(" ")
    local min, max = getMinMax(stockData.prices)
    output.setTextColor(colors.red)
    output.write(tostring(math.floor(min)))
    output.write(" ")
    output.setTextColor(colors.green)
    output.write(tostring(math.floor(max)))
    output.write(" ")
    output.setTextColor(colors.white)
    output.write("in "..stockData.currency)
    output.write(" ")

    if stockData.prices[1] > stockData.prices[#stockData.prices] then
        output.write("DOWN")
        local multiply = stockData.prices[1] / stockData.prices[#stockData.prices]
        local percent = math.abs(multiply - 1) * 100
        output.setTextColor(colors.red)
        output.write(" "..string.sub(tostring(percent), 1, 4).."% ")
    else 
        output.write("UP")
        local multiply = stockData.prices[1] / stockData.prices[#stockData.prices]
        local percent = math.abs(multiply - 1) * 100
        output.setTextColor(colors.green)
        output.write(" "..string.sub(tostring(percent), 1, 4).."% ")
    end
end

---@param stockData Stock
local function drawToScreen(stockData)
    clear()
    writeFirstLine(stockData)
    local min, max = getMinMax(stockData.prices)
    local blockSizeValue = (max - min) / (height - 1)
    local mainColor = colors.green
    if stockData.prices[1] > stockData.prices[#stockData.prices] then
        mainColor = colors.red
    end

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
        if drawY == 1 then
            drawY = 2
        end

        for tmp=drawY, height do
            output.setTextColor(mainColor)
            output.setCursorPos(x, tmp)
            output.write(" ")
            -- paintutils.drawPixel(x, tmp, mainColor)
        end
    end
end



while true do
    drawToScreen(getStockData(ticker, interval, range))
    sleep(600)
end