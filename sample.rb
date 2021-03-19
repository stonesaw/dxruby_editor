require 'dxruby'

$PATH = File.dirname(__FILE__)

require_relative 'lib/editor'

Window.bgcolor = [30, 30, 30]
Window.width = 1280

editor = Editor.new(640, 480, page_height: 800)

tick = 0
Window.loop do
  break if Input.key_down?(K_ESCAPE)

  editor.update

  Window.draw_font(0, 0, "[Main Window] tick : #{tick}", Font.default)

  editor.draw_window
  tick += 1
end
