-- Fancy mpv status line formatter/setter

local status_line, log_ts, log_pos
local log_td, log_td_pos = 5*60, 15*60

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

local function print_last_status()
	-- Used to persist playback position in the terminal on log_td intervals
	--   and on quit (pointless "Exiting..." line clobbers status since mpv 0.37.0)
	mp.msg.info(os.date('%F %T :: ')..(status_line or '-no-status-'))
end

local function update_status_line()
	status_line = ''

	if mp.get_property_bool('pause') then atsl('(Paused) ')
	elseif mp.get_property_bool('paused-for-cache') then
		atsl(('(Buffering - %d%%) '):format(mpn('cache-buffering-state')))
	elseif mp.get_property_bool('idle') or mp.get_property_bool('core-idle') then atsl('(Idle) ')
	elseif mp.get_property_bool('seeking') then atsl('(Seek) ')
	end

	-- When using lavfi-filters, aid/vid can be "no" with inputs/outputs there
	local r = false
	if mp.get_property('vid') ~= 'no'
		or mp.get_property('video-format') then r = atsl('V') end
	if mp.get_property('aid') ~= 'no'
		or mp.get_property('audio-params/format') then r = atsl('A') end
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

	r = mpn('decoder-frame-drop-count', -1)
	if r > 0 then atsl(' Late: '..r) end

	r = mpn('playlist-count')
	if r > 1 then atsl((' [pls:%02d/%02d]'):format(mpn('playlist-pos-1'), r)) end

	local brs = {}
	r = mpn('video-bitrate')
	if r then brs[#brs+1] = 'V:'..bts_str(r / 8) end
	r = mpn('audio-bitrate')
	if r then brs[#brs+1] = 'A:'..bts_str(r / 8) end
	atsl((' -- %s %2.0fs [B/s %s]'):format(
		(mp.get_property('demuxer-cache-idle') == 'yes') and 'cached ' or 'caching',
		mpn('demuxer-cache-duration'), table.concat(brs, ' ') ))

	mp.set_property('options/term-status-msg', status_line)

	local ts, pos = os.time(), mp.get_property_number('time-pos')
	if not log_ts then log_ts = ts end
	if not log_pos then log_pos = pos end
	if ts - log_ts > log_td and pos and pos - log_pos > log_td_pos
		then print_last_status(); log_ts, log_pos = ts, pos end
end

mp.add_periodic_timer(0.5, update_status_line)
mp.register_event('shutdown', print_last_status)
-- mp.register_event('tick', update_status_line)
