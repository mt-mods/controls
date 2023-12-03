# api

```lua
controls.register_on_press(function(player, key)
    -- called on key down
    -- @player: player object
    -- @key: key pressed
end)

controls.register_on_hold(function(player, key, length)
    -- called while key is held
    -- @player: player object
    -- @key: key pressed
    -- @length: length of time key was held in seconds
end)

controls.register_on_release(function(player, key, length)
    -- called on key up
    -- @player: player object
    -- @key: key pressed
    -- @length: length of time key was held in seconds
end)
```

# keys

supports all the keys minetest does  

special keys:
```
@_drop: called when a player drops an item (note: only supported in register_on_press api method)
```