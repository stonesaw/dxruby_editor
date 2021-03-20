require_relative 'editor_core'
require_relative 'scrollable_page'

class Editor < ScrollablePage
  attr_accessor :x, :y, :core

  def initialize(width, height, bgcolor: [40, 44, 53],
                 page_width: nil, page_height: nil)
    super
    @x = Window.width - width
    @y = Window.height - height
    @core = EditorCore.new
    @font21 = Font.new(21)
    @font_ = Font.new(14)
    @font10 = Font.new(10)
    @tick = 0
    @editor_main_x = 50
    @editor_main_y = 10
    @play_button_images = []
    @runcode = ''
    @notifications = []
  end

  def update
    super
    @core.input(@tick)

    @runcode = @core.string if Input.key_push?(K_F5)
    begin
      eval(@runcode)
    rescue => exception
      @notifications << exception.message
      @runcode = ''
    end

    @tick += 1
  end

  alias_method :draw_self, :draw

  def draw_at_window(render_target: Window)
    draw_lineno
    draw_content
    draw_cursor
    draw_scrollbar
    draw_notifications
    draw_footer
    render_target.draw(@x, @y, self)
  end

  protected def draw_lineno
    @core.content.length.times do |i|
      if i + 1 == @core.cursor_y
        _color = [166, 176, 182]
      else
        _color = [85, 98, 113]
      end
      draw_font(40 - @font21.get_width("#{i + 1}"), 10 + @font21.size * i, "#{i + 1}", @font21, color: _color)
    end
  end

  protected def draw_content
    # TODO シンタックスハイライト機能
    @core.content.each_with_index do |c, i|
      draw_font_ex(@editor_main_x, @editor_main_y + i * @font21.size, c, @font21)
    end
  end

  protected def draw_cursor
    _w = @font21.get_width(@core.content[@core.cursor_y - 1][0..@core.cursor_x - 2])
    _w = 0 if @core.cursor_x == 1
    _alpha = Math.sin(@tick / 20.0).abs * 255
    draw_box_fill(@editor_main_x + _w,     @editor_main_y + (@core.cursor_y - 1) * @font21.size,
                  @editor_main_x + _w + 1, @core.cursor_y * @font21.size + 8,
                  [_alpha, 80, 139, 255])
  end

  protected def draw_notifications
    @notifications.each_with_index do |msg, i|
      # draw_box_fill()
      draw_font(240, 300 + i * (@font_.size + 10), msg, @font_)
    end
  end

  protected def draw_footer
    draw_font(width - 300, height - 20, "行 #{@core.cursor_y}、列 #{@core.cursor_x}", @font10)
  end
end
