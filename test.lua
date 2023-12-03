controls.register_on_press(function(player, key)
    minetest.chat_send_all(player:get_player_name() .. " pressed " .. key)
end)

controls.register_on_hold(function(player, key, length)
    minetest.chat_send_all(player:get_player_name() .. " held " .. key .. " for " .. length .. " seconds")
end)

controls.register_on_release(function(player, key, length)
    minetest.chat_send_all(player:get_player_name() .. " released " .. key .. " after " .. length .. " seconds")
end)