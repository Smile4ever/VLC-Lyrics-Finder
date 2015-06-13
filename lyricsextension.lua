-- FIXME: add additional site compatibility
-- 	: add built-in search when page is not found

-- start of VLC required functions
dlg = nil
title = nil
artist = nil
lyric = nil

-- VLC Extension Descriptor
function descriptor()
	return {
				title = "Lyrics Finder";
				version = "0.2";
				author = "rsyh93, alexxnf";
				url = 'https://github.com/alexxxnf/VLC-Lyrics-Finder';
				description = "<center><b>Lyrics Finder</b></center>"
						   .. "<br /><b>Gets the lyrics from lyricsmode.com</b>"
						   .. "<br /><b>(Based on the script made by Jean-Philippe Andre)</b>"
						   .. "<br /><b>(Modified by Aleksey Maydokin)</b>";
				shortdesc = "Get the lyrics from lyricsmode.com";
				capabilities = { "input-listener"; "meta-listener" }
			}
end

-- Function triggered when the extension is activated
function activate()
	vlc.msg.dbg(_VERSION)
	vlc.msg.dbg("[Lyrics] Activating")
	show_dialog()
	return true
end

-- Function triggered when the extension is deactivated
function deactivate()
	close()
	vlc.msg.dbg("[Lyrics] Deactivated")
	return true
end

function new_dialog(title)
	dlg=vlc.dialog(title)
end

-- Function triggered when the dialog is closed
function close()
	reset_variables()
	vlc.deactivate()
end

function show_dialog()
	if dlg == nil then
		new_dialog("Lyrics Finder")
	end

	-- column, row, col_span, row_span, width, height

	dlg:add_label("Title:", 1, 1, 1, 1)
	title = dlg:add_text_input(get_title(), 2, 1, 3, 1)

	dlg:add_label("Artist:", 1, 2, 1, 1)
	artist = dlg:add_text_input(get_artist(), 2, 2, 3, 1)

	dlg:add_button("Update", update_metas, 1, 3, 1, 1)
	dlg:add_button("Get Lyrics", click_lyrics_button, 2, 3, 2, 1)
	dlg:add_button("Close", close, 4, 3, 1, 1)
	lyric = dlg:add_html("", 1,4,4,4)
	return true
end

-- Resets Dialog
function reset_variables()
	dlg = nil
	title = nil
	artist = nil
	lyric = nil
end

-- Updates Input Fields
function update_metas()
	title:set_text(get_title())
	artist:set_text(get_artist())

	dlg:update()
	return true
end
-- end of VLC functions

function get_lyrics(title_x, artist_x)
	title_x = trim(title_x)
	artist_x = trim(artist_x)

	title_x = string.gsub(title_x, " ", "_")
	artist_x = string.gsub(artist_x, " ", "_")

	title_x = string.lower(title_x)
	artist_x = string.lower(artist_x)

	title_x = title_x:gsub('[^%w_]','')
	artist_x = artist_x:gsub('[^%w_]','')

	local url = "http://www.lyricsmode.com/lyrics/"..artist_x:sub(1,1).."/"..artist_x.."/"..title_x..".html"

	lyric:set_text("LOADING URL "..url)
	dlg:update()

	local s = vlc.stream(url)

	if not s then
		return ""
	end

	local data = s:read(65535)

	data = string.gsub(data, "&#(%d+)", string.char);
	local _,a = string.find(data, '<p id="lyrics_text" class="ui-annotatable">', 0, true)
	local b,_ = string.find(data, "</p>", a, true)

	return data:sub(a+1,b-1)
end

function click_lyrics_button()
	lyric:set_text("LOADING...")
	dlg:update()

	local songtitle = title:get_text()
	local songartist = artist:get_text()

	local lyric_string = get_lyrics(songtitle, songartist)
	if lyric_string=="" or lyric_string==nil then
		lyric:set_text("<i>URL NOT FOUND</i>")
		dlg:update()
		return false
	end

	lyric:set_text(lyric_string)
	dlg:update()
	return true
end

-- Get clean title from filename
function get_title()
    local item = vlc.item or vlc.input.item()
    if not item then
        return ""
    end
    local metas = item:metas()
    if metas["title"] then
        return metas["title"]
    else
        local filename = string.gsub(item:name(), "^(.+)%.%w+$", "%1")
        return trim(filename or item:name())
    end
end

-- Get clean artist from filename
function get_artist()
    local item = vlc.item or vlc.input.item()
    if not item then
        return ""
    end
    local metas = item:metas()
    if metas["artist"] then
        return metas["artist"]
    else
        return ""
    end
end

-- Remove leading and trailing spaces
function trim(str)
    if not str then return "" end
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

-- Solve crash problem #14786: https://trac.videolan.org/vlc/ticket/14786
function meta_changed()
end
