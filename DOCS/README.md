# VS_XML_Doc_Viewer
IIS application used to translate the XML files created by Visual studio.
It does so by searching a specified directory and getting an index of the files in the directory.  It then uses a custom xsl file to transofrm the xml file into a human-readable
format.

## File Path
This application uses a constant file path in the Home controller.  Before you run it, make sure to change the file path to wherever your application can access the files.