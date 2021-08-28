require 'dxruby_editor'
include DXRubyEditor

Window.width = 1280

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
editor = Editor.new.open('./code/hello_world.rb')

Window.loop do
  break if Input.key_down?(K_ESCAPE)
end
