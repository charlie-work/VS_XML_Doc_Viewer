# Visual Studio XML Documentation Viewer
IIS application used to translate the XML files created by Visual studio.
It does so by searching a specified directory and getting an index of the files in the directory.  It then uses a custom xsl file to transofrm the xml file into a human-readable
format.

## File Path
This application uses a constant file path in the Home controller.  Before you run it, make sure to change the file path to wherever your application can access the files.

## Enabling XML Generation for Applications
To enable XML generation in your project, go to properties -> Build -> Output. 
Specify an output path, and check the box next to "XML documentation file"

## Commenting your code
To make your xml comments, be sure to type /// above your parameters, methods, and classes.  VS will auto-create some of the xml comments for you.
See the <a href="https://docs.microsoft.com/en-us/visualstudio/ide/reference/generate-xml-documentation-comments?view=vs-2019"> MSDN</a> for more reference.


# Why this application?
I made this because I am not allowed to run DocFX or Sandcastle in my work environement - this is my solution to that.
