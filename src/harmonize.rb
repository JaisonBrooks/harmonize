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
  
  # input - where to locate files
  # output - where to move files
  # verbose - include verbose in console
  # recursive - get files from sub directories
  # force - override duplicates
  # launch - open folder when complete
  # pretend - only ask like your going to move stuff, dont actually do it
  # dry - move all files to root of output (dont organgize)
  
  attr_accessor :input, :output, :verbose, :recursive, :force, :launch, :dry, :pretend, :cop, :files

  VERSION= "0.5"
  KEYS={
    :standard => {
      :pictures => %w(pictures pics images photos),
      :movies => %w(movies videos shows tv),
      :music => %w(music tunes jams),
      :documents => %w(documents docs),
      :data => %w(data),
      :programs => %w(programs exec executables binaries),
      :code => %w(code scripts),
      :archives => %w(archives zips)
    },
    :special => {
      :all => ['','false','all'],
      :everything => %w(* everything),
      :tags => %w(tags)
    }
  }
  
  # Initialize the class
  def initialize(p={})
    @input = pdir(p[:input]) || slash!(Dir.pwd)
    @output = pdir(p[:output], true) || slash!(Dir.home)
    @verbose = p[:verbose] || false
    @recursive = p[:recursive] || false
    @force = p[:force] || false
    @launch = p[:launch] || false
    @dry = p[:dry] || false
    @pretend = p[:pretend] || false
    @cop = p[:cop] || false # custom output specified
    @files = Array.new
  end

  # Return a Type & Extensions hash based on the incoming key
  def tae_obj(_key)
    obj = {:key => _key, :file_extensions => Array.new, :name => "", :files => Array.new}
    if KEYS[:standard][:pictures].include?(_key)
      obj[:name] = "Pictures"
      obj[:file_extensions] = %w(jpg gif jpeg png svg tif tiff ico raw bmp psd webp ai eps ps svg)
    elsif KEYS[:standard][:movies].include?(_key)
      obj[:name] = "Movies"
      obj[:file_extensions] = %w(mov mpeg avi mp4 arf mkv webm qt wmv rm m4v flv avc vob mjpeg egp mpg 3gpp mpg4 xvid mjpg)
    elsif KEYS[:standard][:documents].include?(_key)
      obj[:name] = "Documents"
      obj[:file_extensions] = %w(doc docx log msg odt pages rtf tex txt wpd wps xlr xls xps potx potm xlsx pps ppsx odp pptx ppt pdf ppdf)
    elsif KEYS[:standard][:music].include?(_key)
      obj[:name] = "Music"
      obj[:file_extensions] = %w(aif iff m3u m4a mid mp3 mpa ra wav wma aac)
    elsif KEYS[:standard][:data].include?(_key)
      obj[:name] = "Data"
      obj[:file_extensions] = %w(csv dat gbr key keychain vcf json xm mdb pdb sql dbl)
    elsif KEYS[:standard][:programs].include?(_key)
      obj[:name] = "Programs"
      obj[:file_extensions] = %w(apk app deb jar exe iso pkg dmg)
    elsif KEYS[:standard][:code].include?(_key)
      obj[:name] = "Code"
      obj[:file_extensions] = %w(css html coffee js php xhtml java py pl cs c lua h cpp class swift scss less rb sh bat)
    elsif KEYS[:standard][:archives].include?(_key)
      obj[:name] = "Archives"
      obj[:file_extensions] = %w(7z gz rar bz2 bz tar zip zipx)
    else
      puts @opt_parser
      error("Incorrect type (#{colorize(_key,'red')}), there are no file extensions for this type. Please try again")
    end
    obj
  end
  
  # Prep a old or new Directory
  def pdir(path,c=false)
    return nil if path.nil? || path.to_s.empty?
    path = path.include?('~') ? File.expand_path(path) : path
    return slash!(File.expand_path(path)) if Dir.exist?(path)
    return slash!(File.expand_path(FileUtils.mkdir_p(path, :mode => 0700).first)) if c
    nil
  end

  # Ensure their is always a / at the end of the path
  def slash!(path)
    path.end_with?('/') ? path : "#{path}/"
  end
  
  # Convert string (csv, spaced, single) to Array
  def arg_array(arg)
    (arg.include?(',') ? arg.split(/,/) : arg.split).each{|_arg| _arg.strip!}
  end
  
  # Return keys based on type
  def keys(type)
    case type
      when :standard
        KEYS[:standard].values.flatten
      when :special
        KEYS[:special].values.flatten
      when :all
        KEYS[:standard].values.flatten | KEYS[:special].values.flatten
      else
        raise ArgumentError, 'Invalid key param'
    end
  end
  
  # Validate a key
  def valid_key?(key)
    keys(:all).include?(key)
  end
  
  # Validate an arg
  def valid_arg?(arg) 
    if (arg.include?(',') && arg.split(/,/).length > 1) || arg.split.length > 1
      standard_keys = keys(:standard)
      if arg_array(arg).any? { |_arg| standard_keys.include?(_arg) }
        return true
      else
        return false
      end
    else
      return valid_key?(arg)
    end
  end
  
  # Purge any bad args and return Array
  def parg(arg)
    all_keys = keys(:all)
    args = arg_array(arg)
    args.delete_if{|_arg| !all_keys.include?(_arg)}
  end
  
  # Validate specified arg(s) and ensure program can execute
  def validate(argv)
    arg = argv.to_s.strip.downcase
    # Invalid Conditions
    error("Invalid argument (#{colorize(argv,'red')})") unless valid_arg?(arg)
    error("You must specify an OUTPUT folder (-o, --output)") if KEYS[:special][:everything].include?(arg) && (@cop.nil? || !@cop)
    # Special Cases
    tags if KEYS[:special][:tags].include?(arg)
    move_all if KEYS[:special][:everything].include?(arg)
    # Normal Use Case
    files(arg)
  end
  
  # Move all files, similar to normal mv, will presever all files and folder structure
  def move_all
    @pretend ? pu("Would have moved #{colorize('ALL','light purple')} files from #{colorize(@input,'light blue')} to #{colorize(@output,'light blue')}") : (@force ? FileUtils.mv(@input, @output, {:verbose => @verbose, :force => @force}) : FileUtils.mv(@input, @output, {:verbose => @verbose}))
  end
  
  # Show Tags with Extensions
  def tags
    pu "#{colorize('Standard Types & Extensions:', 'light purple')}"
    KEYS[:standard].keys.each {|key| 
      tags = KEYS[:standard][key]
      obj = get_tae_obj(key.to_s)
      pu "  #{colorize(obj[:name], 'light green')}"
      pu "    TAGS: #{colorize(tags, 'light blue')}"
      pu "    EXTS: #{colorize(obj[:file_extensions],'light blue')}"
    }
    pu
    pu "#{colorize('Special Types:', 'light purple')}"
    KEYS[:special].keys.each {|key| 
      if key === :all
        pu "  #{colorize(key.to_s.capitalize, 'light green')}"
        pu "    TAGS: #{colorize('All the above Tags', 'light blue')}"
      elsif key === :everything
        pu "  #{colorize(key.to_s.capitalize, 'light green')}"
        pu "    TAGS: #{colorize(KEYS[:special][key], 'light blue')}"
        pu "    EXTS: #{colorize('All files and folders','light blue')}"
      end
    }
    exit(0)
  end
    
  # Gather the files based on tag
  def files(arg)
    objs = tae_obj(arg)
    objs.each { |obj|
      obj[:file_extensions].each { |ext|
        files = @recursive ? Dir["#{@input}**/*.#{ext}"] : Dir["#{@input}/*.#{ext}"]
        files.each {|file|
          obj[:files] << file
        } # May do a 2d array (by file type) for sort
      }
    }
    @files = objs
  end
  
  # Move the files
  def move
    @files.each{ |obj|
      if obj[:files].count === 0
         pu "No #{colorize(obj[:name],'light green')} to move" if @verbose
      else
        output = @dry ? @output : pdir(obj[:name])
        fc=0
        obj[:files].each {|file|
          if @force
            FileUtils.mv(file, out, {:verbose => @verbose, :force => @force}) unless @pretend
            fc+=1
          else
            if File.exists?("#{output}/#{File.basename(file)}")
              pu "#{colorize(File.basename(file),'light red')} already exists in #{colorize(output,'light blue')}"
            else
              FileUtils.mv(file, output, {:verbose => @verbose}) unless @pretend
              fc+=1
            end
          end
        }
        pu "#{@pretend ? 'Would have moved ' : 'Moved '} #{colorize(fc,'light purple')} / #{colorize(obj[:files].count,'light purple')} #{colorize(obj[:name],'light green')} to #{colorize(output,'light blue')}"
      end
    }
  end

  # Perform any finishing tasks
  def finish
    pu "Files #{colorize(' * Harmonized * ', 'cyan', 'black')}"
    @launch ? exec( "open #{@output}" ) : return
  end

  # puts with app name
  def pu(txt=nil)
    puts "[#{Harmonize}] #{txt || ''}"
  end
  
  # Display an error
  def error(msg)
    pu "#{msg}, #{colorize('Game Over...', 'cyan')}"
    exit(0)
  end
  
  # Output variables to JSON
  def to_json
    {:input => @input, :output => @output, :verbose => @verbose, :recursive => @recursive, :force => @force, :dry => @dry, :pretend => @pretend, :launch => @launch, :cop => @cop, :files => @files}
  end
  
  # END
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
      return "\033[#{bgColors[bgColor]};#{colors[color]}m#{text}\033[0m"
  end
  #### [ Options Parser ] ####
  @options = {}
  @opt_parser = OptionParser.new do |opt|
    opt.banner = <<-BANNER
