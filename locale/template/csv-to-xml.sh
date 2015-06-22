#!/bin/sh
#Script to convert LibreOffice csv in the parent of the current directory to xml
#empty.xml is the LibreOffice template to quickly create the input csv
#
#Input
#
#<dialogtitle_normal>,Text,</dialogtitle_normal>
#<dialogtitle_notfound>,Text,</dialogtitle_notfound>
#<dialogtitle_lyricsof>,Text,</dialogtitle_lyricsof>
#
#Output
#
#<dialogtitle_normal>Text</dialogtitle_normal>
#<dialogtitle_notfound>Text</dialogtitle_notfound>
#<dialogtitle_lyricsof>Text</dialogtitle_lyricsof>

cd ..
for filename in `ls *.csv`
do
	sed -i 's/>,/>/' $filename
	sed -i 's/,</</' $filename
	sed -i 's/,,//' $filename
	sed -i 's/\"//' $filename
	mv "$filename" "`basename $filename .csv`.xml"
done