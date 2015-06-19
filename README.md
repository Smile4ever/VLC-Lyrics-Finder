VLC Lyrics Finder
==============

VLC media player extension

Installation
-------------
1. Download [lyricsfinder.lua](https://raw.githubusercontent.com/alexxxnf/VLC-Lyrics-Finder/master/lyricsfinder.lua) (Use **File -> Save as** if necessary).
2. Move the file to lyricsfinder.lua to **lua/extensions** inside your VLC folder. For example, **C:\Program Files\VideoLAN\VLC\lua\extensions\lyricsfinder.lua**
3. To install the language files, put them inside your VLC folder in the subdirectory **lua/extensions/lyricsfinder/locale**. For example, **C:\Program Files\VideoLAN\VLC\lua\extensions\lyricsfinder\locale**
3. Restart VLC or open **Tools -> Plugins and extensions** and hit **reload extensions**.

VLC folder path:

* Windows 32 bit: **C:\Program Files\VideoLAN\VLC\lua\extensions\**
* Windows 64 bit: **C:\Program Files (x86)\VideoLAN\VLC\lua\extensions\**
* Linux user path: **/home/$USER/.local/share/vlc/lua/extensions**
* Linux system path: **/usr/share/vlc/lua/extensions**

Usage
-------
1. Go to **View -> Lyrics Finder**.
2. Make sure *title* and *artist* are correct.
3. Hit **Get Lyrics**.

Other buttons:

* Search with Google: open a new browser tab to look for lyrics
* Refresh: force refresh of metadata and look up the lyrics
* Switch: artist and title wrongly guessed? Click this button to switch them. The artist text becomes the title text, the title text becomes the artist text.

Intelligent guessing
--------------------
Since version 0.3.0, this script supports intelligent guessing. This means that when you name your files properly, it will detect the artist and song title from the filename. Good examples of file names:

* Artist - Title (year of release) -> Steve Allen - Letter From My Heart (1984)
* Artist - Title -> Steve Allen - Letter From My Heart
* Artist - Title (anything): the information between parenthesis is discarded

Wrong file names:
* Title - Artist
* File names that contain two hyphens, like "Artist - Title - Album name"

If your files contain metadata, Lyrics Finder uses that information. Otherwise, it uses intelligent guessing.

Translation
-------
If you would like to make a translation of Lyrics Finder to your own language, follow these steps:

1. [Make an account at Transifex](https://www.transifex.com/signup/)
2. [Start translating](https://www.transifex.com/projects/p/vlc-lyrics-finder/translate/)

If the language you want to translate is not present, [make an issue](https://github.com/alexxxnf/VLC-Lyrics-Finder/issues) asking to add the desired language.