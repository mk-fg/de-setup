---- Adds script-message hook to remove/rename currently-playing file, for e.g. downloaded one-off videos
---- Removed file should continue playing as running mpv has it open, so can be done anytime during playback
---- mpv lua api: manpage + https://github.com/mpv-player/mpv/blob/master/player/lua/defaults.lua

-- This tracks files after timestamp-renaming
local file_path_orig, file_path_new

local function _file_path()
	local p = mp.get_property('path')
	if p:match(':') or p == '-' then return mp.msg.warn(
		'SKIP: not using currently-playing file, as it looks like an URL - '..p ) end
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

local function file_rm()
	local p = _file_path()
	if not p then return mp.msg.info('skipped file removal') end
	local done, err_msg, err_code = os.remove(p)
	if not done
		then mp.msg.error(('[OSError %s] %s'):format(err_code, err_msg))
		else mp.msg.info('source file removed: '..p) end
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

---- Hotkey spec example: ctrl+k script-message fg.file-rm
mp.register_script_message('fg.file-rm', function() file_rm() end)
mp.register_script_message('fg.file-ts-save', function() file_ts_save() end)
mp.register_script_message('fg.file-ts-seek', function() file_ts_seek() end)
