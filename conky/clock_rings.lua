-- Clock Rings + Binary Clock

-- Original Clock Rings by londonali1010 (2009) - edited by h0zza (2012)
-- [http://blog.hozzamedia.com/software/conky-resource-dialrings/]


-- Settings

rings_ox=130
rings_oy=155

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
		-- "bg_colour" is the colour of the base ring.
		bg_colour=0xffffff,
		-- "bg_alpha" is the alpha value of the base ring.
		bg_alpha=0.1,
		-- "fg_colour" is the colour of the indicator part of the ring.
		fg_colour=0xffffff,
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
		bg_colour=0xffffff,
		bg_alpha=0.1,
		fg_colour=0xffffff,
		fg_alpha=0.4,
		x=rings_ox, y=rings_oy,
		radius=56,
		thickness=5,
		start_angle=0,
		end_angle=360
	},
	{
		name='time',
		arg='%S',
		max=60,
		bg_colour=0xffffff,
		bg_alpha=0.1,
		fg_colour=0xffffff,
		fg_alpha=0.6,
		x=rings_ox, y=rings_oy,
		radius=62,
		thickness=5,
		start_angle=0,
		end_angle=360
	},
	{
		name='cpu',
		arg='cpu1',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0x0000AA,
		fg_alpha=0.3,
		x=rings_ox, y=rings_oy,
		radius=75,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu2',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0x0000AA,
		fg_alpha=0.3,
		x=rings_ox, y=rings_oy,
		radius=79,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu3',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0x0000AA,
		fg_alpha=0.3,
		x=rings_ox, y=rings_oy,
		radius=83,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu4',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0x0000AA,
		fg_alpha=0.3,
		x=rings_ox, y=rings_oy,
		radius=87,
		thickness=4,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu',
		arg='cpu0',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0x0000AA,
		fg_alpha=0.6,
		x=rings_ox, y=rings_oy,
		radius=93,
		thickness=6,
		start_angle=93,
		end_angle=208
	},
	{
		name='memperc',
		arg='',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=rings_ox, y=rings_oy,
		radius=78,
		thickness=11,
		start_angle=212,
		end_angle=329
	},
	{
		name='swapperc',
		arg='',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=rings_ox, y=rings_oy,
		radius=90,
		thickness=11,
		start_angle=212,
		end_angle=329
	},
	{
		name='upspeedf',
		arg='enp1s0',
		max=5000,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xff0000,
		fg_alpha=0.3,
		x=rings_ox, y=rings_oy,
		radius=78,
		thickness=11,
		start_angle=-28,
		end_angle=90
	},
	{
		name='downspeedf',
		arg='enp1s0',
		max=5000,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0x006f00,
		fg_alpha=0.3,
		x=rings_ox, y=rings_oy,
		radius=90,
		thickness=11,
		start_angle=-28,
		end_angle=90
	},
	{
		name='fs_used_perc',
		arg='/',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=rings_ox, y=rings_oy,
		radius=105,
		thickness=3,
		start_angle=-120,
		end_angle=-13
	},
	{
		name='fs_used_perc',
		arg='/home',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=rings_ox, y=rings_oy,
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


require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end


function draw_bg(cr, t)
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


function draw_ring(cr,t,pt)
	local w,h=conky_window.width,conky_window.height

	local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
	local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

	local angle_0=sa*(2*math.pi/360)-math.pi/2
	local angle_f=ea*(2*math.pi/360)-math.pi/2
	local t_arc=t*(angle_f-angle_0)

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


function draw_clock_hands(cr, secs, mins, hours)
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


function bit_check(x, pos)
	pos = 2 ^ pos
	return x % (pos * 2) >= pos
end

function bit_decode(x, max)
	local bits, x = {}, tonumber(x)
	for bit = 0, 7 do
		if 2 ^ bit > max then break end
		bits[bit] = bit_check(x, bit)
	end
	return bits
end

function round(val, decimal)
	local exp = decimal and 10^decimal or 1
	return math.ceil(val * exp - 0.5) / exp
end

function draw_bin_clock(cr, secs, mins, hours)
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
		bits = bit_decode(unpack(row))
		for bit, set in pairs(bits) do
			bx, by = pad + x + (row_n - 1) * (w + offset), pad + y + (h + offset) * bit
			cairo_rectangle(cr, bx, by, w, h)
			if set then
				cairo_set_source_rgba(cr, unpack(rgba_fill))
				cairo_fill_preserve(cr)
			end
			cairo_set_source_rgba(cr, unpack(rgba_border))
			cairo_stroke(cr)
		end
	end
end


function conky_clock_rings()
	local function setup_rings(cr,pt)
		local str=''
		local value=0

		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)

		value=tonumber(str)
		if value == nil then value = 0 end
		pct=value/pt['max']

		draw_ring(cr,pct,pt)
	end

	-- Check that Conky has been running for at least 5s

	if conky_window == nil then return end
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
