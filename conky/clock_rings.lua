-- Clock Rings by londonali1010 (2009) - edited by h0zza (2012)
-- [http://blog.hozzamedia.com/software/conky-resource-dialrings/]


-- Center of drawn widget

rings_ox=130
rings_oy=155


settings_table = {
	{
		-- Edit this table to customise your rings.  You can create more rings
		-- simply by adding more elements to settings_table.  "name" is the type of
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


-- Clock settings

clock_r = 40
clock_x = rings_ox
clock_y = rings_oy

clock_colour = 0xffffff
clock_alpha = 0.5

clock_show_seconds = true

-- BG settings

bg_x = rings_ox
bg_y = rings_oy - 10
bg_w = 250
bg_h = 230
bg_aspect = 1.0
bg_corner_radius = bg_h / 10


require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_bg(cr,t,pt)
	local radius = bg_corner_radius / bg_aspect
	local degrees = math.pi / 180.0
	local x = bg_x - bg_w / 2
	local y = bg_y - bg_h / 2

	cairo_new_sub_path(cr)
	cairo_arc(cr, x + bg_w - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc(cr, x + bg_w - radius, y + bg_h - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc(cr, x + radius, y + bg_h - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc(cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path(cr)

	cairo_set_source_rgba(cr, 0.1, 0.2, 0.1, 0.1)
	cairo_fill_preserve(cr)
	cairo_set_source_rgba(cr, 0, 0, 0, 0.1)
	cairo_set_line_width(cr, 2.0)
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

function draw_clock_hands(cr,xc,yc)
	local secs,mins,hours,secs_arc,mins_arc,hours_arc
	local xh,yh,xm,ym,xs,ys

	secs=os.date("%S")
	mins=os.date("%M")
	hours=os.date("%I")

	secs_arc=(2*math.pi/60)*secs
	mins_arc=(2*math.pi/60)*mins+secs_arc/60
	hours_arc=(2*math.pi/12)*hours+mins_arc/12

	-- Draw hour hand

	xh=xc+0.7*clock_r*math.sin(hours_arc)
	yh=yc-0.7*clock_r*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(clock_colour,clock_alpha))
	cairo_stroke(cr)

	-- Draw minute hand

	xm=xc+clock_r*math.sin(mins_arc)
	ym=yc-clock_r*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)

	cairo_set_line_width(cr,3)
	cairo_stroke(cr)

	-- Draw seconds hand

	if clock_show_seconds then
		xs=xc+clock_r*math.sin(secs_arc)
		ys=yc-clock_r*math.cos(secs_arc)
		cairo_move_to(cr,xc,yc)
		cairo_line_to(cr,xs,ys)

		cairo_set_line_width(cr,1)
		cairo_stroke(cr)
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

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(
		conky_window.display,
		conky_window.drawable,
		conky_window.visual,
		conky_window.width, conky_window.height )

	local cr=cairo_create(cs)

	draw_bg(cr)

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	-- First update(s) can produce really weird numbers and segfault
	if update_num>5 then
		for i in pairs(settings_table) do
			setup_rings(cr,settings_table[i])
		end
	end

	draw_clock_hands(cr,clock_x,clock_y)
end
