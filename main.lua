local config = require("config")
-- Calculate expected wait time
local expectedWaitTime = 0
for _,o in pairs(config.sites) do
    expectedWaitTime = expectedWaitTime + o.waitTime + 3 + 5 -- 3 seconds for starting up and shutting down the browser and 5 seconds for the upload
end

print("Expecting that it takes " .. expectedWaitTime .. " seconds to save all the screenshots to your reMarkable.")

for _,o in pairs(config.sites) do
    print("Starting " .. o.fileName .. " (" .. o.url .. ")")
    local expectedWaitTime = o.waitTime + 3 + 5
    
    print("Making screenshot (approximately " .. expectedWaitTime .. " seconds)")
    os.execute("python3 screenshot.py " .. o.url .. " \"" .. o.fileName .. ".png\" " .. o.waitTime)
    
    print("Converting to PDF")
    os.execute("convert \"tmp/" .. o.fileName .. ".png\" \"tmp/" .. o.fileName .. ".pdf\"")

    local localFile = " \"tmp/" .. o.fileName .. ".pdf\""
    local remarkFile = " \"" .. o.fileName .. "\""

    print("Copying " .. localFile .. " to " .. remarkFile)
    if config.overwrite then
        os.execute("rmapi rm " .. remarkFile)
    end
    os.execute("rmapi put " .. localFile)
    print("Finished " .. o.fileName .. " (" .. o.url .. ")")
end
