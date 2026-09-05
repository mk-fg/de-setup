---- Adds script-message hook to remove/rename currently-playing file, for e.g. downloaded one-off videos
---- Removed file should continue playing as running mpv has it open, so can be done anytime during playback
---- mpv lua api: manpage + https://github.com/mpv-player/mpv/blob/master/player/lua/defaults.lua

-- This tracks files after timestamp-renaming
local file_path_orig, file_path_new
local symlink_dir = '/tmp/mpv-links'
local mpu = require 'mp.utils'

local function _file_path()
	local p = mp.get_property('path')
	if not p or p:match(':') or p == '-' then return mp.msg.warn( 'SKIP: '..
		'not using currently-playing file - does not look like a path [ '..(p or '<nil>')..' ]' ) end
	if not p:match('^/')
		then p = mp.get_property('working-directory'):gsub('/+$', '')..'/'..p end
	if file_path_orig then -- resets stored values on mpv switching src files
		if file_path_orig == p and file_path_new
			then p = file_path_new else file_path_orig, file_path_new = nil
	end end
	return p
end

local function _file_path_ts()
	local p = _file_path()
	if not p then return end
	local suff, ts, ext, hh, mm = p:match('(%.([%dhm]+)%.([^.]+))$')
	if ts then
		hh, mm = ts:match('^(%d+)h[ _]*(%d+)m$')
		if not hh then hh, mm = ts:match('^(%d+)h$'), 0 end
		if not hh then hh, mm = 0, ts:match('^(%d+)m$') end
		hh, mm = tonumber(hh), tonumber(mm)
	else suff, ext = p:match('(%.([^.]+))$') end
	return p, hh, mm, (
		p:sub(1, p:len() - suff:len()):gsub('%%', '%%%%')..
		'.%s.'..ext:gsub('%%', '%%%%') )
end


local function file_ts_save()
	local p, hh, mm, p_tpl = _file_path_ts()
	if not p then return mp.msg.info('skipped file renaming') end
	local ts, err = mp.get_property_number('time-pos')
	if not ts then
		return mp.msg.error(('time-pos-err: %s'):format(err or 'no-err-msg')) end
	if ts < 60 then
		return mp.msg.error('time-pos-err: time-pos is start of the file') end
	hh, mm = math.floor(ts / 3600), math.floor(ts % 3600 / 60)
	local ts = {}
	if hh > 0 then table.insert(ts, ('%dh'):format(hh)) end
	if mm > 0 then table.insert(ts, ('%dm'):format(mm)) end
	local p_ts = p_tpl:format(table.concat(ts))
	local done, err_msg, err_code = os.rename(p, p_ts)
	file_path_orig, file_path_new = file_path_orig or p, p_ts
	if not done
		then mp.msg.error(('[OSError %s] %s'):format(err_code, err_msg))
		else mp.msg.info('filename-ts updated: '..p_ts) end
end

local function file_ts_seek()
	local p, hh, mm = _file_path_ts()
	if not p then return mp.msg.info('skipped file seek') end
	if not hh then return mp.msg.error('seek-err: no time-pos info') end
	local done, err = mp.commandv('seek', hh * 3600 + mm * 60, 'absolute')
	if not done then
		return mp.msg.error(('seek-err: %s'):format(err or 'no-err-msg')) end
	local ts = {}
	if hh > 0 then table.insert(ts, ('%dh'):format(hh)) end
	if mm > 0 then table.insert(ts, ('%dm'):format(mm)) end
	mp.msg.info(('filename-ts seek: %s'):format(table.concat(ts, ' ')))
end


local function file_rm()
	local p = _file_path()
	if not p then return mp.msg.info('skipped file removal') end
	local done, err_msg, err_code = os.remove(p)
	if not done
		then mp.msg.error(('[OSError %s] %s'):format(err_code, err_msg))
		else mp.msg.info('source file removed: '..p) end
end

local function file_mtime()
	local p = _file_path()
	if not p then return mp.msg.info('missing file') end
	local err_code = mp.command_native({
		name='subprocess', args={'touch', '--no-create', p} }).status
	if err_code ~= 0 then return mp.msg.error(
		('[mtime] touch --no-create failed (code=%s): %s'):format(err_code, p) ) end
	mp.msg.info(('[mtime] updated: %s'):format(p))
end


local function _file_link_dir()
	return ('%s/pid.%s/'):format(symlink_dir, mp.get_property('pid')) end

