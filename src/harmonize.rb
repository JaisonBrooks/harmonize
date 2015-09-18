#!/usr/bin/env ruby
# | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ | #
# |                                         | #
# | Harmonize                               | #
# |                                         | #
# | a script to help organize your sh*t. :) | #
# |                                         | #
# |   Written in Ruby                       | #
# |      by Jaison Brooks                   | #
# |                                         | #
# | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ | #

# |-----------------------------------------| #
# |                                         | #
# |  Librarys                               | #
# |                                         | #
        require 'optparse'
        require 'pathname'
# |                                         | #
# |-----------------------------------------| #

# | THE_CODE_START_HERE_AND_CONTINUES_BELOW | #

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


#### [ VARIBLES ] ####
@app_name = "Harmonize"
@app_version = "0.1"

# General #
@acceptible_types = %w(pics vids docs scripts archieves data code music)
####

# Options #
@options = {}
@options[:verbose] = false
@options[:from] = Dir.pwd
@options[:to] = Dir.pwd
@options[:sort] = true
####

# Harmonize Hash #
@harmonize = {}
####

######################

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
  opt.separator "|  #{colorize(' TYPES ','white','black')} = #{colorize('pics, vids, docs, scripts, data, code, all and more  ', 'light green')}     |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' ARGUMENTS ','white','black')} = #{colorize('See paramaters below','light blue')}                                  |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' DEFAULTS ','white','black')}                                                          |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' SORT (-s)    :','white')} #{colorize('[ ON ]','cyan')}                                              |"
  opt.separator "|  #{colorize(' INPUT (-i)   :','white')} #{colorize('[ Current Directory ]','cyan')}                               |"
  opt.separator "|  #{colorize(' EXPORT (-e)  :','white')} #{colorize('[ Current Directory ]','cyan')}                               |"
  opt.separator "|  #{colorize(' VERBOSE (-v) :','white')} #{colorize('[ Verbose ]','cyan')}                                         |"
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
  opt.separator "|  #{colorize('( /Users/bob/Pics ). Since SORT is on by default, ','light red')}                  |"
  opt.separator "|  #{colorize('a directory matching the tag name (PICS) will be created and all','light red')}    |"
  opt.separator "|  #{colorize('cooresponding files will be relocated here.','light red')}                         |"
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
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' SCRIPT VERSION','white','black')} = #{colorize(@app_version, 'light purple')}                                               |"
  opt.separator "|                                                                      |"
  opt.separator "|----------------------------------------------------------------------|"
  opt.separator ""

  opt.on("-i", "--input FOLDER_PATH", "#{colorize('To ', 'cyan')}(A path to the input directory)") do |input|
    @options[:input] = input
  end
  
  opt.on("-e", "--export FOLDER_PATH", "#{colorize('To ', 'cyan')}(A path where to move files to)") do |export|
    @options[:export] = export
  end
  
  opt.on("-f", "--force", "#{colorize('From ', 'cyan')}(Force mode will overwrite files if files with the same name exist (BE CAREFUL))") do
    @options[:force] = true
  end
  
  opt.on("-r", "--resursive", "#{colorize('From ', 'cyan')}(Resursive mode will look in all sub directories and harmonize these files too (BE CAREFUL)") do |from_all|
    @options[:recursive_mode] = true
  end
  
  opt.on("-n", "--no_sort", "#{colorize('No Sort ', 'cyan')}(Doesnt orangize files into their cooresponding tags folder name)") do
    @options[:sort] = false
  end
  
  opt.on("-h","--help","#{colorize('Help','cyan')} (show this help page)") do
      puts @opt_parser
      exit(0)
  end
    
  opt.on("-v","--verbose","#{colorize('Verbose ', 'cyan')}(Include extra console output text when executing)") do
      @options[:verbose] = true
  end  
  
end
@opt_parser.parse!
#######################

#### [ Methods ] ####
#
# With app name puts
def pu txt=nil
  puts "[#{@app_name}] #{txt || ''}"
end
#
# def get_file_types(arg)
#   result = {}
#   args = arg.split(/,/)
#   if args.kind_of?(Array)
#     args.each {|a|
#       tag = a.to_s.downcase
#       result[:types] ||= Array.new
#       result[:types] << tag
#       result[:exts] ||= Array.new
#       result[:exts] << {tag => get_ext_by_type(a)}
#     }
#   else
#     result[:exts] = get_ext_by_type(arg)
#   end
#   #
#   return result
# end
#
def error(msg)
  pu "#{msg}"
  exit(0)
