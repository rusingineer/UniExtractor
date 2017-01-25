unshield v1.3 by David Eriksson
Файл скомпилирован 18.01.2016 с исправлениями из исходников https://github.com/twogood/unshield участником конференции ru-board Tilks (http://forum.ru-board.com/topic.cgi?forum=5&topic=20420&start=1460#7)

Syntax:

unshield.exe [-c COMPONENT] [-d DIRECTORY] [-D LEVEL] [-g GROUP] [-i VERSION] [-e ENCODING] [-GhlOrV] c|g|l|t|x CABFILE [FILENAME...]

Options:
        -c COMPONENT  Only list/extract this component
        -d DIRECTORY  Extract files to DIRECTORY
        -D LEVEL      Set debug log level
                        0 - No logging (default)
                        1 - Errors only
                        2 - Errors and warnings
                        3 - Errors, warnings and debug messages
        -g GROUP      Only list/extract this file group
        -h            Show this help message
        -i VERSION    Force InstallShield version number (don't autodetect)
        -e ENCODING   Convert filename character encoding to local codepage from ENCODING (implicitly sets -R)
        -j            Junk paths (do not make directories)
        -L            Make file and directory names lowercase
        -O            Use old compression
        -r            Save raw data (do not decompress)
        -R            Don't do any conversion to file and directory names when extracting.
        -V            Print copyright and version information

Commands:
        c             List components
        g             List file groups
        l             List files
        t             Test files
        x             Extract files

Other:
        CABFILE       The file to list or extract contents of
        FILENAME...   Optionally specify names of specific files to extract

######################################################################################################
-e ENCODING   Convert filename character encoding to local codepage from ENCODING (implicitly sets -R)
"This version of Unshield is not built with encoding support."
