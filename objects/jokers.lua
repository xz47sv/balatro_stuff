SMODS.Atlas({
    key = 'bad_apple',
    atlas_table = 'ANIMATION_ATLAS',
    path = 'j_bad_apple.png',
    px = 71,
    py = 95,
    frames = 6555,
})

SMODS.Sound({
    key = 'music_bad_apple',
    path = 'music_bad_apple.mp3',
    sync = false,
    pitch = 1,
    select_music_track = function()
        return next(find_joker('ash_bad_apple')) and 200
    end
})

SMODS.Joker({
    key = 'bad_apple',
    name = 'ash_bad_apple',
    atlas = 'bad_apple',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pools = { Meme = true },
    rarity = 3,
    cost = 10,
    init = function(self)
        -- TODO: music
    end,
})

UTILS.func_wrap(AnimatedSprite, 'animate', function(super, self)
    if self.key ~= 'j_bad_apple' then
        super(self)
    end

    local fps = 30
    local cur_anim = self.current_animation
    local new_frame = math.floor(
        fps * (G.TIMERS.REAL - self.offset_seconds)
    ) % cur_anim.frames
    local frame_length = math.floor(self.image_dims[1] / self.animation.w)

    if new_frame ~= self.current_animation.current then
        cur_anim.current = new_frame % frame_length
        self.frame_offset = math.floor(self.animation.w * cur_anim.current)
        self.sprite:setViewport(
            self.frame_offset,
            self.animation.h * (
                self.animation.y + math.floor(new_frame / frame_length)
            ),
            self.animation.w,
            self.animation.h
        )
    end

    if self.float then
        self.T.r = 0.02 * math.sin(2 * G.TIMERS.REAL + self.T.x)
        self.offset.y = -(
            1 + 0.3 * math.sin(0.666 * G.TIMERS.REAL + self.T.y)
        ) * self.shadow_parrallax.y
        self.offset.x = -(
            0.7 + 0.2 * math.sin(0.666 * G.TIMERS.REAL + self.T.x)
        ) * self.shadow_parrallax.x
    end
end)
