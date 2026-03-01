local EFFECTS_CAP = 100
local EFFECTS_DONE = nil
local FAST_FORWARD = nil
local GAMESPEED = nil

local reset = function()
    EFFECTS_DONE = 0
    FAST_FORWARD = false
    GAMESPEED = G.SETTINGS.GAMESPEED
end

reset()

UTILS._g_func_wrap('card_eval_status_text', function(super, ...)
    EFFECTS_DONE = EFFECTS_DONE + 1
    if EFFECTS_DONE < EFFECTS_CAP then
        super(...)
    elseif not FAST_FORWARD then
        FAST_FORWARD = true
        G.SETTINGS.GAMESPEED = GAMESPEED * 4
    end
end)

UTILS._g_func_wrap('delay', function(super, ...)
    if not FAST_FORWARD then
        super(...)
    end
end)

UTILS._g_func_wrap('update_hand_text', function(super, config, vals)
    if FAST_FORWARD then
        config.immediate = true
        config.delay = 0
        config.blocking = false
        vals.StatusText = false
    end

    return super(config, vals)
end)

UTILS._g_func_wrap('attention_text', function(super, ...)
    if not FAST_FORWARD then
        super(...)
    end
end)

UTILS.func_wrap(Event, 'init', function(super, self, ...)
    super(self, ...)
    if FAST_FORWARD then
        self.blocking = false
        self.blockable = false
        if self.trigger == 'ease' then
            self.delay = 0.0001
        else
            self.delay = 0
        end
    end
end)

UTILS._g_func_wrap('evaluate_play_intro', function(super, ...)
    reset()
    return super(...)
end)

UTILS._g_func_wrap('evaluate_play_after', function(super, ...)
    local res = super(...)
    G.SETTINGS.GAMESPEED = GAMESPEED
    reset()
    return res
end)
