require 'protobuf'
require 'google/transit/gtfs-realtime.pb'
require 'net/http'
require 'uri'
require 'pry'
require 'json'
require 'date'

require_relative '../lib/trip.rb'
require_relative '../lib/stop-time-update.rb'
require_relative '../lib/api-interface.rb'