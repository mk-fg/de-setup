---- Adds script-message hook to remove currently-playing file, useful for e.g. downloaded one-off videos
---- Removed file should continue playing as running mpv has it open, so can be done anytime during playback
---- mpv lua api: manpage + https://github.com/mpv-player/mpv/blob/master/player/lua/defaults.lua

local function file_rm()
	local p = mp.get_property('path')
	if p:match(':') then return mp.msg.warn(
		'SKIP: not removing currently-playing file, as it looks like an URL - '..p ) end
	p = mp.get_property('working-directory'):gsub('/+$', '')..'/'..p
	local done, err_msg, err_code = os.remove(p)
	if not done then mp.msg.error(('[OSError %s] %s'):format(err_code, err_msg))
	else mp.msg.info('source file removed: '..p) end
end

---- Hotkey spec example: ctrl+k script-message fg.file-rm
mp.register_script_message('fg.file-rm', function() file_rm() end)
