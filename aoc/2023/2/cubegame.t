-- The Elf would first like to know which games would have been
-- possible if the bag contained only `12` red cubes,
-- `13` green cubes, and `14` blue cubes?

local inspect = require "../lib/inspect"

local function cube_expr(self, lex)
    local games = {}

    lex:expect("cubes")
    while not lex:matches("end") do
        -- Game <game_id>:
        lex:expect("Game")
        local game_id = lex:expect(lex.number).value
        games[game_id] = {}
        lex:expect(":")

        repeat
            -- <count> <var_name>,
            repeat
                local count = lex:expect(lex.number).value
                local var_name = lex:next().value
                lex:ref(var_name)

                if games[game_id][var_name] == nil or count > games[game_id][var_name] then
                    games[game_id][var_name] = count
                end
            until not lex:nextif(",")
        until not lex:nextif(";")
    end

    lex:expect("end")

    return function (environment_function)
        local env = environment_function()
        local score = 0

        for game_id, game in pairs(games) do
            local valid = true
            for var_name, count in pairs(game) do
                if count > env[var_name] then
                    valid = false
                    break
                end
            end
            if valid then
                score = score + game_id
            end
        end

        return score
    end
end

local cubegame = {
    name = "cubegame";
    entrypoints = { "cubes" };
    keywords = { "Game" };
    expression = cube_expr;
}

return cubegame