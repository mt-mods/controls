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

--set up key store on join
minetest.register_on_joinplayer(function(player, _)
    local pname = player:get_player_name()
    local controls_names = player:get_player_control()

    --note: could hardcode this, but this is more future proof in case minetest adds more controls
    controls.players[pname] = {}
    for key, _ in pairs(controls_names) do
        --[[
            in theory the control value is false when they join, but hard coding just in case
            consider changing this to named key table instead of numeric for better readability???
        ]]
        controls.players[pname][key] = {false}
    end
end)

--discard when leaving
minetest.register_on_leaveplayer(function(player, _)
    local pname = player:get_player_name()
    controls.players[pname] = nil
end)

--event loop
minetest.register_globalstep(function(dtime)
    for _, player in pairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local pcontrols = player:get_player_control()

        if not controls.players[pname] then break end --safety check

        --consider using minetest.get_us_time() instead of os.clock()? would need to convert to seconds however
        for key, key_status in pairs(pcontrols) do
            if key_status and controls.players[pname][key][1]==false then
                for _, callback in pairs(controls.registered_on_press) do
                    callback(player, key)
                end
                controls.players[pname][key] = {true, os.clock()}
            elseif key_status and controls.players[pname][key][1]==true then
                for _, callback in pairs(controls.registered_on_hold) do
                    callback(player, key, os.clock() - controls.players[pname][key][2])
                end
            elseif not key_status and controls.players[pname][key][1]==true then
                for _, callback in pairs(controls.registered_on_release) do
                    callback(player, key, os.clock() - controls.players[pname][key][2])
                end
                controls.players[pname][key] = {false}
            end
        end
    end
end)

--tests
if(controls.testsmode) then
    dofile(controls.modpath .. "/test.lua")
end