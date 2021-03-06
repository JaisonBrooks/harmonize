# Harmonize
Let me ask you. How does your Downloads folder look? Is it unorganized, cluttered or a mess? Do you have any other folder's that look this way too?. If you do, then you know that the thought of organizing said files can be daunting, not to mention that actual act of doing it. On a second note, we also have to remember that file management and organization is a constant battle we must face, in order to maintain a clean and organized file system.

So... Without further ado! Ladies and Gentleman, I present you with ***Harmonize***

## About
***Harmonize***, is a Ruby script, currently written and tested on OSX, that helps you organize your files by grouping them together into basic Types. 

For instance, it can group your jpg and png files as photos and your pdf and doc files as documents and several other groups. 

The tool also features plenty of easy to use command line arguments, which allows you to get lots of work done, quickly and easily, by executing a simple command from your Terminal. You can really tailor this tool to fit your needs and feel free to take a look at the Arguments sections for more information.

## Usage
```~:$ harmonize TYPES ARGUMENTS```

You can view the help page by executing ```harmonize -h```, which has tons of useful information and examples on how to use the script.

### TYPES
#### Standard
```
Pictures
	Tags: 'pictures', 'pics', 'images', 'photos'
	Exts: 'jpg', 'gif', 'jpeg', 'png', 'svg', 'tif', 'tiff', 'icon', 'raw', 'bmp', 'psd', 'webp', 'ai', 'eps', 'ps', 'svg'
Movies
	Tags: 'movies', 'videos', 'shows', 'tv'
	Exts: 'mov', 'mpeg', 'avi', 'mp4', 'arf', 'mkv', 'webm', 'qt', 'wmv', 'rm', 'm4v', 'flv', 'avc', 'vob', 'mjpeg', 'egp', 'mpg', '3gpp', 'mpg4', 'xvid', 'mjpg' 
Music
 	Tags: 'music', 'tunes', 'jams'
 	Exts: 'aif', 'iff', 'm3u', 'm4a', 'mid', 'mp3', 'mpa', 'ra', 'wav', 'wma', 'aac'
Documents
 	Tags: 'documents', 'docs'
 	Exts: 'doc', 'docx', 'log', 'msg', 'odt', 'pages', 'rtf', 'tex', 'txt', 'wpd', 'wps', 'xlr', 'xls', 'xps', 'potx', 'potm', 'xlsx', 'pps', 'ppsx', 'odp', 'pptx', 'ppt', 'pdf', 'ppdf'
Data
 	Tags: 'data'
 	Exts: 'csv', 'dat', 'gbr', 'key', 'keychain', 'vcf', 'json', 'xm', 'mdb', 'pdb', 'sql', 'dbl'
Programs
 	Tags: 'programs', 'exec', 'executables', 'binaries'
 	Exts: 'apk', 'app', 'deb', 'jar', 'exe', 'iso', 'pkg', 'dmg'
Code
 	Tags: 'code', 'scripts'
 	Exts: 'css', 'html', 'coffee', 'js', 'php', 'xhtml', 'java', 'py', 'pl', 'cs', 'c', 'lua', 'h', 'cpp', 'class', 'swift', 'scss', 'less', 'rb', 'sh', 'bat'
Archives
 	Tags: 'archives', 'zips'
 	Exts: 'zip', '7z', 'gz', 'rar', 'bz2', 'bz', 'tar', 'zipx'
 ```
 The Standard types can used individually (```harmonize pics```) or combined in a comma seperated list (```harmonize 'pics,archives,programs'```). ***Note***, you must include a single quote at the beginning and end of the comma seperated list.
 
####Special
```
All or all
```
Includes all the Standard types and their cooresponding files extensions. ***Note***, this will also be the case, if you ***DONT*** specify a TYPE (```harmonize```).
```
Everything or '*'
```
Performs a straight cut and paste, by moving all files and folders from your INPUT directory to your OUPUT directory. ***Note***, you must include a single quote at the beginning and end if you use the *.

To view the latest, run ```harmonize types```.


### ARGUMENTS
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
To view the latest, run ```harmonize -h```.

### Defaults
**INPUT** : The INPUT directory defaults to your current working directory, or the location your at when executing harmonize. You can always specify a different input by using the ```-i``` option.

**OUTPUT** : The OUTPUT directory defaults to your Home folder (~/ or /Users/USERNAME). This is nice because OSX have default folders for things like Pictures, Documents, Music and more. 

## Setup / Installation
* Clone the Repo

```
git clone https://github.com/JaisonBrooks/harmonize.git
```

* Run the following commands:
 
```
cd Harmonize.git
chmod u+x src/setup.sh
sh src/setup.sh
```

* Await script completion:

The ```setup.sh``` will create a executable file and store it in => /usr/local/bin.

***Note***, Please ensure that /usr/local/bin is stored in your PATH!

## Disclaimer
This script is new and could be considered **alpha** and/or ***not fully*** tested and could result in overwritten files, file corruption, script execution errors, bugs, random explosions and more. You have been warned and by using this tool, you agree that I (Jaison Brooks), am NOT responsible for any damage, misplacement or cooruption of your file(s) and or folder(s).

## Version
0.6

## Author
Jaison Brooks
