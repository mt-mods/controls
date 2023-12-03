controls = {
    modpath = minetest.get_modpath("controls"),
    testsmode = minetest.settings:get_bool("controls_enable_tests", false)
}

--api functions
function controls.register_on_press(callback)

end

function controls.register_on_hold(callback)

end

function controls.register_on_release(callback)

end

if(controls.testsmode) then
    dofile(controls.modpath .. "/test.lua")
end