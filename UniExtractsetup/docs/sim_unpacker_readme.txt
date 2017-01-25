"Smart Install Maker" unpacker
--
Extracts the content of any installer created with "Smart Install Maker".
This tool will produce three files:
	installer.config - contains the actual installer configuration
	runtime.cab - CAB archive of the installer customisations
	data.cab - CAB archive of the installed contents

All of the entries of data.cab are NOT named user friendly. However, you can use the installer.config to determine the file names.
--
Use this tool at your own risk!

--
(c) XpoZed / nullsecurity.org, 2012