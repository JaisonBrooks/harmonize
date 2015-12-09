# Harmonize
Let me ask you, how does your Downloads folder look? Unorganized? Cluttered? or any other folder for that matter. Rather than spending the time to organize it, moving photos to a photos folder and documents to their cooresponding folder, just to have to do it again when it gets cluttered again.

Ladies and Gents, i present you with **Harmonize**

***Harmonize***, is a script that helps organize your photos, videos, music, documents and more. It's flexible INPUT / OUPUT arguments allow you to organize files quickly. With simple file type keyboards, you can easily move specific types of files between directories or even just allow Harmonize to move and organize everything for you.

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
