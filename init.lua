controls = {
    --util values
    modpath = minetest.get_modpath("controls"),
    testsmode = minetest.settings:get_bool("controls_enable_tests", false),

    --location to store callbacks
    registered_on_press = {},
    registered_on_hold = {},
    registered_on_release = {},

    --store player control data
    players = {},
}

--api functions
function controls.register_on_press(callback)
    table.insert(controls.registered_on_press, callback)
end

function controls.register_on_hold(callback)
    table.insert(controls.registered_on_hold, callback)
end

function controls.register_on_release(callback)
    table.insert(controls.registered_on_release, callback)
end

minetest.register_on_joinplayer(function(player, _)
    local pname = player:get_player_name()
    local controls_names = player:get_player_control()

    --note: could hardcode this, but this is more future proof in case minetest adds more controls
    controls.players[pname] = {}
    for key, _ in pairs(controls_names) do
        controls.players[pname][key] = {false} --in theory its false when they join, but hard coding just in case
    end
end)

--tests
if(controls.testsmode) then
    dofile(controls.modpath .. "/test.lua")
end