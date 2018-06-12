-- Fancy mpv status line formatter/setter

local status_line = ''

local function atsl(s) status_line = status_line..s; return true end
local function mpn(k, def) return mp.get_property_number(k, def or 0) end

local function bts(bytes, dn, units)
	for n, u in ipairs(units or {'B', 'K', 'M', 'G', 'T'}) do
		n = n + (dn or 0)
		if (bytes >= 10 * 2^((n-1)*10)) and (bytes < 10 * 2^(n*10))
		then return bytes / 2^((n-1)*10), u end
	end
	return bytes, ''
end

local function bts_str(bytes, fmt, ...)
	local v, u = bts(bytes, ...)
	return (fmt or '%.0f%s'):format(v, u)
end

local function update_status_line()
	status_line = ''

	if mp.get_property_bool('pause') then
		atsl('(Paused) ')
	elseif mp.get_property_bool('paused-for-cache') then
		atsl(('(Buffering - %d%%) '):format(mpn('cache-buffering-state')))
	elseif mp.get_property_bool('idle') or mp.get_property_bool('core-idle') then
		atsl('(Idle) ')
	end

	local r = false
	if mp.get_property('vid') ~= 'no' then r = atsl('V') end
	if mp.get_property('aid') ~= 'no' then r = atsl('A') end
	if mp.get_property('sid') ~= 'no' then r = atsl('S') end
	if not r then atsl('?') end

	atsl(': ')
	atsl(mp.get_property_osd('time-pos'))
	r = mp.get_property_osd('duration')
	if string.len(r) > 0 then
		atsl(' / ')
		atsl(r)
		atsl((' (%2d%%)'):format(mpn('percent-pos')))
	end

	r = mpn('speed', -1)
	if r ~= 1 then atsl((' x%4.2f'):format(r)) end

	-- Causes segfaults when used with lavfi-complex
	-- r = mpn('decoder-frame-drop-count', -1)
	-- if r > 0 then atsl(' Late: '..r) end

	r = mpn('playlist-count')
	if r > 1 then atsl((' [pls:%02d/%02d]'):format(mpn('playlist-pos-1'), r)) end

	local brs = {}
	r = mpn('video-bitrate')
	if r then brs[#brs+1] = 'V:'..bts_str(r / 8) end
	r = mpn('audio-bitrate')
	if r then brs[#brs+1] = 'A:'..bts_str(r / 8) end
	r = mpn('cache-percent')
	if r > 95 then r = '>95%' else r = ('%3d%%'):format(r) end
	atsl((' -- %s %s %2.0fs+%s/%s [B/s %s]'):format(
		(mp.get_property('cache-idle') == 'yes') and 'cached ' or 'caching',
		r, mpn('demuxer-cache-duration'),
		bts_str(mpn('cache-used'), nil, -1), bts_str(mpn('cache-size'), nil, -1),
		table.concat(brs, ' ') ))

	mp.set_property('options/term-status-msg', status_line)
end

mp.add_periodic_timer(0.5, update_status_line)
-- mp.register_event('tick', update_status_line)
