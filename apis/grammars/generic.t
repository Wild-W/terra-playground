local function generic_statement(self, lex)
    lex:expect("generic")
    lex:expect("<")
    local type_var = lex:expect(lex.name).value
    lex:expect(">")
    local func_var = lex:expect(lex.name).value
    lex:expect("=")
    local expr_fn = lex:luaexpr()
    return function(environment_function)
        return function(actual)
            local env = environment_function()
            
            local impl = terralib.memoize(function (T)
                return expr_fun(env)
            end)

            return macro(function (...)
                local args = { ... }
                return `[impl(args[1]:gettype())](...)
            end), { func_var }
        end
    end
end

local generic = {
    name = "generic";
    entrypoints = { "generic" };
    keywords = { };
    statement = generic_statement;
    localstatement = generic_statement;
}

return generic