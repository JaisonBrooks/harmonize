# Harmonize
Let me ask you. How does your Downloads folder look? Is it unorganized, cluttered or a mess? Do you have any other folder's that look this way too?. If you do, then you know that the thought of organizing said files can be daunting, not to mention that actual act of doing it. On a second note, we also have to remember that file management and organization is a constant battle we must face, in order to maintain a clean and organized file system.

So... Without further ado! Ladies and Gentleman, I present you with ***Harmonize***

## About
***Harmonize***, is a Ruby script that helps you organize your files by grouping them together into Types. For instance, it can group your jpg and png files as photos and your pdf and doc files as documents and plenty more file extensions and groupings. The tool features plenty of easy to use command line options which allows you to get lots of work done, quickly and easily, with just a simple command. This tool is used from within the OSX Terminal.app or any other prefered terminal.


### Usage
```~:$ harmonize TYPES ARGUMENTS```

You can view the ```-h``` to view the help page for more information on how to use Harmonize.

### Types
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
 Desc: Specifying all allow you to include all the default types and their cooresponding file extensions when looking up the files you want to harmonize.
 ***Note***, if you dont specify a TYPE (```harmonize ```) when executing the script, Harmonize will assume you want to want to harmonize files for all supported file groups.
Everything or '*'
 Desc: Using this option will perform a straight cut and paste, moving all files and folders from your INPUT directory to your OUPUT directory. ***Note***, you must include a single quote at the beginning and end of the *.
```
To ensure your aware of all the current types and file extensions, please run ```harmonize types``` to view latest information.

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

### Setup / Installation
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

***NOTE*** Please ensure that /usr/local/bin is stored in your PATH!

### Disclaimer
This script is new and could be considered **alpha** or **not fully* tested and could result in overwritten files, file corruption, script execution errors, bugs, random explosions and more. You have been warned! and by using this tool, you agree that I AM NOT responsible for lost or damange to your files.

### Version
0.6

### Author
Jaison Brooks
