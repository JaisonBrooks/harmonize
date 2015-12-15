# Harmonize
Let me ask you. How does your Downloads folder look? Is it unorganized, cluttered or a mess? Do you have any other folder's that look this way too?. If you do, then you know that the thought of organizing said files can be daunting, not to mention that actual act of doing it. On a second note, we also have to remember that file management and organization is constant action we must take in order to maintain a clean and organized file system.

So, without further ado. Ladies and Gents, I present you with ***Harmonize***

## About
***Harmonize***, is a Ruby script that helps you organize your files by groups, like grouping your jpg's and png's as photos and pdf's xlsx's as documents and plenty more file extensions and grouping's, take a look below for all supports groups and extensions. The script also have has a very simple command line interface and ofter's alot of useful arguments to let you trailer the tool to fit your needs.

```~:$ harmonize TYPES ARGUMENTS``` 

## Supported Types and Arguments

### Types


****Note**** - Run ```harmonize types``` to view latest types & supported file extensions
### Arguments
```
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



With the ability to let harmonize use your default OSX folders (~/Pictures,~/Documents, etc) flexible INPUT / OUPUT arguments allow you to organize files quickly. With simple file type keyboards, you can easily move specific types of files between directories or even just allow Harmonize to move and organize everything for you.

!WARNING!
This script is alpha and could result in overwritten files, file corruption, script execution errors, bugs, random explosions and more. You have been warned! and by using this tool, you agree that I AM NOT responsible for lost or damange to your files.

### Setup
* Clone the Repo

```
git clone https://github.com/JaisonBrooks/harmonize.git
```

* Run the following commands (from the root of the project):
 
```
cd harmonize.git/src/
chmod u+x init_harmonize.sh
sh ./init_harmonize.sh
```

* Wait a moment for the script to complete

The ```init_harmonize.sh``` creates a executable binary file and stores it here => /usr/loca/bin/harmonize.

***NOTE*** Please ensure that /usr/local/bin is stored in your PATH!

### Usage
Run the following command to view the help page which contains the supported file types, arguments and examples on how to use the tool.

```
harmonize -h
```

General Info (***subject to change***):

![Alt text](/res/screenshot_help_harmonize.png?raw=true "General Info")

Supported Params (***subject to change***):

![Alt text](/res/screenshot_params_harmonize.png?raw=true "Support Params")

### Version
0.3

### Author
Jaison Brooks
