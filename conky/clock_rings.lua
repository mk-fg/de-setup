-- Clock Rings + Binary Clock + File Readers + sensors + misc

-- Original Clock Rings by londonali1010 (2009) - edited by h0zza (2012)
-- [http://blog.hozzamedia.com/software/conky-resource-dialrings/]

-- Sunrise/Sunset script by 2012 Alexander Yakushev
-- https://github.com/alexander-yakushev/lustrous/blob/master/sunriseset.lua
-- Based on algorithm by United Stated Naval Observatory, Washington
-- Link: http://williams.best.vwh.net/sunrise_sunset_algorithm.htm


-- Settings

rings_ox=130
rings_oy=155

rings_colors = {
	cpu=0x0000aa,
	mem=0xffccee,
	swap=0xffaaaa,
	net_up=0x8f4444,
	net_down=0x446f44,
	fs_root=0xbdbb7b,
	fs_home=0xaabdb6,
}

rings_defaults = {
	bg_color=0xffffff,
	bg_alpha=0.2,
	fg_color=0xffffff,
	fg_alpha=0.4,
	x=rings_ox, y=rings_oy,
}

rings = {
	{
		-- Edit this table to customise your rings.  You can create more rings
		-- simply by adding more elements to this table.  "name" is the type of
		-- stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc',
		-- 'battery_used_perc'.
		name='time',
		-- "arg" is the argument to the stat type, e.g. if in Conky you would write
		-- ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an
		-- argument in the Conky variable, use ''.
		arg='%I.%M',
		-- "max" is the maximum value of the ring. If the Conky variable outputs a
		-- percentage, use 100.
		max=12,
		-- "bg_color" is the color of the base ring.
		bg_color=0xffffff,
		-- "bg_alpha" is the alpha value of the base ring.
		bg_alpha=0.1,
		-- "fg_color" is the color of the indicator part of the ring.
		fg_color=0xffffff,
		-- "fg_alpha" is the alpha value of the indicator part of the ring.
		fg_alpha=0.2,
		-- "x" and "y" are the x and y coordinates of the centre of the ring,
		-- relative to the top left corner of the Conky window.
		x=rings_ox, y=rings_oy,
		-- "radius" is the radius of the ring.
		radius=50,
		-- "thickness" is the thickness of the ring, centred around the radius.
		thickness=5,
		-- "start_angle" is the starting angle of the ring, in degrees, clockwise
		-- from top. Value can be either positive or negative.
		start_angle=0,
		-- "end_angle" is the ending angle of the ring, in degrees, clockwise from
		-- top. Value can be either positive or negative, but must be larger than
		-- start_angle.
		end_angle=360
	},
	{
		name='time',
		arg='%M.%S',
		max=60,
		bg_alpha=0.1,
		radius=56,
		thickness=5,
		start_angle=0,
		end_angle=360
	},
	{
		name='time',
		arg='%S',
		max=60,
		bg_alpha=0.1,
		fg_alpha=0.6,
		radius=62,
		thickness=5,
		start_angle=0,
		end_angle=360
	},
	{
		name='cpu',
		arg='cpu1',
		max=100,
		fg_color=rings_colors.cpu,
		fg_alpha=0.3,
		radius=75,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu2',
		max=100,
		fg_color=rings_colors.cpu,
		fg_alpha=0.3,
		radius=79,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu3',
		max=100,
		fg_color=rings_colors.cpu,
		fg_alpha=0.3,
		radius=83,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu4',
		max=100,
		fg_color=rings_colors.cpu,
		fg_alpha=0.3,
		radius=87,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu0',
		max=100,
		fg_color=rings_colors.cpu,
		fg_alpha=0.6,
		radius=93,
		thickness=6,
		start_angle=93,
		end_angle=208
	},
	{
		name='memperc',
		arg='',
		max=100,
		fg_color=rings_colors.mem,
		fg_alpha=0.5,
		radius=78,
		thickness=11,
		start_angle=212,
		end_angle=329
	},
	{
		name='swapperc',
		arg='',
		max=100,
		fg_color=rings_colors.swap,
		fg_alpha=0.5,
		radius=90,
		thickness=11,
		start_angle=212,
		end_angle=329
	},
	{
		name='upspeedf',
		arg='enp1s0',
		max=5000,
		fg_color=rings_colors.net_up,
		fg_alpha=0.3,
		radius=78,
		thickness=11,
		start_angle=-28,
		end_angle=90
	},
	{
		name='downspeedf',
		arg='enp1s0',
		max=5000,
		fg_color=rings_colors.net_down,
		fg_alpha=0.3,
		radius=90,
		thickness=11,
		start_angle=-28,
		end_angle=90
	},
	{
		name='fs_used_perc',
		arg='/',
		max=100,
		fg_color=rings_colors.fs_root,
		fg_alpha=0.5,
		radius=105,
		thickness=3,
		start_angle=-120,
		end_angle=-13
	},
	{
		name='fs_used_perc',
		arg='/home',
		max=100,
		fg_color=rings_colors.fs_home,
		fg_alpha=0.5,
		radius=105,
		thickness=3,
		start_angle=-10,
		end_angle=93
	},
}

bg_rings_y_offset = -10 -- shift/scale the thing up/down
bg_size = 250
bg = {
	x=rings_ox, y=rings_oy + bg_rings_y_offset,
	w=bg_size, h=bg_size + bg_rings_y_offset * 2,
	aspect=1.0, corner_radius=25,
	fill_color=0x080a08, fill_alpha=0.1,
	border_color=0x000000, border_alpha=0.1, border_width=2
}

clock = {
	r=40, x=rings_ox, y=rings_oy,
	color=0xffffff, alpha=0.5,
	show_seconds=true
}

clock_bin = {
	-- h=bg['h'], drawn to the right of the rings bg
	w=135, clock_offset=10, pad=20,
	block_offset=10,
	fill_color=0xeeaaaa, fill_alpha=0.5,
	border_color=0xffffff, border_alpha=0.3, border_width=1
}

file_cap = {
	values=nil,
	glob_cmd="dash -c 'echo /sys/class/power_supply/*/'", glob_dirs=nil,
	ts_glob_i=600, ts_glob=0,
	ts_read_i=120, ts_read=0,
}

sensors = {
	values=nil,
	cmd="sens",
	ts_read_i=120, ts_read=0,
}

sunrise = {
	offset=5, -- from UTC, hours
	lat=56.833,
	lon=60.583,
	zenith=90.83,
}


require 'cairo'
require 'cairo_xlib'


local function rgb_to_r_g_b(color,alpha)
	return ((color / 0x10000) % 0x100) / 255., ((color / 0x100) % 0x100) / 255., (color % 0x100) / 255., alpha
end


local function draw_bg(cr, t)
	local radius = t['corner_radius'] / t['aspect']
	local degrees = math.pi / 180.0
	local x, y, w, h = t['x'] - t['w'] / 2, t['y'] - t['h'] / 2, t['w'], t['h']

	cairo_new_sub_path(cr)
	cairo_arc(cr, x + w - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc(cr, x + w - radius, y + h - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc(cr, x + radius, y + h - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc(cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path(cr)

	cairo_set_source_rgba(cr, rgb_to_r_g_b(t['fill_color'], t['fill_alpha']))
	cairo_fill_preserve(cr)
	cairo_set_source_rgba(cr, rgb_to_r_g_b(t['border_color'], t['border_alpha']))
	cairo_set_line_width(cr, t['border_width'])
	cairo_stroke(cr)
end


local function draw_ring(cr, t, pt)
	local function ring_k(k)
		local v = pt[k] or rings_defaults[k]
		assert(v, k)
		return v
	end

	local w, h=conky_window.width, conky_window.height

	local xc, yc, ring_r, ring_w, sa, ea = ring_k('x'), ring_k('y'), ring_k('radius'), ring_k('thickness'), ring_k('start_angle'), ring_k('end_angle')
	local bgc, bga, fgc, fga = ring_k('bg_color'), ring_k('bg_alpha'), ring_k('fg_color'), ring_k('fg_alpha')

	local angle_0 = sa*(2*math.pi/360)-math.pi/2
	local angle_f = ea*(2*math.pi/360)-math.pi/2
	local t_arc = t*(angle_f-angle_0)

	-- Draw background ring

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
	cairo_set_line_width(cr,ring_w)
	cairo_stroke(cr)

	-- Draw indicator ring

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
	cairo_stroke(cr)
end


local function draw_clock_hands(cr, secs, mins, hours)
	local r, xc, yc = clock['r'], clock['x'], clock['y']
	local xh,yh,xm,ym,xs,ys

	local secs_arc = (2*math.pi/60)*secs
	local mins_arc = (2*math.pi/60)*mins+secs_arc/60
	local hours_arc = (2*math.pi/12)*hours+mins_arc/12

	-- hour hand
	xh=xc+0.7*r*math.sin(hours_arc)
	yh=yc-0.7*r*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)

	cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr, rgb_to_r_g_b(clock['color'], clock['alpha']))
	cairo_stroke(cr)

	-- minute hand
	xm=xc+r*math.sin(mins_arc)
	ym=yc-r*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)

	cairo_set_line_width(cr,3)
	cairo_stroke(cr)

	-- seconds hand
	if clock['show_seconds'] then
		xs=xc+r*math.sin(secs_arc)
		ys=yc-r*math.cos(secs_arc)
		cairo_move_to(cr,xc,yc)
		cairo_line_to(cr,xs,ys)

		cairo_set_line_width(cr,1)
		cairo_stroke(cr)
	end
end


local function bit_check(x, pos)
	pos = 2 ^ pos
	return x % (pos * 2) >= pos
end

local function bit_decode(x, max)
	local bits, x = {}, tonumber(x)
	for bit = 0, 7 do
		if 2 ^ bit > max then break end
		bits[bit] = bit_check(x, bit)
	end
	return bits
end

local function round(val, decimal)
	local exp = decimal and 10^decimal or 1
	return math.ceil(val * exp - 0.5) / exp
end

local function draw_bin_clock(cr, secs, mins, hours)
	local bin_bg = {}
	for k, v in pairs(bg) do bin_bg[k] = v end
	bin_bg['x'], bin_bg['w'] = bg['x'] + bg['w'] / 2 + clock_bin['w'] / 2 + clock_bin['clock_offset'], clock_bin['w']
	draw_bg(cr, bin_bg)

	local d, x, y = 6, bin_bg['x'] - bin_bg['w'] / 2, bin_bg['y'] - bin_bg['h'] / 2
	local offset, pad = clock_bin['block_offset'], clock_bin['pad']
	local h = round((bin_bg['h'] - pad * 2 + offset) / d - offset, 0)
	local w = h

	local rgba_fill = {rgb_to_r_g_b(clock_bin['fill_color'], clock_bin['fill_alpha'])}
	local rgba_border = {rgb_to_r_g_b(clock_bin['border_color'], clock_bin['border_alpha'])}
	cairo_set_line_width(cr, clock_bin['border_width'])

	local rows = {{secs, 60}, {mins, 60}, {hours, 24}}
	local row, v, max, bits, bx, by

	for row_n, row in pairs(rows) do
		bits = bit_decode(table.unpack(row))
		for bit, set in pairs(bits) do
			bx, by = pad + x + (row_n - 1) * (w + offset), pad + y + (h + offset) * bit
			cairo_rectangle(cr, bx, by, w, h)
			if set then
				cairo_set_source_rgba(cr, table.unpack(rgba_fill))
				cairo_fill_preserve(cr)
			end
			cairo_set_source_rgba(cr, table.unpack(rgba_border))
			cairo_stroke(cr)
		end
	end
end


strg = {
	frac=function(n) return n - math.floor(n) end,
	cos=function(d) return math.cos(math.rad(d)) end,
	acos=function(d) return math.deg(math.acos(d)) end,
	sin=function(d) return math.sin(math.rad(d)) end,
	asin=function(d) return math.deg(math.asin(d)) end,
	tan=function(d) return math.tan(math.rad(d)) end,
	atan=function(d) return math.deg(math.atan(d)) end
}

local function fit_into_range(val, min, max)
	local range = max - min
	local count
	if val < min then
		count = math.floor((min - val) / range) + 1
		return val + count * range
	elseif val >= max then
		count = math.floor((val - max) / range) + 1
		return val - count * range
	else
		return val
	end
end

local function day_of_year(date)
	local n1 = math.floor(275 * date.month / 9)
	local n2 = math.floor((date.month + 9) / 12)
	local n3 = (1 + math.floor((date.year - 4 * math.floor(date.year / 4) + 2) / 3))
	return n1 - (n2 * n3) + date.day - 30
end

local function sunturn_time(date, rising, latitude, longitude, zenith, local_offset)
	local n, lng_hour = day_of_year(date), longitude / 15
	local t = rising and n + ((6 - lng_hour) / 24) or n + ((18 - lng_hour) / 24)
	local M = (0.9856 * t) - 3.289
	local L = fit_into_range(M + (1.916 * strg.sin(M)) + (0.020 * strg.sin(2 * M)) + 282.634, 0, 360)
	local RA = fit_into_range(strg.atan(0.91764 * strg.tan(L)), 0, 360)
	RA = RA + math.floor(L / 90) * 90 - math.floor(RA / 90) * 90
	RA = RA / 15
	local sinDec = 0.39782 * strg.sin(L)
	local cosDec = strg.cos(strg.asin(sinDec))
	local cosH = (strg.cos(zenith) - (sinDec * strg.sin(latitude))) / (cosDec * strg.cos(latitude))

	-- Never rises / never sets at specified date (near poles)
	if rising and cosH > 1 then return 'N/R'
	elseif cosH < -1 then return 'N/S' end

	local H = ( rising and 360 - strg.acos(cosH) or strg.acos(cosH) ) / 15
	local T = H + RA - (0.06571 * t) - 6.622
	local UT = fit_into_range(T - lng_hour, 0, 24)
	local LT = UT + local_offset

	return os.time({
		day = date.day, month = date.month, year = date.year,
		hour = math.floor(LT), min = math.floor(strg.frac(LT) * 60) })
end


function conky_rings_draw()
	local function setup_rings(cr, pt)
		local str, value

		str = string.format('${%s %s}', pt['name'], pt['arg'])
		str = conky_parse(str)

		value = tonumber(str)
		if not value then value = 0 end
		pct = value / pt['max']

		draw_ring(cr, pct, pt)
	end

	if not conky_window then return end
	local cs = cairo_xlib_surface_create(
		conky_window.display,
		conky_window.drawable,
		conky_window.visual,
		conky_window.width, conky_window.height )

	local cr = cairo_create(cs)
	local updates = conky_parse('${updates}')
	local secs, mins, hours = os.date("%S"), os.date("%M"), os.date("%I")

	draw_bg(cr, bg)

	update_num = tonumber(updates)

	-- First update(s) can produce really weird numbers and segfault
	if update_num > 5 then
		for i in pairs(rings) do setup_rings(cr, rings[i]) end
	end

	draw_clock_hands(cr, secs, mins, hours)
	draw_bin_clock(cr, secs, mins, hours)
end

function conky_rings_color(ring_name)
	local c = rings_colors[ring_name]
	assert(c, ring_name)
	return string.format('${color %s}', string.format('%06x', c))
end

function conky_rings_marker(ring_name)
	if not rings_colors[ring_name] then
		return ''
	end
	return string.format('%s[*]', conky_rings_color(ring_name))
end


function conky_file_cap_read(...)
	local model_re, ts = '', os.time()

	for _, v in ipairs{...} do
		if string.len(model_re) > 0 then model_re = model_re .. ' ' end
		model_re = model_re .. v
	end

	if os.difftime(ts, file_cap.ts_read) > file_cap.ts_read_i then
		if os.difftime(ts, file_cap.ts_glob) > file_cap.ts_glob_i then
			local sh = io.popen(file_cap.glob_cmd, 'r')
			file_cap.glob_dirs = {}
			for p in string.gmatch(sh:read('*a'), '%S+') do
				if string.find(p, '*') then break end
				table.insert(file_cap.glob_dirs, p)
			end
			sh:close()
			file_cap.ts_glob = ts
		end

		local f, cap, model
		file_cap.values = {}
		for i, d in ipairs(file_cap.glob_dirs) do
			f = io.open(d .. 'capacity')
			cap = f:read('*a')
			f:close()
			f = io.open(d .. 'model_name')
			model = f:read('*a')
			file_cap.values[model] = string.match(cap, '%S+')
			f:close()
		end
		file_cap.ts_read = ts
	end

	for model, cap in pairs(file_cap.values) do
		if string.match(model, model_re) then
			return cap
		end
	end

	return ''
end


function conky_sens_cache()
	local ts = os.time()
	if os.difftime(ts, sensors.ts_read) > sensors.ts_read_i then
		local sh = io.popen(sensors.cmd, 'r')
		sensors.values = {}
		for p in string.gmatch(sh:read('*a'), '(%S+ %S+)\n') do
			local n = string.find(p, ' ')
			sensors.values[string.sub(p, 0, n-1)] = string.sub(p, n)
		end
		sh:close()
		sensors.ts_read = ts
	end
end

function conky_sens_read(name, precision)
	conky_sens_cache()
	if not sensors.values[name]
			and string.sub(name, 0, 3) == 're:' then
		local name_re = string.sub(name, 4)
		for k, v in pairs(sensors.values) do
			if string.find(k, name_re) then
				sensors.values[name] = sensors.values[k]
				break
			end
		end
	end
	if sensors.values[name] then
		local fmt = string.format('%%.%sf', precision or 0)
		return string.format(fmt, sensors.values[name])
	end
	return ''
end


function conky_portmon(dir, count)
	local p0, p1, ps
	if dir == 'in'
	then p0, p1, ps = 1, 32767, 'lservice'
	else
		if dir ~= 'out' then return '' end
		p0, p1, ps = 32768, 61000, 'rservice'
	end

	local _fmt_line = '${if_empty ${tcp_portmon %d %d rhost %d}}${else}'
		.. ' ${tcp_portmon %d %d rhost %d}/${tcp_portmon %d %d %s %d} $endif'
	local function fmt_line(n)
		return string.format(_fmt_line, p0, p1, n, p0, p1, n, p0, p1, ps, n)
	end

	local n, lines = 0, ''
	count = tonumber(count)
	while n < count do
		if string.len(lines) > 0 then lines = lines .. '\n' end
		lines = lines .. fmt_line(n) .. '$alignr' .. fmt_line(n + 1)
		n = n + 2
	end

	return lines
end


function conky_sun_event_time(t, ...)
	assert(t == 'rise' or t == 'set', t)
	local fmt = ''
	for _, v in ipairs{...} do fmt = fmt .. ' ' .. fmt end
	fmt = fmt:gsub('^%s*(.-)%s*$', '%1')
	if fmt == '' then fmt = '%H:%M' end
	local ts = sunturn_time( os.date('*t'), t == 'rise',
		sunrise.lat, sunrise.lon, sunrise.zenith, sunrise.offset )
	return os.date(fmt, ts)
end


function conky_env(var)
	return os.getenv(var)
end
