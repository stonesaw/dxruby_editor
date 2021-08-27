require 'dxruby_editor'
include DXRubyEditor

Window.width = 1280

editor = Editor.new.new_file(text: "# your code here ...")

Window.loop do
  break if Input.key_down?(K_ESCAPE)

  Window.draw_font(0, 0, "fps : #{Window.real_fps}", Font.default)
end