.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|#{colorize('             ','black','black')}#{colorize('~~~~~~','yellow','black')}#{colorize('>>>','cyan','black')}#{colorize('    ','black','black')}#{colorize('H A R M O N I Z E','light purple', 'black')}#{colorize('    ','black','black')}#{colorize('<<<','cyan','black')}#{colorize('~~~~~~','yellow','black')}#{colorize('              ','black','black')}|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BANNER
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' USAGE ','white','black')} ~ : #{colorize('$','white')} #{colorize('harmonize', 'light purple')} #{colorize('TYPE', 'light green')} #{colorize('ARGUMENTS', 'light blue')}                              |"
    opt.separator "|                                                                      |"
    opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' TYPES ','white','black')}                                                             |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('Standard','light green')}                                                            |"
    opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' pictures ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ jpg, png, gif, bmp, svg, webp, psd, ai, ...] ', 'yellow', 'black')}        |"
    #opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' documents ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ pdf, xlsx, docx, doc, rtf, txt, ppt, ...] ', 'yellow', 'black')}          |"
    #opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' music ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ mp3, aac, wav, wma, ...] ', 'yellow', 'black')}                               |"
    #opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' movies ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ mov, avi, mp4, webm, flv, 3gpp, mpeg, ...] ', 'yellow', 'black')}            |"
    #opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' code ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ rb, sh, js, py, php, css, html, java, c, h, ...] ', 'yellow', 'black')}        |"
    #opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' data ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ xml, json, dat, csv, vcf, sql, pdb, ...] ', 'yellow', 'black')}                |"
    #opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' programs ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ app, dmg, pkg, jar, deb, apk, iso, exe, ...] ', 'yellow', 'black')}        |"
    #opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' archives ','light green','black')}#{colorize('- ','default','black')}#{colorize('[ zip, tar, 7z, rar, gzip, ...] ', 'yellow', 'black')}                       |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('Special','light green')}                                                             |"
    opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' all ','light green','black')}#{colorize('- ','default','black')}#{colorize('All the above types and their file extensions ', 'yellow', 'black')}              |"
    # opt.separator "|                                                                      |"
    opt.separator "|   #{colorize(' \'*\' or everything ','light green','black')}#{colorize('- ','default','black')}#{colorize('All files and folders ', 'yellow', 'black')}                        |"
    opt.separator "|   #{colorize(' tags ','light green','black')}#{colorize('- ','default','black')}#{colorize('Displays a list of all types and file extensions ', 'yellow', 'black')}          |"
    opt.separator "|                                                                      |"
    # opt.separator "|     [ all supported file types and file extensions ]                 |"
    # opt.separator "|                                                                      |"
    # opt.separator "|   #{colorize(' tags ','light green','black')}                                                             |"
    # opt.separator "|     [ Run 'harmonize tags' to view each type & its file extensions ] |"
    # opt.separator "|                                                                      |"
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
    opt.separator "|  #{colorize('*Use ','light red')}#{colorize('-d','light purple')}#{colorize(' to relocate to the output root, instead of sub directories.','light red')} |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize(' ~ : $','white')} #{colorize('harmonize docs -i ~/Downloads -o ~/MyDocs -r -d -v','light purple')}           |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('All DOCS from ( ~/Downloads ) including all files within sub','light red')}        |"
    opt.separator "|  #{colorize('directories ( ~/Downloads/blah, ~/Downloads/random/blah ) will be','light red')}   |"
    opt.separator "|  #{colorize('moved to the root of the ( ~/MyDocs ) folder.','light red')}                       |"
    # opt.separator "|  #{colorize('You will also see extra console output since ( -v ) is enabled.','light red')}     |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('You may run into duplicate files with (-r), these will be skipped','light red')}   |"
    opt.separator "|  #{colorize('unless you include a (-f, --force) argument, which will override','light red')}    |"
    opt.separator "|  #{colorize('all files where a duplicate file name exists.','light red')}                       |"
    opt.separator "|                                                                      |"
    opt.separator "|  #{colorize('(BE CAREFUL) there are no DO OVERs with (-f, --force)','red')}               |"
    opt.separator "|                                                                      |"
    opt.separator "| #{colorize('.  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . ')} |"
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
      @options[:cop] = true
    end
    opt.on("-d", "--dry", "#{colorize('Dry run ', 'cyan')}- Move files to output's root but doesnt organize them") do
      @options[:dry] = true
    end
    opt.on("-l", "--launch", "#{colorize('Launch ', 'cyan')}- Open the output folder when completed") do
      @options[:launch] = true
    end
    opt.on("-p", "--pretend", "#{colorize('Pretend ', 'cyan')}- Only pretends to Harmonize your files") do
      @options[:pretend] = true
    end
    opt.on("-r", "--resursive", "#{colorize('Resursive ', 'cyan')}- Include all sub directories & files { BE CAREFUL }!") do
      @options[:recursive] = true
    end
    opt.on("-f", "--force", "#{colorize('Force ', 'cyan')}- Overwrite any duplicates { BE CAREFUL }!") do
      @options[:force] = true
    end
    opt.on("-v","--verbose","#{colorize('Verbose ', 'cyan')}- Include extra console output") do
      @options[:verbose] = true
    end
    opt.on("-h","--help","#{colorize('Help ','cyan')}- Show this help page") do
        puts @opt_parser
        exit(0)
    end    
  end
  begin @opt_parser.parse!
  rescue OptionParser::InvalidOption => e
    puts "[Harmonize] #{colorize('Invalid Argument!', 'red')}, #{colorize('Game Over...', 'cyan')}, Use #{colorize('harmonize -h','light purple')} for help"
    exit(1)
  end
  #######################

  #### [ START THE PROGRAM ] ####
  @harmonize = Harmonize.new(@options)
  @harmonize.validate(ARGV[0])
  @harmonize.move
  @harmonize.finish
  ###############################
end