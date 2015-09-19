#!/usr/bin/env ruby
# | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ | #
# |                                         | #
# | Harmonize                               | #
# |                                         | #
# | a script to help organize your sh*t. :) | #
# |                                         | #
# |  Librarys                               | #
# |                                         | #
        require 'optparse'
        require 'pathname'
        require 'fileutils'
# |                                         | #
# |   Written in Ruby                       | #
# |      by Jaison Brooks                   | #
# |                                         | #
# |-----------------------------------------| #

class Harmonize
  
  attr_accessor :input, :output, :verbose, :recursive, :force, :files
  
  VERSION= "0.2"
  
  def initialize(p={})
    @input = valid_dir(p[:input]) || Dir.pwd
    @output = valid_dir(p[:output]) || Dir.home
    @verbose = p[:verbose] || false
    @recursive = p[:recursive] || false
    @force = p[:force] || false
    @files = Array.new
  end
  
  # _key = String
  def valid_key?(_key)
    %w(pictures pics images photos movies videos shows documents docs music tunes data programs exec executables binaries code scripts web archives zips tars).include?(_key)
  end
  
  def primary_keys
    %w(pictures movies documents music data programs code archives)
  end
  
  def primary_key?(_key)
    primary_keys.include?(_key)
  end
  
  # Get a Type and Extensions hash object
  def get_tae_obj(_key)
    obj = {:key => _key, :file_extensions => Array.new, :name => "", :files => Array.new}
    if %w(pictures pics images photos).include?(_key)
      obj[:name] = "Pictures"
      obj[:file_extensions] = %w(jpg gif jpeg png svg tif tiff ico raw bmp psd webp ai eps ps svg)
    elsif %w(movies videos shows).include?(_key)
      obj[:name] = "Movies"
      obj[:file_extensions] = %w(mov mpeg avi mp4 arf mkv webm qt wmv rm m4v flv avc vob mjpeg egp mpg 3gpp mpg4 xvid mjpg)
    elsif %w(documents docs).include?(_key)
      obj[:name] = "Documents"
      obj[:file_extensions] = %w(doc docx log msg odt pages rtf tex txt wpd wps xlr xls xps potx potm xlsx pps ppsx odp pptx ppt pdf ppdf)
    elsif %w(music tunes).include?(_key)
      obj[:name] = "Music"
      obj[:file_extensions] = %w(aif iff m3u m4a mid mp3 mpa ra wav wma aac)
    elsif %w(data).include?(_key)
      obj[:name] = "Data"
      obj[:file_extensions] = %w(csv dat gbr key keychain vcf json xm mdb pdb sql dbl)
    elsif %w(programs exec executables binaries).include?(_key)
      obj[:name] = "Programs"
      obj[:file_extensions] = %w(apk app deb jar exe iso pkg dmg)
    elsif %w(code scripts web).include?(_key)
      obj[:name] = "Code"
      obj[:file_extensions] = %w(css html js php xhtml java py pl cs c lua h cpp class swift scss less rb sh bat)
    elsif %w(archives zips tars).include?(_key)
      obj[:name] = "Archives"
      obj[:file_extensions] = %w(7z gz rar bz2 bz tar zip zipx )
    else
      puts @opt_parser
      error("Incorrect type ( #{_key} ) there is no file extensions for this type. Please try again") and return nil
    end
    obj
  end
  
  def valid_dir(path)
    return if path.nil?
    _path = slash!(path)
    if _path.include?('~')
      File.expand_path(_path)
    elsif Dir.exist?(_path)
      _path
    end
  end
  
  def output_dir(name)
    dir = Pathname.new("#{@output}/#{name}")
    unless dir.exist?
      dir.mkpath
    end
    slash!(dir.to_s)
  end
  
  # Ensure their is always a / at the end of the path
  def slash!(path)
    unless path.end_with?('/')
      return path + "/"
    end
    path
  end
  
  def files(argv)
    objs = setup(argv.to_s.downcase)
    return nil if objs.nil?
    
    objs.each { |obj|
      # TODO - Everything mode, moves all files { @recursive ? Dir["#{output_dir(key)}**/*.*"] }
      # output_dir(obj[:name]) - USED FOR OUTPUT
      obj[:file_extensions].each { |ext|
        if @recursive
          files = Dir["#{@input}/**/*.#{ext}"]
          next if files == 0
          obj[:files] = files
        else
          files = Dir["#{@input}/*.#{ext}"]
          next if files == 0
          obj[:files] = files
        end
      }
    }
    @files = objs
  end
  
  def move
    @files.each {|hsh| 
      if hsh[:files].count == 0
        pu "No (#{hsh[:name]}) files to move"
      else
        out = output_dir(hsh[:name])
        if @verbose
          pu "Moving #{hsh[:files].count} (#{hsh[:name]}) files to #{out}" 
        end
        FileUtils.mv(hsh[:files], out, {:verbose => @verbose, :force => @force})
      end
    }
    pu "Moving has finished"
  end
  
  
  def setup(argv)
    obj = Array.new
    if (argv === "false") || (argv === "all") || (argv.empty?)
      primary_keys.each { |key| 
        obj << get_tae_obj(key)
      }
    elsif primary_keys.any? { |arg| arg.include?(argv) }
      argv.split.each { |key|
        obj << get_tae_obj(key)
      }
    elsif argv.include?(',') && argv.split(/,/).any? { |arg| valid_key?(arg) }#  argv.split(/,/).all? { |arg| arg.include?(argv) } - This code could be used to match all keys. but i want to make it fail proof!
      argv.split(/,/).each {|key|
        if valid_key?(key)
            tae = get_tae_obj(key)
            unless obj.any? {|h| h[:name] === tae[:name] }
              obj << tae
            end
        end
      }
    elsif !argv.nil?
      a = get_tae_obj(argv)
      unless a.nil?
        obj << a
      else
        error("Invalid argument ( #{argv} ), Please try again :/") and return nil
      end
      #error("Invalid argument ( #{argv} ), Please try again :/") and return
    end
    #
    obj
  end
  
  def to_json
    {:input => @input, :output => @output, :verbose => @verbose, :recursive => @recursive, :force => @force, :files => @files}
  end
  
  # With app name puts
  def pu(txt=nil)
    puts "[#{Harmonize}] #{txt || ''}"
  end
  #
  # Display an error
  def error(msg)
    pu "#{msg}"
    exit(0)
  end
