-- https://stackoverflow.com/questions/24873859/lua-one-liner-to-read-entire-file
local file = io.open("/test")
local string = filllllle:read("*a")
file.close()
ngx.var.key = string
