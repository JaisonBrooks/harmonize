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
  
  # Attribute Definitions #
  # input - where to locate files
  # output - where to move files
  # verbose - include verbose in console
  # recursive - get files from sub directories
  # force - override duplicates
  # launch - open folder when complete
  # pretend - only ask like your going to move stuff, dont actually do it
  # dry - move all files to root of output (dont organgize)
  # tree mode - include sub directories


  attr_accessor :input, :output, :verbose, :recursive, :force, :launch, :dry, :pretend, :files

  VERSION= "0.4"

  def initialize(p={})
    @input = valid_dir(p[:input]) || slash!(Dir.pwd)
    @output = valid_dir(p[:output], true) || slash!(Dir.home)
    @verbose = p[:verbose] || false
    @recursive = p[:recursive] || false
    @force = p[:force] || false
    @launch = p[:launch] || false
    @dry = p[:dry] || false
    @pretend = p[:pretend] || false
    @files = Array.new
  end

  # _key = String
  def valid_key?(_key)
    %w(pictures pics images photos movies videos shows documents docs music tunes data programs exec executables binaries code scripts web archives zips tars).include?(_key)
  end

  # Primary tag names
  def primary_keys
    %w(pictures movies documents music data programs code archives)
  end

  # Match agains the primary keys array
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
      obj[:file_extensions] = %w(css html coffee js php xhtml java py pl cs c lua h cpp class swift scss less rb sh bat)
    elsif %w(archives zips tars).include?(_key)
      obj[:name] = "Archives"
      obj[:file_extensions] = %w(7z gz rar bz2 bz tar zip zipx)
    elsif %w(* everything).include?(_key)
      obj[:name] = "Everything"
      obj[:file_extensions] = %w(*)
      pu "This fool wants everthing!"
    else
      puts @opt_parser
      error("Incorrect type (#{colorize(_key,'red')}) there is no file extensions for this type. Please try again") and return nil
    end
    obj
  end

  # Validate the directory and create it if specified
  def valid_dir(path, k=false)
    return nil if path.nil?
    path.include?('~') ? path = File.expand_path(path) : path
    return slash!(File.expand_path(path)) if Dir.exist?(path)
    if k
      return slash!(File.expand_path(FileUtils.mkdir_p(path, :mode => 0700).first))
    end
    #
    nil
  end

  # Validate the output directory exists, if not create it, similar to above will convert to one method soon
  def output_dir(name)
    dir = "#{@output}#{name}"
    unless Dir.exist?(dir)
      FileUtils.mkdir_p(dir, :mode => 0700)
    end
    slash!(dir)
  end

  # Ensure their is always a / at the end of the path
  def slash!(path)
    path.end_with?('/') ? path : "#{path}/"
  end
  
  # Show Tags with Extensions
  def tags
    pu "#{colorize('Types & Extensions', 'light purple')}"
    primary_keys.each {|key|
      obj = get_tae_obj(key)
      pu "#{colorize(obj[:name], 'light green')} : #{colorize(obj[:file_extensions], 'light blue')} "
    }
    exit
  end
  
  # Gather the files based on tag
  def files(argv)
    tags if argv.to_s.upcase == 'TAGS'
    objs = setup(argv.to_s.downcase)
    return nil if objs.nil?
    objs.each { |obj|
        obj[:file_extensions].each { |ext|
          if @recursive
          arr = Dir["#{@input}**/*.#{ext}"]
          arr.each {|file| 
            obj[:files] << file
          }
        else
          arr = Dir["#{@input}/*.#{ext}"]
          unless arr.empty?
              arr.each {|file| 
                obj[:files] << file
              }
          end
          # Above method add's each file to the parent array.
          # Someday, i may wanna do a 2d array by file type for organization
          # by file extension.
        end
        }
    }
    @files = objs
  end

  # Perform core operation, move files
  def move
    @files.each {|hsh|
      if hsh[:files].count == 0
        pu "No (#{colorize(hsh[:name],'light green')}) files to move"
      else
        out = @dry ? slash!(@output) : output_dir(hsh[:name])
        fc = 0
        hsh[:files].each {|file|
          if @force
            FileUtils.mv(file, out, {:verbose => @verbose, :force => @force}) unless @pretend
            fc+=1
          else
            if File.exists?("#{out}/#{File.basename(file)}")
              pu "Duplicate filename (#{colorize(file,'light red')}), leaving file alone"
            else
              fc+=1
              FileUtils.mv(file, out, {:verbose => @verbose}) unless @pretend
            end
          end
        }
        pu "#{@pretend ? 'Would have moved ' : 'Moved '} #{colorize(fc,'light purple')} / #{colorize(hsh[:files].count,'light purple')} (#{colorize(hsh[:name],'light green')}) files to #{colorize(out,'light blue')}"
      end
    }
    pu "Your files have been #{colorize(' H A R M O N I Z E D ', 'light purple', 'black')}"
  end

  # Perform any finishing tasks
  def finish
    if @launch
      exec( "open #{@output}" )
    end
      # MAY USE LATER
    # pu "Do you want to open your output folder? #{colorize('y Y yes','green')} / #{colorize('n N no','red')}"
