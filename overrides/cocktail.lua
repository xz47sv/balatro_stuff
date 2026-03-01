MP.get_cocktail_decks = function(cull)
	local ret = {}
	local forced = {}
	for k, v in pairs(G.P_CENTERS) do
		if v.set == "Back"
            and not v.omit
            and k ~= "b_challenge"
            and k ~= "b_mp_cocktail"
        then
			ret[#ret + 1] = k
		end
	end
	table.sort(ret, function(a, b)
		return (G.P_CENTERS[a].order or 0) < (G.P_CENTERS[b].order or 0)
	end)
	if cull then
		local _ret = {}
		for i, v in ipairs(ret) do
			if MP.cocktail_cfg_readpos(i, true) == "1" then
				_ret[#_ret + 1] = ret[i]
			elseif MP.cocktail_cfg_readpos(i, true) == "2" then
				forced[#forced + 1] = ret[i]
			end
		end
		ret = _ret
	end
	return ret, forced
end
