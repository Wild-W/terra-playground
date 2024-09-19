local c = terralib.includecstring [[
    #include <stdio.h>
]]

local sort_impl = terralib.memoize(function (T)
    return terra (arr: &T, len: int)
        for i = 0, len do
            var min_idx = i
            for j = i + 1, len do
                if arr[min_idx] > arr[j] then
                    min_idx = j
                end
            end
            var temp = arr[i]
            arr[i] = arr[min_idx]
            arr[min_idx] = temp
        end
    end
end)

local sort = macro(function (arr, len)
    local arr_type = arr:gettype()
    if not arr_type:ispointer() and not arr_type:isarray() then
        error(string.format("bad argument #1 to 'sort' (expected pointer/array type, got %s)", arr_type))
    end
    return `[sort_impl(arr_type.type)](arr, len)
end)

local terra main(): int
    var arr = array(4, 6, 5, 2, -7, 8)
    sort(arr, 6)
    for i = 0, 6 do
        c.printf("%d ", arr[i])
    end
    c.puts("")
    var arr2 = array(4, 0.44, 1.000004, 87.3)
    [sort_impl(double)](arr2, 4)
    for i = 0, 4 do
        c.printf("%f ", arr2[i])
    end
    c.puts("")
    return 0
end

terralib.saveobj("selection_sort.exe", "executable", { main = main })