#     print "[Harmonize] => "
#     a = gets
#     loop do
#       r = a.strip.to_s
#       if %w(y Y yes).include?(r)
#         cmd = "`open` #{@input}"
#         exec cmd
#         break
#       elsif %w(n N no).include?(r)
#         pu "#{colorize('Ok, were done here then :)','light green')}"
#         break
#       end
#     end
  end

  #
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
        error("Invalid argument (#{colorize(argv,'red')}), Please try again :/") and return nil
      end
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

if __FILE__ == $0
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
  @options = {}
  @opt_parser = OptionParser.new do |opt|
  opt.banner = <<-BANNER
.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|#{colorize('                ','black','black')}#{colorize('++++','yellow','black')}#{colorize('>>','cyan','black')}#{colorize('    ','black','black')}#{colorize('H A R M O N I Z E','light purple', 'black')}#{colorize('    ','black','black')}#{colorize('<<','cyan','black')}#{colorize('++++','yellow','black')}#{colorize('                 ','black','black')}|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BANNER
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' USAGE ','white','black')} : #{colorize('$','white')} #{colorize('harmonize', 'light purple')} #{colorize('TYPE', 'light green')} #{colorize('ARGUMENTS', 'light blue')}                                |"
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
    opt.separator "|   #{colorize(' all ','light green','black')}                                                              |"
    opt.separator "|     [ all supported file types and file extensions ]                 |"
    opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' tags ','light green','black')}                                                             |"
    opt.separator "|     [ Run 'harmonize tags' to view each type & its file extensions ] |"
    opt.separator "|                                                                      |"
    # opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
  #   opt.separator "|                                                                      |"
  #   opt.separator "|  #{colorize(' DEFAULTS ','white','black')}                                                          |"
  #   opt.separator "|                                                                      |"
  #   opt.separator "|  #{colorize(' INPUT (-i)   :','white')} #{colorize('[ Current Directory ]','cyan')}                               |"
  #   opt.separator "|  #{colorize(' OUTPUT (-o)  :','white')} #{colorize('[ Home Directory ]','cyan')}                                  |"
  #   opt.separator "|  #{colorize(' VERBOSE (-v) :','white')} #{colorize('[ OFF ]','cyan')}                                             |"
  #   opt.separator "|                                                                      |"
    opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' EXAMPLES ','white','black')}                                                          |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' ~ : $','white')} #{colorize('harmonize','light purple')}                                                    |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('This would use the current path as the INPUT and your Home path','light red')}     |"
    opt.separator "|  #{colorize('as the OUTPUT and Harmonize all FILE TYPES.','light red')}                         |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' ~ : $','white')} #{colorize('harmonize pictures -i ~/Downloads -o ~/OutputFolder','light purple')}          |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('This would move all PICTURES from ( ~/Downloads ) to ','light red')}               |"
    opt.separator "|  #{colorize('( ~/OutputFolder/Pictures ), Notice the *Pictures* folder, this is','light red')}  |"
    opt.separator "|  #{colorize('because for each tag name a directory gets created and all','light red')}          |"
    opt.separator "|  #{colorize('cooresponding files are relocated to this directory.','light red')}                |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('*Use ','light red')}#{colorize('-s','light purple')}#{colorize(' to relocate to the output root, instead of sub directories.','light red')} |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' ~ : $','white')} #{colorize('harmonize docs -i ~/Downloads -o ~/MyDocs -r -s -v','light purple')}           |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('In this case, All DOCS from ( ~/Downloads ) including all files','light red')}     |"
    opt.separator "|  #{colorize('with sub directories ( ~/Downloads/blah, ~/Downloads/random/blah )','light red')}  |"
    opt.separator "|  #{colorize('will be moved to the root of the ( ~/MyDocs ) folder.','light red')}               |"
    opt.separator "|  #{colorize('You will also see extra console output since ( -v ) is enabled.','light red')}     |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('You may run into duplicate files with (-r), these will be skipped','light red')}   |"
    opt.separator "|  #{colorize('unless you include a ( -f, --force ) argument, which will override','light red')}  |"
    opt.separator "|  #{colorize('all files where a duplicate file name exists.','light red')}                       |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('(BE CAREFUL) there are no DO OVERs with (-f, --force)','red')}               |"
    opt.separator "|                                                                      |"
    # opt.separator "|  #{colorize('More examples coming soon...','light purple')}                                        |"
    # opt.separator "|                                                                      |"
    opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
    # opt.separator "|                                                                      |"
    # opt.separator "|  #{colorize(' ARGUMENTS ','white','black')} = #{colorize('See paramaters below','light blue')}                                  |"
    # opt.separator "|                                                                      |"
    # opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' AUTHOR ','white','black')} = #{colorize('Jaison Brooks', 'light purple')}                                            |"
    opt.separator "|  #{colorize(' VERSION ','white','black')} = #{colorize(Harmonize::VERSION, 'light purple')}                                                     |"
    opt.separator "|                                                                      |"
    opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' DISCLAIMER ','white','black')}                                                        |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' By using this script, you agree that i am not responsible for any','cyan')}  |"
    opt.separator "|  #{colorize(' damage, corruption and/or misplacement of your files.','cyan')}              |"
    opt.separator "|  #{colorize(' You have been Warned.','cyan')}#{colorize(' Use at your own risk!', 'red')}                        |"
    opt.separator "|                                                                      |"
    opt.separator "|----------------------------------------------------------------------|"
    opt.separator ""

    opt.on("-i", "--input FOLDER_PATH", "#{colorize('Input ', 'cyan')}- Where to get the files from") do |input|
      @options[:input] = input
    end

    opt.on("-o", "--output FOLDER_PATH", "#{colorize('Output ', 'cyan')}- Where to relocate the files") do |output|
      @options[:output] = output
    end

    opt.on("-f", "--force", "#{colorize('Force ', 'cyan')}- Overwrite any duplicates { BE CAREFUL }!") do
      @options[:force] = true
    end
  
    opt.on("-d", "--dry", "#{colorize('Dry run ', 'cyan')}- Move files to output's root (Dont Organgize only Move)") do
      @options[:dry] = true
    end
  
    opt.on("-l", "--launch", "#{colorize('Launch ', 'cyan')}- Open the output folder when completed") do
      @options[:launch] = true
    end
    
    opt.on("-l", "--pretend", "#{colorize('Pretend ', 'cyan')}- Does everything but actually move your files") do
      @options[:pretend] = true
    end

    opt.on("-r", "--resursive", "#{colorize('Resursive ', 'cyan')}- Include all sub directory files { BE CAREFUL }!") do
      @options[:recursive] = true
    
    end

    opt.on("-v","--verbose","#{colorize('Verbose ', 'cyan')}- Include extra console output") do
      @options[:verbose] = true
    end
  
    opt.on("-h","--help","#{colorize('Help ','cyan')}- Show this help page") do
        puts @opt_parser
        exit(0)
    end
  end
  @opt_parser.parse!
  #######################

  #### [ START THE PROGRAM ] ####
  @harmonize = Harmonize.new(@options)
  @harmonize.files(ARGV[0])
  @harmonize.move
  @harmonize.finish
  ###############################
end