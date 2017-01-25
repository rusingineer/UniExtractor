lessmsi   

This is a utility with a graphical user interface and a command line interface that can be used to view and extract the contents of an MSI file. 

To extract from the command line:
 lessmsi x <msiFileName> [<outouptDir>]

For more command line usage see CommandLine.

Command Line
 scott willeke edited this page on Dec 2, 2013 ·  3 revisions 

This is all implemented and working as of the v1.1.0 release (March 2013).
Use Cases
open file in GUI via command line
specify path to extract all files
Specify file(s) to extract (issue 23)
output msi version
output msi table to csv (patch in issue 26)
Syntax
lessmsi <command> [switches] <msi_name> [<path_to_extract\>] [file_names]

Note: If no command is specified the GUI opens.
Commands
Command o: - Open in GUI

Opens the specified  msi_name  in the GUI.
 switches : Not supported.
 msi_name : The name of the msi to open in the GUI
 path_to_extract : Not supported.
 file_names : Not supported.
Examples
lessmsi o theinstall.msi
Command x: - Extract

Extracts from the specified archive.
 switches : Not supported.
 msi_name : (required) specifies the msi to extract files from
 path_to_extract : (optional) The path to extract the files to. MUST have trailing backslash or it will be treated as one of the  file_names .
 file_names : (optional) Names of files that you want to extract from the msi. All files are extracted if not specified.

Note: There is a known bug err "limitation" that you can only specify the name of the file (not the path). Therefore if there are multiple instances of the file inside the msi with the same name and you want to extract that file there is no way to specify which file to extract. If this is a problem for you report an issue and if I know it is important to someone I'll take the time to make that work.

Note:  /x  will work as the "command" for backward compatibility. The  /x  command is obsolete. It may be removed in the future!
Examples

Extracts all files from  theinstall.msi  into the current directory:
lessmsi x theinstall.msi

Extracts  a.txt  and  b.txt  from  c:\theinstall.msi  into the directory  c:\theinstallextracted .
lessmsi x c:\theinstall.msi c:\theinstallextracted\ a.txt b.txt
Command l: List

Lists the specified file table as a csv.
switches:
 -t  (required): Switch to specify which MSI table to extract.
 msi_name : (required) The name of the msi to open extract the table from.
 path_to_extract : Not supported.
 file_names : Not supported.
Examples
lessmsi l -t Component c:\theinstall.msi
Command v: Version

Prints out the msi version.
switches: Not supported.
msi_name: (required) The name of the msi to display the version from.
path_to_extract: Not supported.
file_names: Not supported.
Examples
lessmsi v c:\theinstall.msi