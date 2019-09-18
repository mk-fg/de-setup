-- Auto-enable fancy visualization for audio files in mpv if window/vo is forced/enabled
-- https://github.com/mpv-player/mpv/blob/master/player/lua/defaults.lua

local function str_split(str, pat)
	local res = {}
	str:gsub(pat, function(x) res[#res+1]=x end)
	return res
end

local function lavfi_filter_string(spec)
	local filter_name, filter_str = nil, {}
	for _,fx in ipairs(spec) do
		local fx_str = type(fx) == 'string'
		-- mp.msg.info('----- fx: ', fx, fx_str, filter_name)
		if fx_str then
			if filter_name then filter_str[#filter_str+1] = filter_name end
			filter_name = fx
		elseif not filter_name then
			mp.msg.error('skipping filter spec without preceding name:', fx)
		else
			if fx[1] then fx = table.concat(fx, ' : ')
			else
				fx, fx_str = {}, fx
				for k,v in pairs(fx_str) do fx[#fx+1] = k..'='..tostring(v) end
			end
			filter_name, filter_str[#filter_str+1] =
				nil, filter_name..' = '..table.concat(fx, ' : ')
		end
	end
	if filter_name then filter_str[#filter_str+1] = filter_name end
	return table.concat(filter_str, '  ,  ')
end

local function lavfi_vis_for_audio()
	-- Disable filter if there's no vo or it's being used for any other output
	if not mp.get_property_bool('vo-configured') then return end

	local aid_n, vid_n, art_n = 0, 0, 0
	local track_n = mp.get_property_number('track-list/count', -1)
	if track_n <= 0 then return end

	for n = 0, track_n - 1 do
		if mp.get_property('track-list/'..n..'/type') == 'audio' then aid_n = aid_n + 1
		elseif mp.get_property('track-list/'..n..'/type') == 'video' then
			if mp.get_property('track-list/'..n..'/albumart') == 'yes'
			then art_n = art_n + 1
			else vid_n = vid_n + 1 end
		end
	end

	if vid_n > 0 then return end

	-- vis - visualization part, src - pre-exising part, src_disabled - flag to toggle the former
	local lavfi_vis, lavfi_src, lavfi_src_disabled
	local function lavfi_update(src_toggle)
		if src_toggle then lavfi_src_disabled = not lavfi_src_disabled end
		src_toggle = '[aid1]'..(lavfi_src_disabled and '' or lavfi_src or '')..lavfi_vis
		-- mp.msg.info('----- filter: '..src_toggle)
		mp.set_property('options/lavfi-complex', src_toggle)
	end

	-- Check for existing aid1->ao --lavfi-complex filter and include that in resulting pipeline
	-- Aborts if pipeline looks too complex to include in the resulting filter
	-- Note the dynamic keybinding for toggling pre-vis filter (if any), it should override input.conf
	lavfi_src = mp.get_property('options/lavfi-complex') or ''
	if lavfi_src and #lavfi_src > 0 then
		lavfi_src = lavfi_src:match('^ *%[ *aid1 *%] *(.-) *%[ *ao *%] *$')
	end
	if not lavfi_src then
		mp.msg.info('Non-trivial --lavfi-complex ("[aid1] ... [ao]") used, audio visualization disabled')
		return
	elseif #lavfi_src > 0 then
		lavfi_src = ' '..lavfi_src..','
		mp.add_key_binding('y', function() lavfi_update(true) end)
	end

	-- Filter Docs: https://ffmpeg.org/ffmpeg-filters.html
	-- Fancy Examples: https://trac.ffmpeg.org/wiki/FancyFilteringExamples

	local filter_bg = lavfi_filter_string{
		'firequalizer', {
			-- better than using sono_v = 9 * b_weighting(f)
			gain = "'20/log(10)*log(1.4884e8 * f*f*f / (f*f + 424.36) / (f*f + 1.4884e8) / sqrt(f*f + 25122.25))'",
			accuracy = 1000, -- accuracy bounded by delay
			zero_phase = 'on' },
		'showcqt', {
			fps = 30,
			size = '960x768',
			count = 2,
			--csp = 'bt709',
			bar_g = 2,
			sono_g = 4,
			bar_v = 9,
			sono_v = 17,
			font = "'Liberation Mono,Luxi Mono,Monospace|bold'", -- has to be monospace
			fontcolor = "'st(0, (midi(f)-53.5)/12); st(1, 0.5 - 0.5 * cos(PI*ld(0))); r(1-ld(1)) + b(ld(1))'",
			tc = '0.33',
			tlength = "'st(0,0.17); 384*tc / (384 / ld(0) + tc*f /(1-ld(0))) + 384*tc / (tc*f / ld(0) + 384 /(1-ld(0)))'" } }
		-- 'format=yuv420p' }
	local filter_fg = lavfi_filter_string{ 'avectorscope',
		{mode='lissajous_xy', size='960x200', rate=30, scale='cbrt', draw='dot', zoom=1.5} }

	local overlay = lavfi_filter_string{'overlay', {format='yuv420'}}
	lavfi_vis = ' asplit=3 [ao][a1][a2]; [a1] '..
		filter_bg..' [v1]; [a2] '..filter_fg..' [v2]; [v1][v2] '..overlay..' [vo]'

	-- local filter = lavfi_filter_string{ 'showspectrum',
	-- 	{size='960x758', color='channel', scale='cbrt', orientation='vertical', overlap=1} }
	-- local filter = lavfi_filter_string{'showwaves', {size='960x384', rate=60, mode='point', n=10, scale='lin'}}
	-- local lavfi = '[aid1] asplit [ao][vis]; [vis]'..filter..'[vo]'
	-- local lavfi = '[aid1] asplit=3 [ao][a1][a2]; [a1]'..filter1..'[v1]; [a2]'..filter2..'[v2]; [v1][v2] vstack [vo]'

	lavfi_update()
end

if str_split(mp.get_property('vo'), '[^,]+')[1] ~= 'null'
	and ({yes=1, immediate=1})[mp.get_property('force-window')]
then mp.add_hook('on_preloaded', 50, lavfi_vis_for_audio) end
-- else mp.msg.error('audio-vis disabled') end
