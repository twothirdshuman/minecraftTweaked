local output = term -- assuming term is a valid peripheral
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

local data = getStockData("^OMX", "5m", "5d")
local min, max = getMinMax(data.prices)
print(min)
print(max)