swfextract - SWF element extraction: Movieclips, Sounds, Images, shapes, etc 
Usage: ./swfextract [-v] [-n name] [-ijf ids] file.swf
  [switches]
	-v , --verbose			 Be more verbose
	-o , --output filename		 set output filename
	-V , --version			 Print program version and exit

SWF Subelement extraction:
	-n , --name name		 instance name of the object (SWF Define) to extract
	-i , --id ID			 ID of the object, shape or movieclip to extract
	-f , --frame frames		 frame numbers to extract
	-w , --hollow			 hollow mode: don't remove empty frames
	             			 (use with -f)
	-P , --placeobject			 Insert original placeobject into output file
	             			 (use with -i)
SWF Font/Text extraction:
	-F , --font ID			 Extract font(s)
Picture extraction:
	-j , --jpeg ID			 Extract JPEG picture(s)
	-p , --pngs ID			 Extract PNG picture(s)

Sound extraction:
	-m , --mp3			 Extract main mp3 stream
	-M , --embeddedmp3			 Extract embedded mp3 stream(s)
	-s , --sound ID			 Extract Sound(s)