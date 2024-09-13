local stdio = terralib.includec("stdio.h")

terra get_calibration_value(line: &uint8, length: int32): int32
    var digit_chars: uint8[2]
    var first_chosen: bool = false
    var second_chosen: bool = false

    for i = 0, length do
        var val: uint8 = line[i] - 48
        if val < 10 then
            if not first_chosen then
                digit_chars[0] = val
                first_chosen = true
            else
                digit_chars[1] = val
                second_chosen = true
            end
        end
    end

    if not second_chosen then digit_chars[1] = digit_chars[0] end

    var result: int32 = 0
    for i = 0, 2 do
        result = 10 * result + digit_chars[i]
    end

    stdio.printf("(%d, %d) = %d\n", digit_chars[0], digit_chars[1], result)

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
