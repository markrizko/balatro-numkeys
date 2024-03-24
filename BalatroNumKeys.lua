--- STEAMODDED HEADER
--- MOD_NAME: Balatro Num Keys
--- MOD_ID: BalatroNumKeys
--- MOD_AUTHOR: [markrizko]
--- MOD_DESCRIPTION: V1.0.0 - Allows user to use number keys to select cards in hand


----------------------------------------------
------------MOD CODE -------------------------

local keyupdate_ref = Controller.key_press_update

function Controller.key_press_update(self, key, dt)
    keyupdate_ref(self, key, dt)
    keys_to_nums = {
        ["1"] = 1,
        ["2"] = 2,
        ["3"] = 3,
        ["4"] = 4,
        ["5"] = 5,
        ["6"] = 6,
        ["7"] = 7,
        ["8"] = 8,
        ["9"] = 9,
        ["0"] = 10,
        ["-"] = 11,
        ["="] = 12,
        ["kp1"] = 1,
        ["kp2"] = 2,
        ["kp3"] = 3,
        ["kp4"] = 4,
        ["kp5"] = 5,
        ["kp6"] = 6,
        ["kp7"] = 7,
        ["kp8"] = 8,
        ["kp9"] = 9,
        ["kp0"] = 10,
        ["kp-"] = 11,
        ["kp="] = 12,
    }
    keys_to_ui = {
        ["`"] = "clear hand",
        ["\\"] = "discard hand",
        ["return"] = "play hand",
        ["kp."] = "discard hand",
        ["kp*"] = "clear hand",
        ["kpenter"] = "play hand",
    }

    if G.STATE == G.STATES.SELECTING_HAND then
        if tableContains(keys_to_nums, key) then
            num = keys_to_nums[key]
            in_list = false
            if num <= #G.hand.cards then
                card = G.hand.cards[num]
                for i = #G.hand.highlighted, 1, -1 do
                    if G.hand.highlighted[i] == card then
                        in_list = true
                        break
                    end
                end
                if in_list then
                    G.hand:remove_from_highlighted(card, false)
                    play_sound('cardSlide2', nil, 0.3)
                else
                    G.hand:add_to_highlighted(card)
                end
            end
        end
        if tableContains(keys_to_ui, key) then
            ui = keys_to_ui[key]
            if ui == "clear hand" then
                queue_clear_key_pressed()
            elseif ui == "discard hand" then
                local discard_button = G.buttons:get_UIE_by_ID('discard_button')
                if discard_button.config.button == 'discard_cards_from_highlighted' then
                    G.FUNCS.discard_cards_from_highlighted()
                end
            elseif ui == "play hand" then
                local play_button = G.buttons:get_UIE_by_ID('play_button')
                if play_button.config.button == 'play_cards_from_highlighted' then
                    G.FUNCS.play_cards_from_highlighted()
                end
            end
        end
    end
end

function tableContains(table, key)
    for k, v in pairs(table) do
        if k == key then
            return true
        end
    end
    return false
end

function queue_clear_key_pressed(x, y)
    if not G.SETTINGS.paused and G.hand and G.hand.highlighted[1] then 
        if (G.play and #G.play.cards > 0) or
        (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then return end
        G.hand:unhighlight_all()
    end
end