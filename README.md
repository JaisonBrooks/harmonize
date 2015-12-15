# Harmonize
Let me ask you. How does your Downloads folder look? Is it unorganized, cluttered or a mess? Do you have any other folder's that look this way too?. If you do, then you know that the thought of organizing said files can be daunting, not to mention that actual act of doing it. On a second note, we also have to remember that file management and organization is constant action we must take in order to maintain a clean and organized file system.

So, without further ado. Ladies and Gents, I present you with ***Harmonize***

## About
***Harmonize***, is a Ruby script that helps you organize your files by groups, like grouping your jpg's and png's as photos and pdf's xlsx's as documents and plenty more file extensions and grouping's, take a look below for all supports groups and extensions. The script also have has a very simple command line interface and ofter's alot of useful arguments to let you trailer the tool to fit your needs.

```~:$ harmonize TYPES ARGUMENTS``` 

## Supported Types and Arguments

### Types
```ruby
Standard Types & Extensions:
 Pictures
  TAGS: ["pictures", "pics", "images", "photos"]
  EXTS: ["jpg", "gif", "jpeg", "png", "svg", "tif", "tiff", "ico", "raw", "bmp", "psd", "webp", "ai", "eps", "ps", "svg"]
 Movies
  TAGS: ["movies", "videos", "shows", "tv"]
  EXTS: ["mov", "mpeg", "avi", "mp4", "arf", "mkv", "webm", "qt", "wmv", "rm", "m4v", "flv", "avc", "vob", "mjpeg", "egp", "mpg", "3gpp", "mpg4", "xvid", "mjpg"]
 Music
  TAGS: ["music", "tunes", "jams"]
  EXTS: ["aif", "iff", "m3u", "m4a", "mid", "mp3", "mpa", "ra", "wav", "wma", "aac"]
 Documents
  TAGS: ["documents", "docs"]
  EXTS: ["doc", "docx", "log", "msg", "odt", "pages", "rtf", "tex", "txt", "wpd", "wps", "xlr", "xls", "xps", "potx", "potm", "xlsx", "pps", "ppsx", "odp", "pptx", "ppt", "pdf", "ppdf"]
 Data
  TAGS: ["data"]
  EXTS: ["csv", "dat", "gbr", "key", "keychain", "vcf", "json", "xm", "mdb", "pdb", "sql", "dbl"]
 Programs
  TAGS: ["programs", "exec", "executables", "binaries"]
  EXTS: ["apk", "app", "deb", "jar", "exe", "iso", "pkg", "dmg"]
 Code
  TAGS: ["code", "scripts"]
  EXTS: ["css", "html", "coffee", "js", "php", "xhtml", "java", "py", "pl", "cs", "c", "lua", "h", "cpp", "class", "swift", "scss", "less", "rb", "sh", "bat"]
 Archives
  TAGS: ["archives", "zips"]
  EXTS: ["zip", "7z", "gz", "rar", "bz2", "bz", "tar", "zipx"]
Special Types:
 All
  TAGS: All the above Tags
 Everything
  TAGS: ["*", "everything"]
  EXTS: All files and folders
```

Types can be used as a single value (```harmonize pictures```) or as a command seperated list (```harmonize 'pictures,movies,music'```). ***Note***, you need to include a single quotes at the beginning and end of a command seperate list of types or the wildcard type '*'.

****Note**** - Run ```harmonize types``` to view latest types & supported file extensions
### Arguments
```ruby
-i, --input FOLDER_PATH   :  Where to look for files ( Default: Current Directory )
-o, --output FOLDER_PATH  :  Where to moves your files too ( Default: ~/ )
-r, --recursive           :  Include all sub folders and files ( BE CAREFUL )
-f, --force               :  Overwrite any duplicate files ( BE CAREFUL )
-d, --dry                 :  Only move files to the output folders root
-l, --launch              :  Opens finder to your output folder after completion
-p, --pretend             :  Only pretends to move your files, run to see what the script would do
-v, --verbose             :  Include extra output to the console regarding script exection
-h, --help                :  View the help page
```
****Note**** - Run ```harmonize -h``` to view latest arguments

### Defaults
**INPUT** : The INPUT directory defaults to your current working directory, or the location your at when executing harmonize. You can always specify a different input by using the ```-i``` option.

**OUTPUT** : The OUTPUT directory defaults to your Home folder (~/ or /Users/USERNAME). This is nice because OSX have default folders for things like Pictures, Documents, Music and more. 

### Disclaimer
This script is new and could be considered **alpha** or **not fully* tested and could result in overwritten files, file corruption, script execution errors, bugs, random explosions and more. You have been warned! and by using this tool, you agree that I AM NOT responsible for lost or damange to your files.

### Setup / Installation
* Clone the Repo

```
git clone https://github.com/JaisonBrooks/harmonize.git
```

* Run the following commands (from the root of the project):
 
```
chmod u+x src/setup.sh
sh src/setup.sh
```

* Wait a moment for the script to complete

The ```setup.sh``` will create a executable file and store it as => /usr/loca/bin/harmonize.

***NOTE*** Please ensure that /usr/local/bin is stored in your PATH!

### Usage
Run the following command to view the help page which contains the supported file types, arguments and examples on how to use the tool.

```
harmonize -h
```
There is plenty of good helpful information in the help page, including examples and more.


### Version
0.6

### Author
Jaison Brooks
