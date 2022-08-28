---- Auto-enable fancy visualization for audio files in mpv if window/vo is forced/enabled
---- mpv lua api: manpage + https://github.com/mpv-player/mpv/blob/master/player/lua/defaults.lua

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


-- vis - visualization part, src - pre-exising part, *_disabled - flags to toggle each
local lavfi_vis_disabled, lavfi_vis, lavfi_src, lavfi_src_disabled = true
lavfi_src = mp.get_property('options/lavfi-complex') or ''

local function lavfi_vis_update(src_toggle)
	-- Sets mpv's --lavfi-complex option based on all lavfi_* vars above
	-- Optional src_toggle can be passed to toggle lavfi_src_disabled between true/false
	if src_toggle then lavfi_src_disabled = not lavfi_src_disabled end
	local lavfi = lavfi_src
	if lavfi_src_disabled or #lavfi == 0 then lavfi = 'acopy' end
	if lavfi_vis_disabled
		then lavfi = '[aid1] '..lavfi..' [ao]'
		else lavfi = '[aid1] '..lavfi..', '..(lavfi_vis or ' [ao]') end
	-- mp.msg.info('----- filter: '..lavfi)
	mp.set_property('options/lavfi-complex', lavfi)
end

local function lavfi_vis_init(force)
	---- Inits lavfi_vis filter sting if force=true or other vid/albumart and such are missing
	if lavfi_vis then return end

	-- Disable filter if there's no vo or it's being used for any other output
	if not mp.get_property_bool('vo-configured') then return end
	if not force then
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
	end

	-- Check for existing aid1->ao --lavfi-complex filter and include that in resulting pipeline
	-- Aborts if pipeline looks too complex to include in the resulting filter
	if lavfi_src and #lavfi_src > 0 then
		lavfi_src = lavfi_src:match('^ *%[ *aid1 *%] *(.-) *%[ *ao *%] *$')
	end
	if not lavfi_src then
		if not force then
			mp.msg.info( 'Non-trivial --lavfi-complex'..
				' ("[aid1] ... [ao]") used, audio visualization disabled' )
			return
		end
		lavfi_src = ''
	end

	-- Filter Docs: https://ffmpeg.org/ffmpeg-filters.html
	-- Fancy Examples: https://trac.ffmpeg.org/wiki/FancyFilteringExamples

	local size_bg = '960x768'
	local filter_bg = lavfi_filter_string{
		'showcqt', {
			fps = 30,
			size = size_bg,
			count = 2,
			--csp = 'bt709',
			bar_g = 2,
			sono_g = 4,
			bar_v = 9,
			sono_v = 17,
			font = "'Liberation Mono,Luxi Mono,Monospace|bold'", -- has to be monospace
			fontcolor = "'st(0, (midi(f)-53.5)/12);"..
				" st(1, 0.5 - 0.5 * cos(PI*ld(0))); r(1-ld(1)) + b(ld(1))'",
			tc = '0.33',
			tlength = "'st(0,0.17); 384*tc / (384 / ld(0)"..
				" + tc*f /(1-ld(0))) + 384*tc / (tc*f / ld(0) + 384 /(1-ld(0)))'" } }
		-- 'format=yuv420p' }

	local filter_fg = lavfi_filter_string{'showvolume', {
		w=960, h=20, dm=3,
		c='PEAK*255 + floor((1-PEAK)*255)*256 + 0xd06e0000' }}

	local overlay = lavfi_filter_string{'overlay', {format='yuv420'}}
	lavfi_vis = ' asplit=3 [ao][a1][a2];'..
		' [a1] '..filter_bg..' [v1]; [a2] '..filter_fg..' [v2]; [v1][v2] '..overlay..' [vo]'

	-- These opts help window to not blink size briefly when switching tracks
	mp.set_property('options/keepaspect', 'no')
	mp.set_property('options/geometry', size_bg)

	lavfi_vis_update()
end

local function lavfi_vis_toggle(state)
	-- Enables/disables visualization, initializing filter string if necessary
	if state ~= nil then lavfi_vis_disabled = not state
		else lavfi_vis_disabled = not lavfi_vis_disabled end
	if not lavfi_vis_disabled and not lavfi_vis
		then lavfi_vis_init(true) else lavfi_vis_update() end
end


---- Signals to tweak vis via hotkeys or player frontend (see e.g. emacs-setup/core/fg_emms.el)
---- Hotkey spec example: shift+y script-message fg.lavfi-audio-vis.af.src
mp.register_script_message('fg.lavfi-audio-vis.on', function() lavfi_vis_toggle(true) end)
mp.register_script_message('fg.lavfi-audio-vis.off', function() lavfi_vis_toggle(false) end)
mp.register_script_message('fg.lavfi-audio-vis.toggle', function() lavfi_vis_toggle() end)
mp.register_script_message('fg.lavfi-audio-vis.af.src', function() lavfi_vis_update(true) end)


---- Extra --lavfi-complex audio filters to toggle
local lavfi_src_orig = lavfi_src

--- Custom filter string to use with visualization and easy on/off toggle for testing

mp.register_script_message('fg.lavfi-audio-vis.af', function(af)
	lavfi_src_disabled = false
	if not af or af:find('^ *$') then lavfi_src = lavfi_src_orig else lavfi_src = af end
	lavfi_vis_update()
end)

--- "Sound through wall" filter, leaving only low-freq thuds and some resonating mid-range freqs
-- Much lower volume overall, but retaining rythm, so can be used instead of full mute
-- Resulting firequalizer plot: enable dumpfile there +
--  gnuplot -p -e 'set xlabel "freq"; set ylabel "gain"; set grid;
--    set xrange [20:2000]; set logscale x 10; plot "/tmp/mpv-firequalizer.plot" index 1'
local lavfi_src_wall = lavfi_filter_string{
	'firequalizer', {
		-- dumpfile = '/tmp/mpv-firequalizer.plot',
		gain = "'cubic_interpolate(f)'",
		gain_entry = "'entry(20,-10);entry(50,-2);entry(90,0);entry(140,-4)"..
			";entry(380,-18);entry(500,-20);entry(1000,-16);entry(2500,-26);entry(5000,-50)'",
		multi = 'on' },
	'compand', {attacks='.3 .3', decays='.8 .8', points='-70/-70 -60/-20 1/0', gain=-6, delay=.3} }

mp.register_script_message('fg.lavfi-audio-vis.af.wall', function()
	lavfi_src_disabled = false
	if lavfi_src ~= lavfi_src_wall
		then lavfi_src = lavfi_src_wall else lavfi_src = lavfi_src_orig end
	lavfi_vis_update()
end)


---- Initial state, depending on --vo/--force-window + --vid and such in lavfi_vis_init(force=nil)
if str_split(mp.get_property('vo'), '[^,]+')[1] ~= 'null'
	and ({yes=1, immediate=1})[mp.get_property('force-window')]
then
	lavfi_vis_disabled = false
	mp.add_hook('on_preloaded', 50, function() lavfi_vis_init() end)
-- else mp.msg.error('audio-vis disabled') end
end
