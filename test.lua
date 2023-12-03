controls.register_on_press(function(player, key)
    minetest.chat_send_all(player:get_player_name() .. " pressed " .. key)
end)

controls.register_on_hold(function(player, key, length)
    minetest.chat_send_all(player:get_player_name() .. " held " .. key .. " for " .. length .. " seconds")
end)

controls.register_on_release(function(player, key, length)
    minetest.chat_send_all(player:get_player_name() .. " released " .. key .. " after " .. length .. " seconds")
end)

minetest.register_on_joinplayer(function(player, _)
    local pname = player:get_player_name()
    minetest.chat_send_player(pname, #controls.registered_on_press .. " registered_on_press callbacks")
    minetest.chat_send_player(pname, #controls.registered_on_hold .. " registered_on_hold callbacks")
    minetest.chat_send_player(pname, #controls.registered_on_release .. " registered_on_release callbacks")
end)