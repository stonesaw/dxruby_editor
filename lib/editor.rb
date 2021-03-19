require_relative 'editor_core'
require_relative 'scrollable_page'

class Editor < ScrollablePage
  def initialize(width, height, bgcolor: [40, 44, 53],
                 page_width: nil, page_height: nil)
    super
    @x = Window.width - width
    @y = Window.height - height
    @font = Font.new(21)
    @font_mini = Font.new(10)
    @core = EditorCore.new
    @tick = 0
    @editor_main_x = 50
    @editor_main_y = 10
    @play_button_images = []
  end

  def update
    super
    @core.input(@tick)
    @tick += 1
  end

  def draw_window
    @core.content.length.times do |i|
      if i + 1 == @core.cursor_y
        color = [166, 176, 182]
      else
        color = [85, 98, 113]
      end
      draw_font(40 - @font.get_width("#{i + 1}"), 10 + @font.size * i, "#{i + 1}", @font, color: color)
    end
    draw_font(@editor_main_x, @editor_main_y, @core.string, @font)
    w = @font.get_width(@core.content[@core.cursor_y - 1][0..@core.cursor_x - 2])
    w = 0 if @core.cursor_x == 1
    alpha = Math.sin(@tick / 20.0).abs * 255
    draw_box_fill(@editor_main_x + w,     @editor_main_y + (@core.cursor_y - 1) * @font.size,
                  @editor_main_x + w + 1, @core.cursor_y * @font.size + 8,
                  [alpha, 80, 139, 255])
    draw_scrollbar
    Window.draw(@x, @y, self)
    Window.draw_font(Window.width - 300, Window.height - 20, "行 #{@core.cursor_y}、列 #{@core.cursor_x}", @font_mini)
  end
end
