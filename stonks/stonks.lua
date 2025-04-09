local output = term -- assuming term is a valid peripheral
---@type number, number
local width, height = output.getSize()

---@class Stock
---@field currency string 
---@field symbol string 
---@field prices number[]

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
        prices = data.chart.result[1].indicators.quote[1].close
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
local function drawToScreen(stockData) 
    local min, max = getMinMax(stockData.prices)
    local blockSizeValue = (max - min) / (height - 1)

    for x=1, width do
        local index = math.floor(#stockData.prices * ((x - 1) / (width - 1))) + 1
        local priceToDraw = stockData.prices[index]
        if priceToDraw == nil then
            print(#stockData.prices)
            print(index)
        end
        local y = math.floor(((priceToDraw - min) / blockSizeValue) + 0.5) -- rounds
        local drawY = -y + height

        paintutils.drawPixel(x, drawY, colors.green)
    end
end

drawToScreen(getStockData("^OMX", "5m", "5d"))