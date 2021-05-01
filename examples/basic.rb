require 'dxruby_editor'
# include DXRubyEditor

Window.bgcolor = [30, 30, 30]
Window.width = 1280

editor = DXRubyEditor::Editor.new(640, 480, page_height: 800, content: "# your code here ...")

Window.loop do
  break if Input.key_down?(K_ESCAPE)

  Window.draw_font(0, 0, "fps : #{Window.real_fps}", Font.default)
end
