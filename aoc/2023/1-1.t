local stdio = terralib.includec("stdio.h")
local cstring = terralib.includec("string.h")

terra get_calibration_value(line: &uint8, length: int32): int32
    var result: int32 = 0
    var second_digit: uint8 = 0
    var count: uint8 = 0

    for i = 0, length do
        var val: int32 = -1
        var line_digit: uint8 = line[i] - 48
        if line_digit < 10 then
            val = line_digit
        else
            if cstring.strncmp([&int8](line + i), "one", 3) == 0 then
                val = 1
                i = i + 3
            elseif cstring.strncmp([&int8](line + i), "two", 3) == 0 then
                val = 2
                i = i + 3
            elseif cstring.strncmp([&int8](line + i), "three", 5) == 0 then
                val = 3
                i = i + 5
            elseif cstring.strncmp([&int8](line + i), "four", 4) == 0 then
                val = 4
                i = i + 4
            elseif cstring.strncmp([&int8](line + i), "five", 4) == 0 then
                val = 5
                i = i + 4
            elseif cstring.strncmp([&int8](line + i), "six", 3) == 0 then
                val = 6
                i = i + 3
            elseif cstring.strncmp([&int8](line + i), "seven", 5) == 0 then
                val = 7
                i = i + 5
            elseif cstring.strncmp([&int8](line + i), "eight", 5) == 0 then
                val = 8
                i = i + 5
            elseif cstring.strncmp([&int8](line + i), "nine", 4) == 0 then
                val = 9
                i = i + 4
            end
        end

        if val ~= -1 then
            if count == 0 then
                result = result * 10 + val
                count = 1
            else
                second_digit = val
                count = 2
            end
        end
    end

    if count == 1 then
        result = result * 10 + result % 10
    else
        result = result * 10 + second_digit
    end

    stdio.printf("result = %d\n", result)

    return result
end

function string_to_byte_array(str)
    local byte_array = terralib.new(uint8[#str+1])
    for i = 1, #str do
        byte_array[i-1] = str:byte(i)
    end
    byte_array[#str] = 0
    return byte_array
end

local result = 0
for line in io.lines("./1.txt") do
    result = result + get_calibration_value(string_to_byte_array(line), #line)
end

print(result)
