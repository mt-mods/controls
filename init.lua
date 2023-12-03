controls = {
    --util values
    modpath = minetest.get_modpath("controls"),
    testsmode = minetest.settings:get_bool("controls_enable_tests", false),

    --location to store callbacks
    registered_on_press = {},
    registered_on_hold = {},
    registered_on_release = {},
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

if(controls.testsmode) then
    dofile(controls.modpath .. "/test.lua")
end