local function file_link(fn)
	local err_code = mp.command_native({name='subprocess', args={ 'sh', '-c',
		'exec install -o"$(id -u)" -g"$(id -g)" -m700 -d "$1"', '--', symlink_dir }}).status
	if err_code ~= 0 then return mp.msg.error(
		('[symlink] mkdir error (code=%s): %s'):format(err_code, symlink_dir) ) end
	local pid_dir, p = _file_link_dir(), _file_path()
	if not fn then fn = pid_dir else fn = pid_dir .. fn end
	err_code = mp.command_native({
		name='subprocess', args={'mkdir', '-pm700', pid_dir} }).status
	if err_code ~= 0 then return mp.msg.error(
		('[symlink] mkdir pid-subdir error (code=%s): %s'):format(err_code, pid_dir) ) end
	if not mpu.file_info(pid_dir..p) then
		err_code = mp.command_native({
			name='subprocess', args={'ln', '-sf', p, fn} }).status
		if err_code ~= 0 then return mp.msg.error(
			('[symlink] ln failed (code=%s): %s'):format(err_code, p) ) end
		mp.msg.info(('[symlink] created: %s'):format(p))
	end
end

local function file_link_tomkv_set(opt, value)
	-- Adds ffmpeg options in symlink name that can be used
	--  by -F/--fn-opts in tomkv script - https://github.com/mk-fg/fgtk#hdr-tomkv
	local pid_dir, p = _file_link_dir(), _file_path():match('/([^/]+)$')
	local stem, ext = p:match('^(.+)%.([%w_-]+)$')
	if not stem then mp.msg.error(
			('[symlink-tomkv-%s] Failed to match as <stem>.<ext>: %s'):format(opt, p) ) end

	-- <pid_dir>/<p> is used if exists, otherwise last-ctime <pid_dir>/<p>.tomkv<opts>.<ext>
	-- This way re-running file_link creates new symlink-name to tweak parameters in
	local ext_pat = '(%.tomkv(%+.+))%.('..ext..')$'
	local px, px_ts, tomkv, opts, opts_map
	if mpu.file_info(pid_dir..p) then px, tomkv, opts = p, '', ''
	else for _, pp in ipairs(mpu.readdir(pid_dir, 'files')) do
		if pp:sub(1, stem:len()) == stem then
			tomkv, opts, px = pp:sub(stem:len()+1):match(ext_pat)
			if px then -- mpu.file_info() derefs symlinks, hence stat binary
				local ts = tonumber(mp.command_native({ name='subprocess',
					capture_stdout=true, args={'stat', '-c%Z', pid_dir..pp} }).stdout)
				if not px_ts or px_ts < ts then px, px_ts = pp, ts end end; break
		end end end
	if not px then file_link(); px, tomkv, opts = p, '', '' end

	-- Parse opts -> opts_map, update, format back to opts
	opts_map, opts = {}, opts:gsub('%+%+', '\x01')
	opts = opts:gsub('%+([%w_]+=[^+]+)', function(v)
		local k, v = v:match('^([%w_]+)=(.+)$')
		opts_map[k] = v:gsub('\x01', '+'); return '' end)
	if opts:len() > 0 then return mp.msg.error(( '[symlink-tomkv-%s]'..
		' Unmatched tomkv-opts: %q [from %q ]' ):format(opt, opts, tomkv)) end
	opts_map[opt] = value
	for k, v in pairs(opts_map) do opts = opts ..
		('+%s=%s'):format(k, v:gsub('%+', '++')) end

	local pp = ('%s.tomkv%s.%s'):format(stem, opts, ext)
	if pp ~= px then
		mp.msg.info(('[symlink] update: [ %s ] -> [ %s ]'):format(px, pp))
		os.rename(pid_dir..px, pid_dir..pp) end
end


---- Hotkey spec example: ctrl+k script-message fg.file-rm
mp.register_script_message('fg.file-ts-save', function() file_ts_save() end)
mp.register_script_message('fg.file-ts-seek', function() file_ts_seek() end)
mp.register_script_message('fg.file-rm', function() file_rm() end)
mp.register_script_message('fg.file-mtime', function() file_mtime() end)

mp.register_script_message('fg.file-link', function() file_link() end)
mp.register_script_message('fg.file-link-tomkv-ss', function()
	file_link_tomkv_set('ss', mp.get_property_osd('time-pos')) end)
mp.register_script_message('fg.file-link-tomkv-to', function()
	file_link_tomkv_set('to', mp.get_property_osd('time-pos')) end)
