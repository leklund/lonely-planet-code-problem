require 'nokogiri'
require 'saxerator'
require 'erb'
require 'fileutils'

ROOT_PATH = ENV['ROOT_PATH'] || '/' 

Dir.glob(__dir__ + '/lonely_planet/*.rb') { |f| require_relative  f }
