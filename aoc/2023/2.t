local file = io.open("2.txt")
print(terralib.loadstring([[
import "2/cubegame"
local blue = 14
local red = 12
local green = 13
return cubes
]] .. file:read("*a") .. [[

end
]])())
file:close()
