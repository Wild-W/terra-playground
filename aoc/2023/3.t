local c = terralib.includecstring [[
    #include <stdio.h>
    #include <stdlib.h>
]]

local ErrType = {
    NONE = 0,
    FILE_NOT_FOUND = 1,
}

terra main(): int32
    var file: &c.FILE = c.fopen("./3.txt", "r")
    if file == nil then
        c.puts("Could not find ./3.txt!")
        return ErrType.FILE_NOT_FOUND
    end
    
    while true do
        var ch: int32 = c.getc(file)
        if ch == 
        if ch == -1 then
            break
        end

    end

    c.fclose(file)
    --if ch ~= nil then c.free(ch) end
    return ErrType.NONE
end

terralib.saveobj("3.exe", "executable", { main = main })