end
#
# Get value as array
def get_type(_arg, types_offered)
  if _arg.empty? || _arg == 'all'
    return types_offered
  elsif types_offered.each.collect {|t| t.include?(_arg)}
    return _arg.split(/,/)
  else
    error("Invalid param key (#{_arg}) | #{types_offered}")
  end
end
#
# Returns an array of file extensions based on the type
def get_exts(type)
  case type.to_s.downcase
    when "pics"
      %w(jpg gif jpeg png svg tiff bmp psd webp ai) 
    when "vids"
      %w(mov mpeg avi mp4)
    when "docs"
      %w(pdf xlsx xls docx ppt doc)
    when "music"
      %w(mp3 aac wav wma)
    when "scripts"
      %w(sh rb js py php)
    when "code"
      %w(html css java scss less m so)
    when "data"
      %w(xml json sql csv)
      #when "fonts"
      #%w(ttf woeff)
      #when "config"
      #%w(conf)
    when "archieves"
      %w(zip 7z tar tar.gz tgz tar.gz.md5 gzip rar tar.bz2)
    else
      puts @opt_parser
      error("Incorrect type ( #{type} ) there is no extensions for this. Try again")
  end
end
#
# Setup directories based on tags used, if path is not specified then current directory is used
def setup_directories(types,path)
  return if !@options[:sort]
  types.each { |tag| 
    mk_path = "#{path.nil? ? Dir.pwd : path.include?('~') ? File.expand_path('~') + path.split('~').join('') : path}/#{tag.to_s.capitalize}"
    Pathname.new(mk_path).mkpath
  }
end
#
# Get directory based on
def get_directory_for_type(type,path)
  return path if !@options[:sort]
  "#{path.include?('~') ? File.expand_path('~') + path.split('~').join('') : path}/#{type.to_s.capitalize}"
end
#
# Ensure / is added to end of directory
def tailor_path(path)
  if path[-1] != '/'
    path += "/"
  end
end
#
# Get a organized hash of filenames based on a path and a optional types array
def get_files_by_types(path,types)
  obj = Hash.new
  
  # Quick validation is ensure it ends with a /
  if path[-1] != '/'
    path += "/"
  end
  
  types.each { |i| 
    obj[i] ||= Array.new
    if i == 'all'
      obj[i] = @options[:recursive_mode] ? Dir["#{path}**/*.*"] : Dir["#{path}*.*"]
    else
      get_exts(i).each{ |ext| obj[i] += @options[:recursive_mode] ? Dir["#{path}**/*.#{ext}"] : Dir["#{path}*.#{ext}"] }
    end
  }
  #
  return obj
end
#
# Validate that a directory exists based on path given
def dir_exists?(path)
  File.directory?(path)
end
# def get_to_dir
#   @options[:to].nil? ? Dir.pwd : @options[:to]
# end
#
# def get_from_dir
#   @options[:from].nil? ? Dir.pwd : @options[:from]
# end
#
# Move files to and from (where the magic happens)
def move(harmonize)
  return if harmonize.nil?
  
  harmonize[:content].each_pair{|k,v|
    if v.count == 0
      pu "No (#{k.capitalize}) to move"
      exit(0)
    else
      setup_directories(harmonize[:types], harmonize[:to])
      to_dir = get_directory_for_type(k, harmonize[:to])
      pu "Moving #{v.count} (#{k.capitalize}) files to #{to_dir}" 
      FileUtils.mv(v, to_dir, {:verbose => harmonize[:verbose], :force => @options[:force]})
    end
  }
end
#################

#### [ Starting the Program ] ####

# 0. Validate usage (dont need since everything is initialized by default)
# if (ARGV[0].nil? && @options.empty?)
#   pu "ERROR => Incorrect Usage"
#   puts @opt_parser
#   exit(0)
# end

# 1. Setup 
@harmonize[:types] = get_type( !ARGV[0] ? '' : ARGV[0], @acceptible_types)
@harmonize[:from] = @options[:from]
@harmonize[:to] = @options[:to]
@harmonize[:sort] = @options[:sort]
@harmonize[:verbose] = @options[:verbose]

#setup_directories(@harmonize[:types], @harmonize[:to])

# 2. Get Extensions of files we need to harmonize
@harmonize[:content] = get_files_by_types(@harmonize[:from], @harmonize[:types])

# 4. Move
move(@harmonize)

# Finished :)
pu "Now run `cd #{@harmonize[:to]}` and checkout you newely organized files :)"



