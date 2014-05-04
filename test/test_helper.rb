testdir = File.dirname(__FILE__)
$LOAD_PATH.unshift testdir unless $LOAD_PATH.include?(testdir)

libdir = File.dirname(File.dirname(__FILE__))
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require 'minitest/autorun'
require 'mocha/mini_test'
require 'rack/test'
