--Lyrics Finder
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

-- Lyrics Finder incorporates some code of VLsub.

--Supported websites (by priority)
--MetroLyrics (1 000 000 song lyrics)
--Sonic Hits (many lyrics)
--Lyrics Mode (1 000 000 song lyrics)
--Golyr.de
--AZ Lyrics
--Lyrics.com (-)
--Lyricsmania.com (-) (is http://www.parolesmania.com the same?)

-- FIXME: add additional site compatibility
--------- http://lyrics123.net (500.000 song lyrics)
--------- http://www.azlyrics.com/lyrics/whispers/mygirl.html
--------- http://www.songteksten.nl/ (Dutch songs)
--------- http://www.lyricsfreak.com (+ instead of _) -> we will need to use the artist page here
--------- http://decoda.com/

--------- Requires use of the search page to implement
--------- http://www.lyricsondemand.com/results.html?q=kiss+from+a+rose (.gs-per-result-labels)
--------- http://www.lyrics007.com/search.php?q=whitney+houston (only title or author, not both, requires adding prefix)
--------- http://www.lyricsplanet.com
--------- http://letssingit.com
--------- http://www.lyricsfly.com
--------- http://www.lyred.com (not well updated)
--------- http://www.songteksten.net (uses ids)

--------- Less coverage / otherwise less interesting
--------- http://lyrics.wikia.com (not accurate)
--------- http://www.lyricsfind.com (bad coverage)
--------- http://lyricsvault.net (bot protection - maybe we can get around it)
--------- https://www.musixmatch (doesn't work)

-- FIXME: add built-in search when page is not found
-- FIXME: make use of artist page on metrolyrics.com when we end up there
-- FIXME: make use of search page: http://www.lyricsmode.com/search.php?search=i%27m%20gonna%20make%20you%20love%20me
-- FIXME: add intelligent guessing for artist / title position (artist first or title first?)
--------- LONGEST = title, unless difference < 5 chars (use default)
--------- LONGEST = author if it includes AND or &
--------- MOST SPACES = title
-- FIXME: Title (extratitle) for Metro Lyrics
-- FIXME: In another life, I would like to add acoustic fingerprinting
-- FIXME: update lyrics automatically on song change (without crashes)

dlg = nil
title = nil
artist = nil
lyric = nil
source_label = nil
debug_enabled = false
langcode = "" --dut

translation = {
	dialogtitle_normal = 'Lyrics',
	dialogtitle_notfound = 'Not Found',
	dialogtitle_lyricsof= 'Lyrics of',
	dialogtitle_performedby = 'by',
	button_getlyrics = 'Get Lyrics',
	button_refresh = 'Refresh',
	button_switch = 'Switch',
	button_close = 'Close',
	button_google = 'Search with Google',
	button_update = 'Get updates',
	label_title = 'Title:',
	label_artist = 'Artist:',
	label_source = 'Source:',
	message_newsong = 'New song loaded. To get the lyrics, click Get Lyrics.',
	message_loading = "Loading..",
	message_incorrect = 'Incorrect artist or title.',
	message_notfound = 'Lyrics not found.'
}

languages = {
	{'afr', 'Afrikaans'},
	{'alb', 'Albanian'},
	{'ara', 'Arabic'},
	{'arm', 'Armenian'},
	{'baq', 'Basque'},
	{'ben', 'Bengali'},
	{'bos', 'Bosnian'},
	{'bre', 'Breton'},
	{'bul', 'Bulgarian'},
	{'bur', 'Burmese'},
	{'cat', 'Catalan'},
	{'chi', 'Chinese'},
	{'hrv', 'Croatian'},
	{'cze', 'Czech'},
	{'dan', 'Danish'},
	{'dut', 'Dutch'},
	{'eng', 'English'},
	{'epo', 'Esperanto'},
	{'est', 'Estonian'},
	{'fin', 'Finnish'},
	{'fre', 'French'},
	{'glg', 'Galician'},
	{'geo', 'Georgian'},
	{'ger', 'German'},
	{'ell', 'Greek'},
	{'heb', 'Hebrew'},
	{'hin', 'Hindi'},
	{'hun', 'Hungarian'},
	{'ice', 'Icelandic'},
	{'ind', 'Indonesian'},
	{'ita', 'Italian'},
	{'jpn', 'Japanese'},
	{'kaz', 'Kazakh'},
	{'khm', 'Khmer'},
	{'kor', 'Korean'},
	{'lav', 'Latvian'},
	{'lit', 'Lithuanian'},
	{'ltz', 'Luxembourgish'},
	{'mac', 'Macedonian'},
	{'may', 'Malay'},
	{'mal', 'Malayalam'},
	{'mon', 'Mongolian'},
	{'nor', 'Norwegian'},
	{'oci', 'Occitan'},
	{'per', 'Persian'},
	{'pol', 'Polish'},
	{'por', 'Portuguese'},
	{'pob', 'Brazilian Portuguese'},
	{'rum', 'Romanian'},
	{'rus', 'Russian'},
	{'scc', 'Serbian'},
	{'sin', 'Sinhalese'},
	{'slo', 'Slovak'},
	{'slv', 'Slovenian'},
	{'spa', 'Spanish'},
	{'swa', 'Swahili'},
	{'swe', 'Swedish'},
	{'syr', 'Syriac'},
	{'tgl', 'Tagalog'},
	{'tel', 'Telugu'},
	{'tha', 'Thai'},
	{'tur', 'Turkish'},
	{'ukr', 'Ukrainian'},
	{'urd', 'Urdu'},
	{'vie', 'Vietnamese'}
}

-- Languages code conversion table: iso-639-1 to iso-639-3
-- See https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
local lang_os_to_iso = {
	af = "afr",
	sq = "alb",
	ar = "ara",
	hy = "arm",
	eu = "baq",
	bn = "ben",
	bs = "bos",
	br = "bre",
	bg = "bul",
	my = "bur",
	ca = "cat",
	zh = "chi",
	hr = "hrv",
	cs = "cze",
	da = "dan",
	nl = "dut",
	en = "eng",
	eo = "epo",
	et = "est",
	fi = "fin",
	fr = "fre",
	gl = "glg",
	ka = "geo",
	de = "ger",
	el = "ell",
	he = "heb",
	hi = "hin",
	hu = "hun",
	is = "ice",
	id = "ind",
	it = "ita",
	ja = "jpn",
	kk = "kaz",
	km = "khm",
	ko = "kor",
	lv = "lav",
	lt = "lit",
	lb = "ltz",
	mk = "mac",
	ms = "may",
	ml = "mal",
	mn = "mon",
	no = "nor",
	oc = "oci",
	fa = "per",
	pl = "pol",
	pt = "por",
	po = "pob",
	ro = "rum",
	ru = "rus",
	sr = "scc",
	si = "sin",
	sk = "slo",
	sl = "slv",
	es = "spa",
	sw = "swa",
	sv = "swe",
	tl = "tgl",
	te = "tel",
	th = "tha",
	tr = "tur",
	uk = "ukr",
	ur = "urd",
	vi = "vie"
}

-- start of VLC required functions
-- VLC Extension Descriptor
function descriptor()
	return {
				title = "Lyrics Finder";
				version = "0.3.1.1";
				author = "rsyh93, alexxxnf, Smile4ever";
				url = 'https://github.com/Smile4ever/VLC-Lyrics-Finder';
				description = "<center><b>Lyrics Finder</b></center>"
						   .. "<br /><b>Gets the lyrics for your favorite songs</b>"
						   .. "<br /><b>(Based on the script made by Jean-Philippe Andre)</b>"
						   .. "<br /><b>(Modified by Aleksey Maydokin)</b>"
						   .. "<br /><b>(Modified and translated by Geoffrey De Belie</b>";
				shortdesc = "Lyrics Finder";
				capabilities = { "input-listener"; "meta-listener"; "playing-listener" }
			}
end

-- Function triggered when the extension is activated
function activate()
	vlc.msg.dbg(_VERSION) --display Lua version in the VLC message window
	vlc.msg.dbg("[Lyrics Finder] Activating ")
	langcode = getenv_lang() --auto guess
	if dlg then
		dlg:show()
	end
	show_dialog()
	return true
end

function close()
	deactivate()
end

-- Function triggered when the extension is deactivated
function deactivate()
	reset_variables()
	vlc.deactivate()
	vlc.msg.dbg("[Lyrics Finder] Deactivated")
	return true
end

function new_dialog(title)
	dlg=vlc.dialog(title)
end

function show_dialog()
	en_translation = translation --make a copy

	if langcode then
		--GPL code from VLsub (adapted)
		if is_window_path(vlc.config.datadir()) then
			--Windows
			slash = "\\"
		else
			--Unix
			slash = "/"
		end
		
		local path_generic = {"lua", "extensions", "lyricsfinder", "locale"}
		local dirPath = slash..table.concat(path_generic, slash)..slash
		
		local transl_file_userpath = vlc.config.userdatadir() .. dirPath .. langcode .. ".xml"
					
		--prefer user file
		if file_exist(transl_file_userpath) then
			vlc.msg.dbg("[Lyrics Finder] Loading translation from user file " .. transl_file_userpath)
			load_transl(transl_file_userpath,langcode)
		else
			--use system file if no user file is present
			local transl_file_syspath = vlc.config.datadir() .. dirPath .. langcode .. ".xml"
			
			if file_exist(transl_file_syspath) then
				vlc.msg.dbg("[Lyrics Finder] Loading translation from system file " .. transl_file_syspath)
				load_transl(transl_file_syspath,langcode)
			end
		end
				
		--end GPL code from VLsub (adapted)
	end

	if dlg == nil then
		new_dialog(translation["dialogtitle_normal"])
	end

	-- column, row, col_span, row_span, width, height

	dlg:add_label(translation["label_title"], 1, 1, 1, 1)
	title = dlg:add_text_input(get_title(), 2, 1, 5, 1)

	dlg:add_label(translation["label_artist"], 1, 2, 1, 1)
	artist = dlg:add_text_input(get_artist(), 2, 2, 5, 1)

	dlg:add_button(translation["button_getlyrics"], update_lyrics, 1, 3, 4, 1)
	dlg:add_button(translation["button_refresh"], update_metas, 7, 1, 1, 1)
	dlg:add_button(translation["button_switch"], click_switch, 7, 2, 1, 1)
	dlg:add_button(translation["button_close"], deactivate, 7, 3, 1, 1)
	dlg:add_button(translation["button_google"], click_google, 5, 3, 2, 1)
	dlg:add_button(translation["button_update"], download_update, 7, 28, 1, 1)
	lyric = dlg:add_html("", 1, 5, 7, 20, 6, 18)
	source_label=dlg:add_label(translation["label_source"], 1, 28, 6, 1)
	
	update_lyrics()
	return true
end

-- Resets dialog
function reset_variables()
	dlg = nil
	title = nil
	artist = nil
	lyric = nil
	source_label = nil
	languages = nil
	translation = nil
end

-- Update input fields and lyrics (refresh functionality)
function update_metas()
	title:set_text(get_title())
	artist:set_text(get_artist())
	
	update_lyrics()
	dlg:update()
	return true
end
-- end of VLC functions

--GPL code from VLSub
function load_transl(path,code)
	langcode = code
	
	local tmpFile = assert(io.open(path, "rb"))
	local resp = tmpFile:read("*all")
	tmpFile:flush()
	tmpFile:close()
	
	translation = nil
	translation = parse_xml(resp)

	apply_translation()
end

--GPL code from VLSub
function apply_translation()
-- Overwrite default conf with loaded conf
	for k, v in pairs(en_translation) do
	
		if not translation[k] then
			translation[k] = en_translation[k]
		--else
			--vlc.msg.dbg("Lyrics Finder" .. translation[k])
		end
	end
end

--GPL code from VLSub
function file_exist(name) -- test readability
	if not name or trim(name) == "" 
	then return false end
	local f=io.open(name ,"r")
	if f~=nil then 
		io.close(f) 
		return true 
	else 
		return false 
	end
end

--GPL code from VLSub
function parse_xml(data)
	local tree = {}
	local stack = {}
	local tmp = {}
	local level = 0
	local op, tag, p, empty, val
	table.insert(stack, tree)

	for op, tag, p, empty, val in string.gmatch(
		data, 
		"[%s\r\n\t]*<(%/?)([%w:_]+)(.-)(%/?)>[%s\r\n\t]*([^<]*)[%s\r\n\t]*"
	) do
		if op=="/" then
			if level>0 then
				level = level - 1
				table.remove(stack)
			end
		else
			level = level + 1
			if val == "" then
				if type(stack[level][tag]) == "nil" then
					stack[level][tag] = {}
					table.insert(stack, stack[level][tag])
				else
					if type(stack[level][tag][1]) == "nil" then
						tmp = nil
						tmp = stack[level][tag]
						stack[level][tag] = nil
						stack[level][tag] = {}
						table.insert(stack[level][tag], tmp)
					end
					tmp = nil
					tmp = {}
					table.insert(stack[level][tag], tmp)
					table.insert(stack, tmp)
				end
			else
				if type(stack[level][tag]) == "nil" then
					stack[level][tag] = {}
				end
				stack[level][tag] = vlc.strings.resolve_xml_special_chars(val)
				table.insert(stack,  {})
			end
			if empty ~= "" then
				stack[level][tag] = ""
				level = level - 1
				table.remove(stack)
			end
		end
	end
	
	collectgarbage()
	return tree
end

--GPL code from VLsub
function getenv_lang()
-- Retrieve the user OS language 
	local os_lang = os.getenv("LANG")
	
	if os_lang then -- unix, mac
		os_lang = string.sub(os_lang, 0, 2)
		if type(lang_os_to_iso[os_lang]) then
			return lang_os_to_iso[os_lang]
		end
	else -- Windows
		local lang_w = string.match(os.setlocale("", "collate"), "^[^_]+")
		for i, v in ipairs(languages) do
		  if v[2] == lang_w then
			return v[1]
		  end
		end 
	end
end

function click_switch()
	local title_local = title:get_text()
	local artist_local = artist:get_text()
	
	title:set_text(artist_local)
	artist:set_text(title_local)
	
	dlg:update()
	return true
end

function click_google()
	local query = artist:get_text() .. " - " .. title:get_text()
	query = query:gsub('&', 'and')
	query = query .. "+lyrics"
	open_url("https://google.com/search?q=" .. query)
end

function download_update()
	local installed_version = descriptor()["version"]
	
	open_url("https://github.com/Smile4ever/VLC-Lyrics-Finder")
end

function readfile(path)
	local tmpFile = assert(io.open(path, "rb"))
	local resp = tmpFile:read("*all")
	tmpFile:flush()
	tmpFile:close()
	return resp
end

function get_lyrics(title_x, artist_x)
	if title_x == "" or artist_x == "" then
		return ""
	end

	title_x = trim(title_x)
	artist_x = trim(artist_x)

	title_x = string.gsub(title_x, " ", "_")
	artist_x = string.gsub(artist_x, " ", "_")

	title_x = string.lower(title_x)
	artist_x = string.lower(artist_x)

	title_x = title_x:gsub("-", "_")
	local original_title = title_x
	title_x = title_x:gsub('[^%w_]','')
	title_x = title_x:gsub('&','and')
	artist_x = artist_x:gsub('&', 'and')
	--artist_x = artist_x:gsub('_&_','_and_')
	artist_x = artist_x:gsub('_&_','_')
	artist_x = artist_x:gsub('%.','')
	artist_x = artist_x:gsub('ó', 'o') --Róisín Murphy
	artist_x = artist_x:gsub('í', 'i') --Róisín Murphy
		
	local artist_metro = artist_x:gsub('[-]','') --a-ha is aha on metro lyrics, but a_ha on lyrics mode
	artist_metro = artist_metro:gsub('_','-')
	
	
	artist_x = artist_x:gsub('[-]','_')
	--artist_x = artist_x:gsub('[^%w_]','')
	
	local metrotitle = title_x:gsub('_','-')

	local url = ""
	local lyric_string = ""
	local isLyricsMode = false
	
	if is_lyric_page(lyric_string) == false then		
		local metrourl = "http://www.metrolyrics.com/"..metrotitle.."-lyrics-"..artist_metro..".html"
		--lyric_string = fetch_lyrics(metrourl)
		
		local artist_and_location = string.find(artist_metro, "-and-")

		if artist_and_location then
			artist_and_location = artist_metro:find("and", artist_and_location - 2)
			if artist_and_location then
				local tried_together_and
				local tried_together_withdash
				
				if is_lyric_page(lyric_string) == false then
					--vlc.msg.dbg("location:" .. string.len(artist_metro) - artist_and_location)
					if string.len(artist_metro) - artist_and_location < 14 then
						--quick code path to reduce the number of false tries
						--probably not two separate artists, but one with a & in the name
						--together
						lyric_string = fetch_lyrics(metrourl)
						tried_together_and = true
						
						if is_lyric_page(lyric_string) == false then
							--together with a dash
							local new_artist_metro = artist_metro:sub(1, artist_and_location - 2) .. "-" .. artist_metro:sub(artist_and_location + 4)
							local url = "http://www.metrolyrics.com/"..metrotitle.."-lyrics-"..new_artist_metro..".html" --must be the same as above (except for the new_)
							lyric_string = fetch_lyrics(url)
							tried_together_withdash = true
						end
					end
				end
					
				local first_artist_url		
				if is_lyric_page(lyric_string) == false then
					--first artist
					local new_artist_metro = artist_metro:sub(1, artist_and_location - 2)
					local url = "http://www.metrolyrics.com/"..metrotitle.."-lyrics-"..new_artist_metro..".html" --must be the same as above (except for the new_)
					first_artist_url = url
					lyric_string = fetch_lyrics(url)
				end
				if is_lyric_page(lyric_string) == false then
					--second artist
					local new_artist_metro = artist_metro:sub(artist_and_location + 4)
					local url = "http://www.metrolyrics.com/"..metrotitle.."-lyrics-"..new_artist_metro..".html" --must be the same as above (except for the new_)
					if first_artist_url == url then
						--do nothing
					else
						lyric_string = fetch_lyrics(url)
					end
				end
				
				if is_lyric_page(lyric_string) == false and tried_together_withdash == false then
					--together with a dash
					local new_artist_metro = artist_metro:sub(1, artist_and_location - 2) .. "-" .. artist_metro:sub(artist_and_location + 4)
					local url = "http://www.metrolyrics.com/"..metrotitle.."-lyrics-"..new_artist_metro..".html" --must be the same as above (except for the new_)
					lyric_string = fetch_lyrics(url)
				end
				if is_lyric_page(lyric_string) == false then
					--try again without and between artists
					local new_artist_metro = artist_metro:sub(1, artist_and_location - 2) .. artist_metro:sub(artist_and_location + 4)
					local url = "http://www.metrolyrics.com/"..metrotitle.."-lyrics-"..new_artist_metro..".html" --must be the same as above (except for the new_)
					lyric_string = fetch_lyrics(url)
				end

				if is_lyric_page(lyric_string) == false and tried_together_and == false then
					--together
					lyric_string = fetch_lyrics(metrourl)
				end
			end
		else
			lyric_string = fetch_lyrics(metrourl)
			if is_lyric_page(lyric_string) == false and string.find(artist_metro, 'the%-') then
				local new_artist_metro = artist_metro:gsub('the%-','')
				lyric_string = fetch_lyrics("http://www.metrolyrics.com/"..metrotitle.."-lyrics-"..new_artist_metro..".html")
			end
		end

		source_label:set_text("MetroLyrics")
		isLyricsMode = false;
	end
	--best coverage, but a bit slow to put first
	if is_lyric_page(lyric_string) == false then
		url = "http://sonichits.com/video/" .. artist_x .. "/" .. original_title:gsub("-", "_")
		lyric_string = fetch_lyrics(url)
		source_label:set_text("Sonic Hits")
		isLyricsMode = false
	end
	
	if is_lyric_page(lyric_string) == false then
		url = "http://www.lyricsmode.com/lyrics/"..artist_x:sub(1,1).."/"..artist_x.."/"..title_x..".html"
		lyric_string = fetch_lyrics(url)
		isLyricsMode = true
	end
	
	local first_artist_name
	if is_lyric_page(lyric_string) == false then
		local artist_and_location = artist_x:find("_and_")
		if artist_and_location then
			artist_and_location = artist_x:find("and", artist_and_location - 2)
			--try again without and (first artist)
			local new_artist_x = artist_x:sub(1, artist_and_location - 2)
			first_artist_name = new_artist_x
			url = "http://www.lyricsmode.com/lyrics/"..new_artist_x:sub(1,1).."/"..new_artist_x.."/"..title_x..".html" --must be the same as above (except for the new_)
			lyric_string = fetch_lyrics(url)
			isLyricsMode = true
		end
	end
	
	if is_lyric_page(lyric_string) == false then
		local artist_and_location = artist_x:find("_and_")
		if artist_and_location then
			artist_and_location = artist_x:find("and", artist_and_location - 2)
			--try again without and (second artist)
			local new_artist_x = artist_x:sub(artist_and_location + 4) --length of and + 1
			if first_artist_name == new_artist_x then
				--do nothing
			else
				url = "http://www.lyricsmode.com/lyrics/"..new_artist_x:sub(1,1).."/"..new_artist_x.."/"..title_x..".html" --must be the same as above (except for the new_)
				lyric_string = fetch_lyrics(url)
				isLyricsMode = true
			end
		end
	end
	
	if is_lyric_page(lyric_string) == false then
		local title_dec_loc = title_x:find("twee")
		if title_dec_loc then
			--try again, replacing the full word with a decimal
			local new_title_x = title_x:gsub("twee", "2")
			url = "http://www.lyricsmode.com/lyrics/"..artist_x:sub(1,1).."/"..artist_x.."/"..new_title_x..".html" --must be the same as above (except for the new_)
			lyric_string = fetch_lyrics(url)
			isLyricsMode = true
		end
	end
	
	if is_lyric_page(lyric_string) == false then
		local artist_the_location = artist_x:find("the")
		if artist_the_location then
			--try again without the
			local new_artist_x = artist_x:gsub("the_", "")
			url = "http://www.lyricsmode.com/lyrics/"..new_artist_x:sub(1,1).."/"..new_artist_x.."/"..title_x..".html" --must be the same as above (except for the new_)
			lyric_string = fetch_lyrics(url)
			isLyricsMode = true
		end
	end
	
	if isLyricsMode then
		source_label:set_text("LyricsMode")
		
		if lyric_string == nil then
			return ""
		end
	
		--Lyrics Mode has some problems with encoding, fix these before showing (todo: this crashes on some songs)
		lyric_string = lyric_string:gsub('ґ', "%'") --replace ґt with 't
		lyric_string = lyric_string:gsub('й', "é") --French
		lyric_string = lyric_string:gsub("к", "ê") --French
		lyric_string = lyric_string:gsub("и", "è") --French
		lyric_string = lyric_string:gsub("ы", "û") --French
		lyric_string = lyric_string:gsub("њ", "œ") --French		
		lyric_string = lyric_string:gsub("д", "ä") --German	
			
		--cleanup first lines
		local lower_artist_name = string.lower(artist:get_text())
		local lower_title = string.lower(title:get_text())
		local lower_lyric_string = string.lower(lyric_string)
		local pos_author = lower_lyric_string:find(lower_artist_name)
		local pos_title = lower_lyric_string:find(lower_title)
		local pos_newline = lower_lyric_string:find("\n")
		
		--check if the first line is empty
		if pos_newline then
			if pos_newline == 1 then
				lyric_string = lyric_string:sub(pos_newline+1) --remove the first line (=empty line)
			end
		end
		
		if pos_author then
			--remove author name from first line(s)
			if pos_author < pos_newline then
				--contains
				lyric_string = lyric_string:sub(pos_newline+1) --remove the first line (=artist name)
			end
		end
		
		if pos_title then
			--remove title from first line(s)
			--pos_newline = lyric_string:find("\n", pos_newline+1)
			if pos_title < pos_newline then
				--contains
				lyric_string = lyric_string:sub(pos_newline+1) --remove the first line (=title)
			end
		end
		
		if pos_newline then
			pos_new_newline = lyric_string:find("\n", pos_newline+1)
			--artist:set_text(pos_newline .. "-" .. pos_new_newline)

			if pos_new_newline == pos_newline+1 then

				--next line is empty
				lyric_string = lyric_string:sub(pos_new_newline+1)
			end
		end
	end	

	if is_lyric_page(lyric_string) == false then
		url = "http://www.golyr.de/" .. artist_x:gsub("_","-") .. "/songtext-" .. title_x:gsub("_", "-")
		lyric_string = fetch_lyrics(url)
		source_label:set_text("Golyr.de")
		isLyricsMode = false
	end
	
	if is_lyric_page(lyric_string) == false then
		url = "http://www.azlyrics.com/lyrics/" .. artist_x:gsub("_", "") .. "/" .. title_x:gsub("_", "") ..".html"
		lyric_string = fetch_lyrics(url)
		source_label:set_text("AZ Lyrics")
		isLyricsMode = false
	end
	
	if is_lyric_page(lyric_string) == false then
		url = "http://www.lyrics.com/"..title_x:gsub("_", "-").."-lyrics-"..artist_x:gsub("_", "-")..".html"
		lyric_string = fetch_lyrics(url)
		source_label:set_text("Lyrics.com")
		isLyricsMode = false
	end
	
	if is_lyric_page(lyric_string) == false then
		url = "http://www.lyricsmania.com/"..title_x:gsub("-", "_").."_lyrics_"..artist_x..".html"
		lyric_string = fetch_lyrics(url)
		source_label:set_text("LyricsMania")
	end

	if lyric_string == nil then
		return ""
	else
		return lyric_string
	end
end

function fetch_lyrics(url)
	local metro_pos = url:find('metrolyrics')
	local lyricsmania = url:find('lyricsmania')
	local lyricscom = url:find('lyrics%.com')
	local sonichits = url:find('sonichits')
	local azlyrics = url:find('azlyrics')
	local lyricsmode = url:find('lyricsmode')
	local musixmatch = url:find('musixmatch')
	local golyr = url:find('golyr')
	--http://www.golyr.de/audrey-landers/songtext-honeymoon-in-trindidad
	
	--DEBUG
	--if metro_pos or lyricsmania or sonichits or golyr or lyricsmode then
	--	return ""
	--end

	--debug
	if debug_enabled then
		vlc.msg.dbg("[Lyrics Finder] Fetch " .. url)
		if lyric:get_text():find("http") then
			lyric:set_text(lyric:get_text() ..url.."<br>")
		else
			lyric:set_text(url.."<br>")
		end
	else
		if lyric:get_text():find(translation["message_loading"]) then
			lyric:set_text(lyric:get_text() ..".")
		else
			lyric:set_text(translation["message_loading"])
		end
	end
	dlg:update()
	
	local s = vlc.stream(url)

	if not s then
		return ""
	end
	
	local data = s:read(65535)
	
	data = string.gsub(data, "&#(%d+)", string.char);
	
	if metro_pos then
		--MetroLyrics
		--local _,a = string.find(data, '<div id="lyrics-body-text">')
		local a = string.find(data, 'lyrics%-body%-text', 1)
		
		if a == nil then
			return ""
		end
		
		local endofstring = '>'
		local position = string.find(data, endofstring, a)
		if position == nil then
			return ""
		end		
				
		local b,_ = string.find(data, "</div>", a, true)
		--page does not contain lyrics
		if b == nil then
			return "";
		end
		
		return data:sub(position+1,b-1)
	end
	if lyricsmania then
		local strong_text = "</strong>"
		local lyrics_to = string.find(data, "Lyrics to")
		if lyrics_to == nil then
			return ""
		end
		--, lyrics_to ,  + 
		local _,a = string.find(data, strong_text, lyrics_to)
		if a == nil then
			return ""
		end
		
		local b,_ = string.find(data, "</div>", a + strong_text:len(), true)

		return data:sub(a+1,b-1)
	end
	if lyricsmode then
		--lyrics_text
		--local a = string.find(data, '<p id="lyrics_text" class="ui-annotatable">')
		local a = string.find(data, '<p id="lyrics_text"')
		if a == nil then
			return "";
		end
		local endofstring = '>'
		local position = string.find(data, endofstring, a)
		if position == nil then
			return ""
		end
		local b,_ = string.find(data, "</p>", a, true)
		return data:sub(position+1,b-1)
	end
	if sonichits then
		local a = string.find(data, '<div id="lyrics"')
		if a == nil then
			return "";
		end
		local endofstring = '<br>'
		local position = string.find(data, endofstring, a)
		if position == nil then
			return ""
		end
		position = string.find(data, endofstring, position+1)
		if position == nil then
			return ""
		end
		
		local b = string.find(data, "Contributed by", a)
		if b == nil then
			b = string.find(data, "Lyrics", a)
		end
			
		if b == nil then
			b = string.find(data, "</div>", a)
		else
			b = string.find(data, "<br>", b-10)
		end

		if b == nil then
			return ""
		end

		return data:sub(position+4,b-1)
	end
	
	if golyr then
		local a = string.find(data, '<div id="lyrics"')
		if a == nil then
			return "";
		end
		local endofstring = 'h2'
		local position = string.find(data, endofstring, a)
		if position == nil then
			return ""
		end
		
		position = string.find(data, "h2", position+1)
		if position == nil then
			return ""
		end

		local b = string.find(data, "div", position)

		if b == nil then
			return ""
		end
		return data:sub(position+4,b-1)
	end
	
	if azlyrics then
		local a = string.find(data, 'ringtone')

		if a == nil then
			return "";
		end
		local endofstring = '<div>'
		local position = string.find(data, endofstring, a)
		if position == nil then
			return ""
		end

		local b,_ = string.find(data, "</div>", position, true)
		--artist:set_text(position .. "+" .. b)

		return data:sub(position+5,b-1)
	end
	
	if lyricscom then
		local _,a = string.find(data, 'itemprop="description')
		if a == nil then
			return "";
		end
		local b,_ = string.find(data, "---", a, true)
		return data:sub(a+4,b-1)
	end
	
	return ""
end

function input_changed()
	-- fires on input change (video / audio change)
	-- https://trac.videolan.org/vlc/ticket/5016 and https://forum.videolan.org/viewtopic.php?t=119837
	-- update_metas() --doesn't work (freezes)
	-- requires input-listener
	collectgarbage()
	local title_prev = title:get_text()
	local artist_prev = artist:get_text()
	
	local title_curr = get_title()
	local artist_curr = get_artist()
	
	if title_prev and title_curr then
		if title_prev == title_curr then
			--maybe this song has the same title, but a different performer
			if artist_prev and artist_curr then
				if artist_prev == artist_curr then
					--nothing, do not reload (keep the lyrics as they are)
				else
					lyric:set_text(translation["message_newsong"])
					dlg:set_title(translation["dialogtitle_normal"])
				end
			end
		else
			--it's a different song
			lyric:set_text(translation["message_newsong"])
			dlg:set_title(translation["dialogtitle_normal"])
		end
	end
	
	title:set_text(title_curr)
	artist:set_text(artist_curr)
	dlg:update()
	--click_google()
	collectgarbage()
	--os.execute(string.format('xdg-open "%s"', "https://google.com/search?q=wikipedia"))

	return true
end

function playing_changed()
   -- fires on pause/play
   -- requires playing-listener
end

-- Solve crash problem #14786: https://trac.videolan.org/vlc/ticket/14786
function meta_changed()
   -- triggered by available media input meta data?
   -- requires meta-listener
end

function is_lyric_page(lyric_string)
	if lyric_string=="" or lyric_string==nil then
		return false
	end
	if lyric_string:len() < 40 then
		--debug
		return false
	end
	if lyric_string:find("We are not in a position to display these lyrics due to licensing restrictions. Sorry for the inconvenience.") then
		return false
	end
	if lyric_string:find("No lyrics found for this song") then
		if debug_enabled then
			vlc.msg.dbg("[Lyrics Finder] Data dump: " .. lyric_string)
		end
		return false
	end
	return true;
end

function update_lyrics()
	local songtitle = title:get_text()
	local songartist = artist:get_text()

	local lyric_string = get_lyrics(songtitle, songartist)
	if is_lyric_page(lyric_string) == false then
		if debug_enabled == false then
			if artist:get_text() == "" or title:get_text() == "" then
				lyric:set_text("<i>" .. translation["message_incorrect"] .. "<i>")
			else
				lyric:set_text("<i>" .. translation["message_notfound"] .. "</i>")
			end
		end
		dlg:set_title(translation["dialogtitle_notfound"])
		source_label:set_text("")
		dlg:update()
		return true
	end
	lyric:set_text(lyric_string)
	
	dlg:set_title(translation["dialogtitle_lyricsof"] .. " " .. title:get_text() .. " " .. translation["dialogtitle_performedby"] .. " " .. artist:get_text())
	dlg:update()
	return true
end

-- Get clean title from filename
function get_title()
    local item = vlc.item or vlc.input.item()
    if not item then
        return ""
    end
    local name = item:name()
    local metas = item:metas()
	local uri = item:uri()

	if uri:find("googlevideo") == nil then
		if metas["now_playing"] then
			name = metas["now_playing"]
		else
			if metas["title"] then
				if metas["title"]:find("%.") > string.len(metas["title"]) - 6 then
					-- this is no real metadata because it contains a dot near the end (as extension of a file name)
					-- instead this is playlist data (could be a m3u playlist)
					-- use the parsing from below
				else
					return metas["title"]
				end
			end
		end
	--else
	--	vlc.msg.dbg(item:name())
	--	vlc.msg.dbg(metas["title"])
	end
	        
    local filename = string.gsub(name, "^(.+)%.%w+$", "%1")
	local pos = filename:find("-")
	local spacepos = filename:find("%s")
		
	if pos == nil then
		return "" --invalid things
	end
	
	if spacepos == nil then
		return "" --invalid things (for example "-IRememberYou")
	end
	
	if pos < spacepos then
		local oldpos = pos
		pos = filename:find("-", spacepos)
		if pos == nil then
			pos = oldpos
		end
	end
	local parpos = filename:find("%(")
	if parpos == nil then
		parpos = filename:len() + 2
	end
	filename = string.gsub(filename, " - Lyrics", "")
		
	local hyphenpostwo = filename:find("-", pos + 1)
	if hyphenpostwo then
		pos = hyphenpostwo --Olivia Newton-John
	end
		
	local amount = 2;
	local space_after_pos = filename:find("%s", pos)
	if space_after_pos == nil then
		--no space after pos
		amount = 1
	else
		--was +1
		if space_after_pos > pos - 1 then
			amount = 1
		end
	end
		
    filename = string.sub(filename, pos + amount, parpos - amount)
    filename = string.gsub(filename, " Lyrics", "")
    filename = string.gsub(filename,"ft%..*","") --remove featuring (TODO: if Title - Author gets implemented, make this more robuust)
    filename = string.gsub(filename,"feat%..*","") --remove featuring (TODO: if Title - Author gets implemented, make this more robuust)
    filename = string.gsub(filename, "@.*","")
	filename = string.gsub(filename," with Lyrics","") --remove with lyrics
	filename = string.gsub(filename,"_ll","%'ll") --remove with lyrics
        
    return trim(filename)
end

-- Get clean artist from filename
function get_artist()
    local item = vlc.item or vlc.input.item()
    if not item then
		--no song loaded
        return ""
    end
    local name = item:name()
    local metas = item:metas()
    local uri = item:uri()
    
	if uri:find("googlevideo") == nil then
		if metas["now_playing"] then
			name = metas["now_playing"]
		else
			if metas["artist"] then
				return metas["artist"]
			end
		end
	--else
	--	vlc.msg.dbg(item:name())
	--	vlc.msg.dbg(metas["title"])
	end
    
	--unknown metadata, make a guess
	local filename = string.gsub(name, "^(.+)%.%w+$", "%1")

	local hyphenpos = filename:find("-")
	local spacepos = filename:find("%s")
		
	if hyphenpos == nil then
		--item:name() does not contain a hyphen. probably metadata is title only
		--filename = item:uri()
		filename = string.gsub(item:uri(),".*/","") --tested on Linux and Windows
		filename = string.gsub(filename,"%%20"," ") --replace space
		filename = string.gsub(filename,"%%2C", ",") --replace comma
		filename = string.gsub(filename,"%%26", "and") --replace & by and
		filename = string.gsub(filename,"%%27", "") --replace single quote by nothing
		filename = string.gsub(filename,"%%21","!") --replace exclamation mark by exclamation mark :)
		filename = string.gsub(filename,"%s_%s", " and ") --replace underscore with spaces by and
		filename = string.gsub(filename, "/^(.+)(\\.[^ .]+)?$/", "") --remove extension

		hyphenpos = filename:find("-")
		spacepos = filename:find("%s")
	end
	if spacepos == nil then
		--return "notok"
		--spacepos = 0
	end

	if hyphenpos == nil then
		return "" --invalid things
	end
	
	if spacepos == nil then
		return "" --invalid things (for example "-IRememberYou")
	end
		
	if hyphenpos < spacepos then
		local oldpos = hyphenpos
		hyphenpos = filename:find("-", spacepos) --was not the right hyphen (a-ha)
				
		if hyphenpos == nil then
			hyphenpos = oldpos
		end	
	else
		spacepos = filename:find("%s", hyphenpos-2)
	end
	filename = string.gsub(filename,"ft%..*","") --remove ft.
	filename = string.gsub(filename,"feat%..*","") --remove feat.

	local amount = 2
	local space_after_pos = filename:find("%s", hyphenpos)

	if space_after_pos == nil then
		--no space after hyphenpos (Artist-Title)
		amount = 1
	else
		--space after hyphenpos (Artist- Title)
		--equal to or greather than (was space_after_pos > hyphenpos + 1)
		if space_after_pos > hyphenpos - 1 then
			amount = 1
		end
	end

	local hyphenpostwo = filename:find("[-]", hyphenpos + 1)
	if hyphenpostwo == nil then
		return string.sub(filename, 1, hyphenpos - amount)
	else
		return string.sub(filename, 1, hyphenpostwo - amount) --Olivia Newton-John
	end
end

-- Remove leading and trailing spaces
function trim(str)
    if not str then return "" end
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

-- Source: http://stackoverflow.com/questions/11163748/open-web-browser-using-lua-in-a-vlc-extension
-- Attempts to open a given URL in the system default browser, regardless of Operating System.
local open_cmd -- this needs to stay outside the function, or it'll re-sniff every time...
function open_url(url)
    if not open_cmd then
        if package.config:sub(1,1) == '\\' then -- windows
            open_cmd = function(url)
                -- Should work on anything since (and including) win'95
                os.execute(string.format('start "%s"', url))
            end
        -- the only systems left should understand uname...
        elseif (io.popen("uname -s"):read'*a') == "Darwin" then -- OSX/Darwin ? (I can not test.)
            open_cmd = function(url)
                -- I cannot test, but this should work on modern Macs.
                os.execute(string.format('open "%s"', url))
            end
        else -- that ought to only leave Linux
            open_cmd = function(url)
                -- should work on X-based distros.
                os.execute(string.format('xdg-open "%s"', url))
            end
        end
    end

    open_cmd(url)
end

--GPL code from VLSub
function is_window_path(path)
	return string.match(path, "^(%a:\\).+$")
end