end

#### [ Colorizer ] ####
def colorize(text, color = "default", bgColor = "default")
    colors = {"default" => "38","black" => "30","red" => "31","green" => "32","brown" => "33", "blue" => "34", "purple" => "35",
     "cyan" => "36", "gray" => "37", "dark gray" => "1;30", "light red" => "1;31", "light green" => "1;32", "yellow" => "1;33",
      "light blue" => "1;34", "light purple" => "1;35", "light cyan" => "1;36", "white" => "1;37"}
    bgColors = {"default" => "0", "black" => "40", "red" => "41", "green" => "42", "brown" => "43", "blue" => "44",
     "purple" => "45", "cyan" => "46", "gray" => "47", "dark gray" => "100", "light red" => "101", "light green" => "102",
     "yellow" => "103", "light blue" => "104", "light purple" => "105", "light cyan" => "106", "white" => "107"}
    color_code = colors[color]
    bgColor_code = bgColors[bgColor]
    return "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
end



#### [ Options Parser ] ####
@opt_parser = OptionParser.new do |opt|
  opt.banner = <<-BANNER
.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|#{colorize('                ','black','black')}#{colorize('++++','white','black')}#{colorize('>>','cyan','black')}#{colorize('    ','black','black')}#{colorize('H A R M O N I Z E','light purple', 'black')}#{colorize('    ','black','black')}#{colorize('<<','cyan','black')}#{colorize('++++','white','black')}#{colorize('                 ','black','black')}|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  BANNER
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' USAGE ','white','black')} : #{colorize('$','white')} #{colorize('harmonize', 'light purple')} #{colorize('TYPES', 'light green')} #{colorize('ARGUMENTS', 'light blue')}                               |"
  opt.separator "|                                                                      |"
  opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' TYPES ','white','black')}                                                             |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize('The supported types and associated file extensions:','light green')}                 |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' pictures ','light green','black')}                                                         |"
  opt.separator "|     [ jpg gif jpeg png svg tif bmp svg psd webp ai and more... ]     |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' movies ','light green','black')}                                                           |"
  opt.separator "|     [ mov mpeg avi mp4 webm flv m4v vob 3gpp xvid and more...]       |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' documents ','light green','black')}                                                        |"
  opt.separator "|     [ pdf xlsx xls docx log msg rft txt ppt doc and more... ]        |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' music ','light green','black')}                                                            |"
  opt.separator "|     [ mp3 aac wav wma and more... ]                                  |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' code ','light green','black')}                                                             |"
  opt.separator "|     [ rb js css scss less erb coffee html java py php and more... ]  |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' data ','light green','black')}                                                             |"
  opt.separator "|     [ xml json sql csv vcf key pdb keychain dat and more... ]        |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' programs ','light green','black')}                                                         |"
  opt.separator "|     [ apk app deb jar exe iso pkg dmg iso and more... ]              |"
  opt.separator "|                                                                      |"
  opt.separator "|   #{colorize(' archives ','light green','black')}                                                         |"
  opt.separator "|     [ zip 7z tar gz gzip rar and more... ]                           |"
  opt.separator "|                                                                      |"
  opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' DEFAULTS ','white','black')}                                                          |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' INPUT (-i)   :','white')} #{colorize('[ Current Directory ]','cyan')}                               |"
  opt.separator "|  #{colorize(' EXPORT (-e)  :','white')} #{colorize('[ Home Directory ]','cyan')}                                  |"
  opt.separator "|  #{colorize(' VERBOSE (-v) :','white')} #{colorize('[ OFF ]','cyan')}                                             |"
  opt.separator "|                                                                      |"
  opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' EXAMPLES ','white','black')}                                                          |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' ~ : $','white')} #{colorize('harmonize','light purple')}                                                    |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize('This would use the current directory as the INPUT and EXPORT','light red')}        |"
  opt.separator "|  #{colorize('it also is assuming you want ALL files harmonized and sorted.','light red')}       |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' ~ : $','white')} #{colorize('harmonize pics -i Downloads/ -e /Users/bob','light purple')}                   |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize('This would move all PICS files from ( Downloads/ ) to ','light red')}              |"
  opt.separator "|  #{colorize('( /Users/bob/Pictures ). Since SORT is on by default, ','light red')}              |"
  opt.separator "|  #{colorize('a directory matching the tag name (pictures) will be created and ','light red')}   |"
  opt.separator "|  #{colorize('all cooresponding files will be relocated here.','light red')}                     |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' ~ : $','white')} #{colorize('harmonize docs -i Downloads/ -e /Users/bob -r -v','light purple')}             |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize('Like the above example, all files from ( Downloads/ ), including ','light red')}   |"
  opt.separator "|  #{colorize('all sub directories ( Downloads/blah, Downloads/random/blah, etc )','light red')}  |"
  opt.separator "|  #{colorize('will be moved to ( /Users/bob/Docs ) and the console will output','light red')}    |"
  opt.separator "|  #{colorize('extra information about what the script is doing.','light red')}                   |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize('You may run into duplicate, which will be skipped','light red')}                   |"
  opt.separator "|  #{colorize('unless you include a ( -f, --force ) argument, which will override','light red')}  |"
  opt.separator "|  #{colorize('all files where a duplicate file name exists.','light red')}                       |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize('(BE CAREFUL) there are no DO OVERs with (-f, --force)','red')}               |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize('More examples coming soon...','light purple')}                                        |"
  opt.separator "|                                                                      |"
  opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' ARGUMENTS ','white','black')} = #{colorize('See paramaters below','light blue')}                                  |"
  opt.separator "|                                                                      |"
  opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' SCRIPT VERSION ','white','black')} = #{colorize(Harmonize::VERSION, 'light purple')}                                              |"
  opt.separator "|                                                                      |"
  opt.separator "|----------------------------------------------------------------------|"
  opt.separator ""
  opt.on("-i", "--input FOLDER_PATH", "#{colorize('Input ', 'cyan')}- Where to get the files from") do |input|
    @options[:input] = input
  end
  opt.on("-o", "--output FOLDER_PATH", "#{colorize('Output ', 'cyan')}- Where to relocate the files") do |output|
    @options[:output] = output
  end
  opt.on("-f", "--force", "#{colorize('Force mode ', 'cyan')}- Overwrite any duplicate files (by name) { BE CAREFUL }!") do
    @options[:force] = true
  end
  opt.on("-r", "--resursive", "#{colorize('Resursive mode ', 'cyan')}- Include all sub directory files { BE CAREFUL }!") do
    @options[:recursive] = true
  end
  opt.on("-h","--help","#{colorize('Help ','cyan')}- Show this help page") do
      puts @opt_parser
      exit(0)
  end
  opt.on("-v","--verbose","#{colorize('Verbose ', 'cyan')}- Include extra console output") do
      @options[:verbose] = true
  end  
end
@opt_parser.parse!
#######################

#### [ START THE PROGRAM ] ####
@harmonize = Harmonize.new(@options)
@harmonize.files(ARGV[0])
@harmonize.move
###############################




  