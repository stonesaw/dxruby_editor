# Support VS Code Theme Color
# https://code.visualstudio.com/api/references/theme-color

require 'json'

class ThemeColor
  attr_reader :theme_json

  attr_reader :editor_bg
  attr_reader :editor_font
  attr_reader :editor_lineno
  attr_reader :editor_lineno_active
  attr_reader :editor_line_highlight
  attr_reader :editor_cursor

  # Converts the object into textual markup given a specific `format` 
  # (defaults to `:html`)
  #
  # == Parameters:
  # format::
  #   A Symbol declaring the format to convert the object to. This 
  #   can be `:text` or `:html`.
  #
  # == Returns:
  # A string representing the object in a specified
  # format.
  #
  def initialize(file_path)
    File.open(file_path) do |file|
      @theme_json = JSON.load(file)
    end

    @editor_bg             = parse_color_code(@theme_json['colors']['editor.background']) || C_CYAN
    @editor_font           = parse_color_code(@theme_json['colors']['editor.foreground']) || C_CYAN
    @editor_lineno         = parse_color_code(@theme_json['colors']['editorLineNumber.foreground']) || C_CYAN
    @editor_lineno_active  = parse_color_code(@theme_json['colors']['editorLineNumber.activeForeground']) || C_CYAN
    @editor_line_highlight = parse_color_code(@theme_json['colors']['editor.lineHighlightBackground']) || C_CYAN
    @editor_cursor         = parse_color_code(@theme_json['colors']['editorCursor.foreground']) || C_CYAN

    # find scope
    # token example
    # {
    #     "name": "Comment",
    #     "scope": [
    #         "comment"
    #     ],
    #     "settings": {
    #         "foreground": "#5C6370",
    #         "fontStyle": "italic"
    #     }
    # }
    @theme_json['tokenColors'].each do |token|
      scope = token['scope']
      color = token['settings']['foreground']

      if scope.include?('comment')
        @editor_syntax_comment = color
      end
    end
  end

  # conversion VSCode Color formats -> DXRuby color  
  # VSCode Color formats {https://code.visualstudio.com/api/references/theme-color#color-formats}  
  # DXRuby ColorCode {http://mirichi.github.io/dxruby-doc/api/constant_color.html}  
  # 
  # @param [String] color_code like +#RGB+, +#RGBA+, +#RRGGBB+ and +#RRGGBBAA+ (VSCode Color formats)
  # @return [Array] DXRuby color like +[A,R,G,B]+ or +[R,G,B]+
  def parse_color_code(color_code)
    if /^#(?<hex>\h+)$/i =~ color_code
      hex.downcase!
      case hex.length
      when 3, 4
        hex = hex.split('').map {|char| char * 2 }.join
      when 6, 8
      else
        raise ArgumentError, "color_code hex (#{hex})"
      end

      ary = []
      3.times {|i| ary << _hex_to_int(hex[i * 2..i * 2 + 1]) }
      ary.unshift(_hex_to_int(hex[6..7])) if hex.length == 8
      ary
    else
      raise ArgumentError, "color_code format (#{color_code})"
    end
  end

  # @param [String] hex like 'ab', 'f1'
  # @return [Integer] aaa
  def _hex_to_int(hex)
    int = 0
    scale = 1
    hex.split('').reverse.each_with_index do |char|
      if char =~ /[a-f]/
        num = 10 + char.ord - 'a'.ord
      else
        num = char.to_i
      end

      int += num * scale
      scale *= 16
    end
    int
  end
end
