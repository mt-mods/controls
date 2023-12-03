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
            if key_status and not controls.players[pname][key][1] then
                for _, callback in pairs(controls.registered_on_press) do
                    callback(player, key)
                end
                controls.players[pname][key] = {true, os.clock()}
            elseif key_status and controls.players[pname][key][1] then
                for _, callback in pairs(controls.registered_on_hold) do
                    callback(player, key, os.clock() - controls.players[pname][key][2])
                end
            elseif not key_status and controls.players[pname][key][1] then
                for _, callback in pairs(controls.registered_on_release) do
                    callback(player, key, os.clock() - controls.players[pname][key][2])
                end
                controls.players[pname][key] = {false}
            end
        end
    end
end)

--special keys
minetest.register_on_mods_loaded(function()
    for name, def in pairs(minetest.registered_nodes) do
        local old_node_drop = def.on_drop
        local on_drop = function(itemstack, dropper, ...)
            for _, callback in pairs(controls.registered_on_press) do
                callback(dropper, "_drop")
            end
            return old_node_drop(itemstack, dropper, unpack({...}))
        end
        minetest.override_item(name, {
            on_drop = on_drop
        })
    end

    local old_reg_node = minetest.register_node
    function minetest.register_node(name, def)
        if def.on_drop then
            local old_node_drop = def.on_drop
            def.on_drop = function(itemstack, dropper, ...)
                for _, callback in pairs(controls.registered_on_press) do
                    callback(dropper, "_drop")
                end
                return old_node_drop(itemstack, dropper, unpack({...}))
            end
        else
            def.on_drop = function(itemstack, dropper, ...)
                for _, callback in pairs(controls.registered_on_press) do
                    callback(dropper, "_drop")
                end
                return minetest.item_drop(itemstack, dropper, unpack({...}))
            end
        end

        old_reg_node(name, def)
    end
end)

--tests
if(controls.testsmode) then
    dofile(controls.modpath .. "/test.lua")
end