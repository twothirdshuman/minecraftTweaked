
local res = http.get("https://query1.finance.yahoo.com/v8/finance/chart/%5EOMX?interval=5m&range=5d", {
    ["User-Agent"] = "Mozilla/5.0 (Minecraft 21.0.1) Stonks/1.0.0"
})

print(textutils.serialise(res.getResponseHeaders()))
print(res.readAll())
