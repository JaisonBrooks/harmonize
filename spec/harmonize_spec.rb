# Harmonize Specs
# Author: Jaison Brooks
# Dec 2015

require 'spec_helper'
require File.expand_path('../src/harmonize.rb', File.dirname(__FILE__))

RSpec.describe Harmonize do
  context 'without options' do
    
    before(:each) do
      @harmonize = Harmonize.new
    end
    
    it 'should not be null' do
      expect(@harmonize.nil?).to eq false
    end
    
    context 'should have attributes' do
      it 'Input' do
        expect(@harmonize.input.nil?).to_not eq true
        expect(@harmonize.input).to eq @harmonize.slash!(Dir.pwd)
      end
      it 'Output' do
        expect(@harmonize.output.nil?).to_not eq true
        expect(@harmonize.output).to eq @harmonize.slash!(Dir.home)
      end
      it 'Verbose' do
        expect(@harmonize.verbose.nil?).to_not eq true
        expect(@harmonize.verbose).to eq false
      end
      it '#Recursive' do
        expect(@harmonize.recursive.nil?).to_not eq true
        expect(@harmonize.recursive).to eq false
      end
      it 'Force' do
        expect(@harmonize.force.nil?).to_not eq true
        expect(@harmonize.force).to eq false
      end
      it 'Launch' do
        expect(@harmonize.launch.nil?).to_not eq true
        expect(@harmonize.launch).to eq false
      end
      it 'Dry' do
        expect(@harmonize.dry.nil?).to_not eq true
        expect(@harmonize.dry).to eq false
      end
      it 'Pretend' do
        expect(@harmonize.pretend.nil?).to_not eq true
        expect(@harmonize.pretend).to eq false
      end
      it 'Cop' do
        expect(@harmonize.cop.nil?).to_not eq true
        expect(@harmonize.cop).to eq false
      end
    end
        
  end
  context 'with options' do
    before(:each) do
      @harmonize = Harmonize.new({
        :input => File.expand_path('spec/test_files/'), 
        :output => File.expand_path('spec/test_output/'), 
        :verbose => true, 
        :recursive => true, 
        :force => true, 
        :launch => true,
        :dry => true,
        :pretend => true,
        :cop => true
        })
    end
    it 'should not be nil' do
      expect(@harmonize.nil?).to_not eq true
    end
    context 'has attribute' do
      it 'Input' do
        expect(@harmonize.input.nil?).to_not eq true
        expect(@harmonize.input).to eq "#{File.expand_path('spec/test_files')}/"
      end
      it 'Output' do
        expect(@harmonize.output.nil?).to_not eq true
        expect(@harmonize.output).to eq "#{File.expand_path('spec/test_output')}/"
      end
      it 'Verbose' do
        expect(@harmonize.verbose.nil?).to_not eq true
        expect(@harmonize.verbose).to eq true
      end
      it 'Recursive' do
        expect(@harmonize.recursive.nil?).to_not eq true
        expect(@harmonize.recursive).to eq true
      end
      it 'Force' do
        expect(@harmonize.force.nil?).to_not eq true
        expect(@harmonize.force).to eq true
      end
      it 'Launch' do
        expect(@harmonize.launch.nil?).to_not eq true
        expect(@harmonize.launch).to eq true
      end
      it 'Dry' do
        expect(@harmonize.dry.nil?).to_not eq true
        expect(@harmonize.dry).to eq true
      end
      it 'Pretend' do
        expect(@harmonize.pretend.nil?).to_not eq true
        expect(@harmonize.pretend).to eq true
      end
      it 'Cop' do
        expect(@harmonize.cop.nil?).to_not eq true
        expect(@harmonize.cop).to eq true
      end
    end  
  end
  context 'regardless' do
    context 'has KEYS' do
      it 'Standard' do
        expect(Harmonize::KEYS[:standard].nil?).to_not eq true
        expect(Harmonize::KEYS[:standard].keys.count).to be >= 1
      end
      it 'Special' do
        expect(Harmonize::KEYS[:special].nil?).to_not eq true
        expect(Harmonize::KEYS[:special].keys.count).to be >= 1
      end
    end
    it 'has VERSION' do
      expect(Harmonize::VERSION.nil?).to_not eq true
      expect(Harmonize::VERSION.class).to eq String
    end
  end
  context 'methods' do
    context 'tae_obj' do
      before(:all) do
        @harmonize = Harmonize.new
      end
      it 'returns a hash, with data, for a valid key' do
        result = @harmonize.tae_obj('pictures')
        expect(result).to_not eq nil
        expect(result.class).to eq Hash
        expect(result[:key]).to eq 'pictures'
        expect(result[:name]).to eq 'Pictures'
        expect(result[:file_extensions].include?('png')).to eq true
        expect(result[:files]).to eq Array.new
        expect(result[:files].class).to eq Array
      end
      it 'exits the script when an invalid key is entered' do
        expect{@harmonize.tae_obj('')}.to raise_error(SystemExit)
      end
    end
    context 'to_hash' do
      before(:all) do
        @harmonize = Harmonize.new({
        :input => File.expand_path('spec/test_files/'),
        :output => File.expand_path('spec/test_output/'), 
        :verbose => true, 
        :recursive => true, 
        :force => true, 
        :launch => true,
        :dry => true,
        :pretend => true,
        :cop => true
      })
      @result = @harmonize.to_hash
      end
      it 'returns a hash of variables' do
        expect(@result[:input]).to eq @harmonize.input
        expect(@result[:output]).to eq @harmonize.output
        expect(@result[:verbose]).to eq @harmonize.verbose
        expect(@result[:recursive]).to eq @harmonize.recursive
        expect(@result[:launch]).to eq @harmonize.launch
        expect(@result[:dry]).to eq @harmonize.dry
        expect(@result[:pretend]).to eq @harmonize.pretend
        expect(@result[:cop]).to eq @harmonize.cop
      end
    end
    context 'error' do
      before(:all) do
        @harmonize = Harmonize.new
      end
      it 'should exit the script' do
        expect{@harmonize.error('')}.to raise_error(SystemExit)
      end
      # it 'should output to console' do
#           expect(@harmonize.error('test')).to eq @stderr.puts "[Harmonize] \033[0;31mtest\033[0m, \033[0;36mGame Over...\033[0m"
#         end
    end
    context 'pu' do
      before(:all) do
        @harmonize = Harmonize.new
      end
      it 'should output to console' do
        expect(@harmonize.pu).to eq $stderr.puts '[Harmonize] '
      end
      it 'should output to console if text was given' do
        expect(@harmonize.pu('test')).to eq $stderr.puts '[Harmonize] test'
      end
    end
    context 'finish' do
      before(:all) do
        @harmonize = Harmonize.new({:launch => true, :output => File.expand_path('spec/test_output/')})
      end
      it 'should open the output folder' do
        @harmonize.should_receive('exec').with("open #{File.expand_path('spec/test_output/')}/")
        @harmonize.finish
      end
    end
  end
end
