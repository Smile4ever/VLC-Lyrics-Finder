0.3.6
=====
* Fix support for MetroLyrics
* Add a few texts to the invalid lyrics detection
* Bulgarian translation
* Ukrainian translation

0.3.5
=====
* Improve/fix MetroLyrics support
* Make installer for Windows compatible with mixed installations (32 bit VLC on 64 bit Windows)
* Expand README to include MetroLyrics

0.3.4.1
=====
* Fix uninstaller

0.3.4
=====
* Fix for "no song loaded" scenario, updated locales
* Fix for #7 (Google does not work with spaces on Windows)
* Update NSIS setup file to support WoW systems, fixes #6
* Remove w_lyrics from filename
* fix: check for LANG variable to exist, otherwise take LC_ALL
* confirm working of `open` cmd
* remove unnecessary variable and correct read argument, see http://www…
* mac layout fixes - resolves #4
* fix osx specifics, e.g. fix language
* README: fix URL to installer for Windows
* Updated readme: add OS X path, fixes #3
* Fix spelling mistake in comment
* Trim artist & title, fix for Wham! - Wake Me Up Before You Go-Go

0.3.3
=====
* Crash fix for attempt to perform arithmetic on a nil value (local
* Fix for nil compare
* LyricsMode does not use "and"

0.3.2
=====
* Improve support for LyricsMode for artists with the same name (Womack & Womack - MPB)
* Fix button Get Updates
* Improve handling of space_space as space&space
* Expanded usage section of README
* Fix spelling mistake in README
* Expanded README with a way to add your own lyrics
* Increase LyricsMode priority
* Improve support for groups that start with "the" on MetroLyrics
* Don't try to fetch the same URL twice for Womack & Womack (and similar)

0.3.1.1
=====
* Crash fix

0.3.1
=====
* Updated README for version 0.3.1
* Better handling of M3U playlists and improvents to parsing and fetching of lyrics
* Update exe installer with Roisin Murphy fix
* Fix for Roisin Murphy
* Fix mistake in README
* Fix layout
* Updated README with Windows installer
* NSIS installer for Windows
* Minor change to Turkish
* Add Turkish translation (tur.xml)
* Updated Dutch translation
* Cleanup: do not output string values of translation
* Prevent crash when the file name does not contain spaces but does con…
* Fix for unequal space in artist name, for example "The Alan Parsons P…
* Do not wrap
* Screenshot below intro
* Add screenshot to README
* Do not refresh the lyrics when the same song is repeatedly played
* Improvement to csv-to-xml script for generating xml files from transifex
* Add afr.xml (translation for Afrikaans)
* Small translation fix for Spanish
* Correct Spanish translation
* Add fre.xml (French) and spa.xml (Spanish)
* ...

0.3.0
=====
* Add 6 additional lyrics websites
* Add intelligent guessing based on URI
* Add support for network streams (IceCast) that have a Now Playing attribute
* Add translation support
* Add GPL header
* Wider window
* Search with Google button
* Switch artist and title with one click on the button Switch
* Song change updates the metadata in Lyrics Finder
* Better error messages
* Add debug mode
* Bugfixes
* ...