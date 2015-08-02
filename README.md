VLC Lyrics Finder
==============

VLC media player lyrics extension. Supports MetroLyrics, Sonic Hits, Lyrics Mode, Golyr.de, AZ Lyrics, Lyrics.com and Lyricsmania.com.

![Lyrics Finder 0.3.0 on Linux](http://hugsmile.eu/file/lyricsfinder/screenshot-v030.png)

Installation
-------------
Download installer for Windows: [install](https://github.com/Smile4ever/VLC-Lyrics-Finder/raw/master/lyricsfinder-0.3.1.1.exe)

Installation steps for Linux and OS X:

1. Download [lyricsfinder.lua](https://raw.githubusercontent.com/Smile4ever/VLC-Lyrics-Finder/master/lyricsfinder.lua) (Use **File -> Save as** if necessary).
2. Move the file lyricsfinder.lua to **lua/extensions** inside your VLC folder. For example, **C:\Program Files\VideoLAN\VLC\lua\extensions\lyricsfinder.lua**
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
* Artist-Title: also works without spaces before and after the hyphen


Wrong file names:
* Title - Artist
* File names that contain two hyphens, like "Artist - Title - Album name". There is one exception: artist names that contain a hyphen are valid. For example "A-ha - Stay On These Roads".

If your files contain metadata, Lyrics Finder uses that information. Otherwise, it uses intelligent guessing.

Sources
-------
Lyrics Finder gets its lyrics from several websites. If Lyrics Finder is unable to find lyrics for your song, verify that you comply with the Intelligent Guessing Format (see above) or make sure that you have proper metadata tags attached to your files.

With so many sites supported, it's still imaginable that the lyrics for a specific song are not yet available. You can [add them yourself using LyricsMode](http://www.lyricsmode.com/lyrics_submit.php).

Translation
-------
If you would like to make a translation of Lyrics Finder to your own language, follow these steps:

1. [Make an account at Transifex](https://www.transifex.com/signup/)
2. [Start translating](https://www.transifex.com/projects/p/vlc-lyrics-finder/)

If the language you want to translate is not present, [make an issue](https://github.com/Smile4ever/VLC-Lyrics-Finder/issues) asking to add the desired language or request a language on Transifex.