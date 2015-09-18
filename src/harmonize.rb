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

# General #
@acceptible_types = %w(pics vids docs scripts archieves data code)
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
  opt.separator "|  #{colorize(' TYPES ','white','black')} = #{colorize('pics, vids, docs, scripts, archieves, data, code, all', 'light green')}     |"
  opt.separator "|                                                                      |"
  opt.separator "|  #{colorize(' ARGUMENTS ','white','black')} = #{colorize('--to, --from, -from_all, --no_sort, --verbose, --help','light blue')} |"
  opt.separator "|                                                                      |"
  opt.separator "|----------------------------------------------------------------------|"
  opt.separator ""
  
  opt.on("-h","--help","#{colorize('Help','cyan')} (show this help page)") do
      puts @opt_parser
      exit(0)
  end
    
  opt.on("-v","--verbose","#{colorize('Verbose ', 'cyan')}(includes extra output while executing)") do
      @options[:verbose] = true
  end
  
  opt.on("-n", "--no_sort", "#{colorize('No Sort ', 'cyan')}(Doesnt orangize your files, only moves them to your TO folder)") do
    @options[:sort] = false
  end
  
  opt.on("-t", "--to FOLDER_PATH", "#{colorize('To ', 'cyan')}(move files here)") do |to|
    @options[:to] = to
  end
  
  opt.on("-f", "--from FOLDER_PATH", "#{colorize('From ', 'cyan')}(get files from this folder)") do |from|
    @options[:from] = from
    @options[:recursive_mode] = false
  end
  
  opt.on("-F", "--from_all FOLDER_PATH", "#{colorize('From ', 'cyan')}(get files from this folder and all sub folders)\n\n|======================================================================|\n.\n") do |from_all|
    @options[:from] = from_all
    @options[:recursive_mode] = true
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
      %w(jpg gif jpeg png tiff bmp)
    when "vids"
      %w(mov mpeg avi mp4)
    when "docs"
      %w(pdf xlsx docx ppt)
    when "scripts"
      %w(sh rb js py php)
    when "code"
      %w(html css java scss less)
    when "data"
      %w(xml json sql)
    when "archieves"
      %w(zip 7zip tar tar.gz tar.gz.md5 gzip)
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
    to_dir = get_directory_for_type(k, harmonize[:to])
    pu "Moving #{v.count} (#{k.capitalize}) files to #{to_dir}" 
    FileUtils.mv(v, to_dir, {:verbose => harmonize[:verbose]})
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

# 2. Init Folders based on tags and where to store
setup_directories(@harmonize[:types], @harmonize[:to])

# 3. Get Extensions of files we need to harmonize
@harmonize[:content] = get_files_by_types(@harmonize[:from], @harmonize[:types])

# 4. Move
move(@harmonize)

# Finished :)
pu "Now run `cd #{@harmonize[:to]}` and checkout you newely organized files :)"



