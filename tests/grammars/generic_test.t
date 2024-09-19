import "../../apis/grammars/generic"

local c = terralib.includecstring [[
    #include <stdio.h>
]]

local generic<T> times_three = terra (a: T)
    return a * 3
end

generic<J> fav_num = terra (from: rawstring, name: J)
    c.printf("%s's favorite number is %f", from, name)
end

terra add<T>(a: T, b: T)
    return a + b
end

local add_impl = terralib.memoize(function (T)
    return terra add(a: T, b: T)
        return a + b
    end
end)

add = macro(function (a, b)
    return `[add_impl(a:gettype())](arr, len)
end)

terra main()
    c.printf("%d", times_three(4))
    c.printf("%f", times_three(3.233))
end

main()