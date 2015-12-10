# Harmonize Specs
# Author: Jaison Brooks
# Dec 2015

require 'spec_helper'
require File.expand_path('../src/harmonize.rb', File.dirname(__FILE__))

RSpec.describe Harmonize, "when" do
  
  context "initiated w/out params" do
    
    before(:each) do
      @harmonize = Harmonize.new
    end
    
    it 'should not be null' do
      expect(@harmonize.nil?).to eq false
    end
    
    context 'should have attributes' do
      
      it '#INPUT' do
        expect(@harmonize.input.nil?).to_not eq true
        expect(@harmonize.input).to eq @harmonize.slash!(Dir.pwd)
      end
      it '#OUTPUT' do
        expect(@harmonize.output.nil?).to_not eq true
        expect(@harmonize.output).to eq @harmonize.slash!(Dir.home)
      end
      it '#VERBOSE' do
        expect(@harmonize.verbose.nil?).to_not eq true
        expect(@harmonize.verbose).to eq false
      end
      it '#RECURSIVE' do
        expect(@harmonize.recursive.nil?).to_not eq true
        expect(@harmonize.recursive).to eq false
      end
      it '#FORCE' do
        expect(@harmonize.force.nil?).to_not eq true
        expect(@harmonize.force).to eq false
      end
      it '#LAUNCH' do
        expect(@harmonize.launch.nil?).to_not eq true
        expect(@harmonize.launch).to eq false
      end
      
    end
        
  end
  
  context 'initiated w/ params' do
    
    before(:each) do
      @harmonize = Harmonize.new({
        :input => File.expand_path('spec/test_files/'), 
        :output => File.expand_path('spec/test_output/'), 
        :verbose => true, 
        :recursive => true, 
        :force => true, 
        :launch => true
        })
    end
    
    it 'should not be nil' do
      expect(@harmonize.nil?).to_not eq true
    end
    
    context 'should have attributes' do
      it '#INPUT' do
        expect(@harmonize.input.nil?).to_not eq true
        expect(@harmonize.input).to eq "#{File.expand_path('spec/test_files')}/"
      end
      it '#OUTPUT' do
        expect(@harmonize.output.nil?).to_not eq true
        expect(@harmonize.output).to eq "#{File.expand_path('spec/test_output')}/"
      end
      it '#VERBOSE' do
        expect(@harmonize.verbose.nil?).to_not eq true
        expect(@harmonize.verbose).to eq true
      end
      it '#RECURSIVE' do
        expect(@harmonize.recursive.nil?).to_not eq true
        expect(@harmonize.recursive).to eq true
      end
      it '#FORCE' do
        expect(@harmonize.force.nil?).to_not eq true
        expect(@harmonize.force).to eq true
      end
      it '#LAUNCH' do
        expect(@harmonize.launch.nil?).to_not eq true
        expect(@harmonize.launch).to eq true
      end
    end
    
  end
  
end
