require 'ripper'

module DXRubyEditor
  class Editor < ScrollablePage
    attr_accessor :x, :y, :core

    def initialize(position: :right, size: 640, content: "", theme: nil)
      super(size, Window.height)
      Window.before_call[:editor_update] = method(:update)
      Window.after_call[:editor_draw] = method(:draw_at_window)

      @x = Window.width - width
      @y = Window.height - height
      @core = EditorCore.new(content)
      @theme = theme || ThemeColor.new(File.join($LOAD_PATH[0], "assets/OneDark.json"))

      self.bgcolor = @theme.editor_bg
      self.scrollbar_base = Image.new(scrollbar_base.width, scrollbar_base.height).
        line(0, 0, 0, scrollbar_base.height, @theme.editor_scrollbar)
      self.scrollbar = Image.new(scrollbar.width, scrollbar.height, @theme.editor_scrollbar)
      @font21 = Font.new(21)
      @font_ = Font.new(14)
      @font10 = Font.new(10)

      @tick = 0
      @editor_main_x = 50
      @editor_main_y = 20
      @play_button_images = []
      @runcode = ''
      @notifications = []

      set_page_height(@editor_main_y + (@core.content.length - 1) * @font21.size + height)
    end

    def update
      unless Input.keys.empty?
        if height < @core.cursor_y * @font21.size - pos
          self.pos += @font21.size
        elsif @editor_main_y > @core.cursor_y * @font21.size - self.pos
          self.pos -= @font21.size
        end
      end

      set_page_height(@editor_main_y + (@core.content.length - 1) * @font21.size + height)

      @core.input(@tick)

      super

      @runcode = @core.string if Input.key_push?(K_F5)
      begin
        eval(@runcode)
      rescue => exception
        @notifications << exception.message
        @runcode = ''
      end

      @tick += 1
    end

    def draw_at_window(render_target: Window)
      draw_lineno
      draw_content_syntax
      draw_cursor
      draw_scrollbar
      draw_notifications
      render_target.draw(@x, @y, self)
      draw_footer
    end

    protected def draw_lineno
      @core.content.length.times do |i|
        if i + 1 == @core.cursor_y
          _color = @theme.editor_lineno_active

          # draw line highlight
          draw_box_fill(0,     @editor_main_y + @font21.size * i,
                        width, @editor_main_y + @font21.size * (i + 1), @theme.editor_line_highlight)
        else
          _color = @theme.editor_lineno
        end
        draw_font(@editor_main_x - 10 - @font21.get_width("#{i + 1}"),
                  @editor_main_y + @font21.size * i, "#{i + 1}", @font21, color: _color)
      end
    end

    protected def draw_content
      @core.content.each_with_index do |str, i|
        draw_font(@editor_main_x, @editor_main_y + i * @font21.size, str.chomp, @font21, color: @theme.editor_font)
      end
    end

    protected def draw_content_syntax
      # TODO シンタックスハイライト機能
      # pp Ripper.lex(@core.string) if @tick % 100 == 0
      _width = 0
      before_line = -1
      Ripper.lex(@core.string).each do |_|
        line, column = _[0][0], _[0][1]
        symbol = _[1]
        char = _[2]
        lexer_state = _[3]

        if before_line != line
          _width = 0
          before_line = line
        end

        # Ref https://github.com/ruby/ruby/blob/master/ext/ripper/eventids2.c#L83
        _color =
          case symbol
          when :on_comment # comment
            @theme.editor_syntax_comment
          when :on_kw # class, def, end ...
            @theme.editor_syntax_keyword
          when :on_op # operator
            @theme.editor_syntax_op
          when :on_const # CONSTANT, ClassName
            @theme.editor_syntax_constant
          when :on_label, :symbeg # symbol
            @theme.editor_syntax_constant
          when :on_int, :on_float # integer
            @theme.editor_syntax_numeric
          when :on_ident, :on_ivar, :on_cvar, :on_gvar, :on_backref # variable
            @theme.editor_syntax_variable
          when :on_tstring_beg, :on_tstring_content, :on_tstring_end # string
            @theme.editor_syntax_string
          when :on_regexp_beg, :on_regexp_end # regex
            @theme.editor_syntax_regex
          # when :on_comma # comma
          #   @theme.editor_font
          # when :on_period # period
          #   @theme.editor_font
          # when :on_semicolon # semicolon
          #   @theme.editor_font
          # when :on_lparen, :on_rparen # ()
          #   C_WHITE
          # when :on_lbracket, :on_rbracket # []
          #   C_WHITE
          # when :on_lbrace, :on_rbrace # {}
          #   C_WHITE
          else
            @theme.editor_font
          end

        draw_font(@editor_main_x + _width, @editor_main_y + (line - 1) * @font21.size, char.chomp, @font21, color: _color)
        _width += @font21.get_width(char)
      end
      # @core.content.each_with_index do |c, i|
      #   draw_font_ex(@editor_main_x, @editor_main_y + i * @font21.size, c, @font21)
      # end
    end

    protected def draw_cursor
      _w = @font21.get_width(@core.content[@core.cursor_y - 1][0..@core.cursor_x - 2])
      _w = 0 if @core.cursor_x == 1

      if @theme.editor_cursor.length == 3
        _alpha = Math.sin(@tick / 20.0).abs * 255
        _color = @theme.editor_cursor.dup
        _color.unshift(_alpha)
      else
        _alpha = Math.sin(@tick / 20.0).abs * @theme.editor_cursor[0]
        _color = @theme.editor_cursor.dup
        _color[0] = _alpha
      end
      draw_box_fill(@editor_main_x + _w,     @editor_main_y + @font21.size * (@core.cursor_y - 1),
                    @editor_main_x + _w + 1, @editor_main_y + @font21.size * @core.cursor_y,
                    _color)
    end

    protected def draw_notifications
      @notifications.each_with_index do |msg, i|
        # draw_box_fill()
        draw_font(240, 300 + i * (@font_.size + 10), msg, @font_)
      end
    end

    protected def draw_footer
      Window.draw_font(Window.width - 300, Window.height - 20, "行 #{@core.cursor_y}、列 #{@core.cursor_x}", @font10)
    end
  end
end
