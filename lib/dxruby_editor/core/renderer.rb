module DXRubyEditor
  module Core
    module Renderer
      def update(target, context, theme)
        draw_lineno(target, context, theme)
        # draw_text(target, context, theme)
        draw_text_syntax(target, context, theme)
        draw_cursor(target, context, theme)
        # draw_scrollbar(target, context, theme)
        # draw_notifications(target, context, theme)
        draw_footer(target, context, theme)
      end
      module_function :update

      @@font21 = Font.new(21)
      @@font_ = Font.new(14)
      @@font10 = Font.new(10)
      @editor_main_x = 50
      @@editor_main_y = 20

      class << self
        def draw_lineno(target, context, theme)
          context.text.length.times do |i|
            if i + 1 == context.cursor_y
              _color = theme[:lineno_active]

              # draw line highlight
              target.draw_box_fill(0, @@editor_main_y + @@font21.size * i,
                                   target.width, @@editor_main_y + @@font21.size * (i + 1), theme[:line_highlight])
            else
              _color = theme[:lineno]
            end
            target.draw_font(@editor_main_x - 10 - @@font21.get_width((i + 1).to_s),
                             @@editor_main_y + @@font21.size * i, (i + 1).to_s, @@font21, color: _color)
          end
        end

        def draw_text(target, context, theme)
          context.text.each_with_index do |str, i|
            target.draw_font(@editor_main_x, @@editor_main_y + i * @@font21.size, str.chomp, @@font21,
                             color: theme[:font])
          end
        end

        def draw_text_syntax(target, context, theme)
          # TODO: シンタックスハイライト機能
          # pp Ripper.lex(context.string) if context.tick % 100 == 0
          _width = 0
          before_line = -1
          str = ''
          context.text.each { |_| str << _ << "\n" }
          Ripper.lex(str).each do |_|
            line = _[0][0]
            column = _[0][1]
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
                theme[:syntax_comment] || theme[:font]
              when :on_kw # keyword ( class, def, end ... )
                theme[:syntax_keyword] || theme[:font]
              when :on_op # operator
                theme[:syntax_op] || theme[:font]
              when :on_const # CONSTANT, ClassName
                theme[:syntax_constant] || theme[:font]
              when :on_label, :symbeg # symbol
                theme[:syntax_constant] || theme[:font]
              when :on_int, :on_float # integer
                theme[:syntax_numeric] || theme[:font]
              when :on_ident, :on_ivar, :on_cvar, :on_gvar, :on_backref # variable
                theme[:syntax_variable] || theme[:font]
              when :on_tstring_beg, :on_tstring_text, :on_tstring_end # string
                theme[:syntax_string] || theme[:font]
              when :on_regexp_beg, :on_regexp_end # regex
                theme[:syntax_regex] || theme[:font]
              # when :on_comma # comma
              #   theme[:font]
              # when :on_period # period
              #   theme[:font]
              # when :on_semicolon # semicolon
              #   theme[:font]
              # when :on_lparen, :on_rparen # ()
              #   C_WHITE
              # when :on_lbracket, :on_rbracket # []
              #   C_WHITE
              # when :on_lbrace, :on_rbrace # {}
              #   C_WHITE
              else
                theme[:font]
              end

            target.draw_font(@editor_main_x + _width, @@editor_main_y + (line - 1) * @@font21.size,
                             char.chomp, @@font21, color: _color)
            _width += @@font21.get_width(char)
          end
          # context.text.each_with_index do |c, i|
          #   draw_font_ex(@editor_main_x, @@editor_main_y + i * @@font21.size, c, @@font21)
          # end
        end

        def draw_cursor(target, context, theme)
          _w = @@font21.get_width(context.text[context.cursor_y - 1][0..context.cursor_x - 2])
          _w = 0 if context.cursor_x == 1

          if theme[:cursor].length == 3
            _alpha = Math.sin(context.tick / 20.0).abs * 255
            _color = theme[:cursor].dup
            _color.unshift(_alpha)
          else
            _alpha = Math.sin(context.tick / 20.0).abs * theme[:cursor][0]
            _color = theme[:cursor].dup
            _color[0] = _alpha
          end
          target.draw_box_fill(@editor_main_x + _w, @@editor_main_y + @@font21.size * (context.cursor_y - 1),
                               @editor_main_x + _w + 1, @@editor_main_y + @@font21.size * context.cursor_y,
                               _color)
        end

        def draw_notifications(target, _context, _theme)
          @notifications.each_with_index do |msg, i|
            # target.draw_box_fill()
            target.draw_font(240, 300 + i * (@@font_.size + 10), msg, @@font_)
          end
        end

        def draw_footer(_target, context, _theme)
          Window.draw_font(Window.width - 300, Window.height - 20,
                           "行 #{context.cursor_y}、列 #{context.cursor_x}", @@font10)
        end
      end
    end
  end
end
