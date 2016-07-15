function atsl(s) status_line = status_line .. s end
function mpn(k, def) return mp.get_property_number(k, def or 0) end

function bts(bytes, dn, units)
	units = units or {'B', 'K', 'M', 'G', 'T'}
	for n, u in ipairs(units) do
		n = n + (dn or 0)
		if (bytes >= 10 * 2^((n-1)*10)) and (bytes < 10 * 2^(n*10))
			then return bytes / 2^((n-1)*10), u
		end
	end
	return bytes, ''
end

function bts_str(bytes, fmt, ...)
	local v, u = bts(bytes, ...)
	return string.format(fmt or '%.0f%s', v, u)
end


function update_status_line()
	status_line = ''

	if mp.get_property_bool('pause') then atsl('(Paused) ')
	elseif mp.get_property_bool('paused-for-cache')
		then atsl(string.format('(Buffering - %d%%) ', mpn('cache-buffering-state')))
	end

	if mp.get_property('vid') ~= 'no' then atsl('V') end
	if mp.get_property('aid') ~= 'no' then atsl('A') end

	atsl(': ')

	atsl(mp.get_property_osd('time-pos'))

	atsl(' / ');
	atsl(mp.get_property_osd('duration'));

	atsl(' (')
	atsl(mp.get_property_osd('percent-pos', -1))
	atsl('%)')

	local r = mpn('speed', -1)
	if r ~= 1 then atsl(string.format(' x%4.2f', r)) end

	-- r = mpn('avsync', nil)
	-- if r ~= nil then atsl(string.format(' A-V: %7.3f', r)) end

	-- r = mp.get_property('total-avsync-change', 0)
	-- if math.abs(r) > 0.05 then atsl(string.format(' ct:%7.3f', r)) end

	r = mpn('drop-frame-count', -1)
	if r > 0 then atsl(' Late: ' .. r) end

	local brs = {}
	r = mpn('video-bitrate')
	if r then brs[#brs+1] = 'V:' .. bts_str(r / 8) end
	r = mpn('audio-bitrate')
	if r then brs[#brs+1] = 'A:' .. bts_str(r / 8) end
	local cs = mpn('cache-size')
	r = mpn('cache')
	if r > 95 then r = '>95%' else r = string.format('%3d%%', r) end
	atsl(string.format(
		' -- %s: %s %s [B/s %s]',
		(mp.get_property('cache-idle') == 'yes') and 'cached ' or 'caching',
		r, bts_str(cs, nil, -1), table.concat(brs, ' ') ))

	mp.set_property('options/term-status-msg', status_line)
end


mp.register_event('tick', update_status_line)
