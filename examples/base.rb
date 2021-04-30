require 'dxruby_editor'
# include DXRubyEditor

Window.bgcolor = [30, 30, 30]
Window.width = 1280

editor = DXRubyEditor::Editor.new(640, 480, page_height: 800)

tick = 0
Window.loop do
  break if Input.key_down?(K_ESCAPE)


  Window.draw_font(0, 0, "[Main Window]", Font.default)
  Window.draw_font(0, 24, "fps : #{Window.real_fps}, tick : #{tick}", Font.default)

  tick += 1
end
