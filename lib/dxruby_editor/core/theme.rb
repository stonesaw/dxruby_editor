module DXRubyEditor
  module Core
    class Theme
      def initialize(hash = {})
        @theme = DEFAULT_THEME.merge(hash).map do |tag, color|
          if self.class.typeof_color_code?(color)
            [tag, self.class.parse_color_code(color)]
          else
            [tag, color]
          end
        end.to_h
      end

      def []=(key, value)
        @theme[key] = value
      end

      def [](key)
        @theme[key]
      end

      # @param [String] color_code like '#f1f1f1', '#ff0000'
      # @return [Boolean]
      # @raise [ArgumentError]
      def self.typeof_color_code?(color_code)
        if /^#(?<hex>\h+)$/i =~ color_code
          if hex.length == 3 ||
             hex.length == 4 ||
             hex.length == 6 ||
             hex.length == 8
            return true
          end

          raise ArgumentError, "Misstake! color_code ('##{hex}')"
        end
        false
      end

      # @param [String] color_code like '#f1f1f1', '#f00'
      # @return [Array<Integer>] like [255, 255, 255], [120, 255, 0, 0]
      # @raise [ArgumentError]
      def self.parse_color_code(color_code)
        if /^#(?<hex>\h+)$/i =~ color_code
          hex.downcase!
          case hex.length
          when 3, 4
            hex = hex.split('').map { |char| char * 2 }.join
          when 6, 8
          else
            raise ArgumentError, "Misstake! color_code ('##{hex}')"
          end

          ary = []
          3.times { |i| ary << hex_to_int(hex[i * 2..i * 2 + 1]) }
          ary.unshift(hex_to_int(hex[6..7])) if hex.length == 8
          ary
        else
          raise ArgumentError, "Misstake! color_code format ('##{color_code}')"
        end
      end

      # @param [String] hex like 'ab', 'f1'
      # @return [Integer] like 171, 241
      def self.hex_to_int(hex)
        int = 0
        scale = 1
        hex.split('').reverse.each do |char|
          num = if char =~ /[a-f]/
                  10 + char.ord - 'a'.ord
                else
                  char.to_i
                end

          int += num * scale
          scale *= 16
        end
        int
      end

      DEFAULT_THEME = {
        bg: '#333842',
        font: '#D7DAE0',
        lineno: '#636D83',
        lineno_active: '#ABB2BF',
        line_highlight: '#99BBFF0A',
        cursor: '#528BFF',
        scrollbar: '#4E566680',
        scrollbar_active: '#747D9180',

        syntax_comment: '#5C6370',
        syntax_class: '#E5C07B',
        syntax_keyword: '#C678DD',
        syntax_op: '#C678DD',
        syntax_constant: '#D19A66',
        syntax_numeric: '#D19A66',
        syntax_variable: '#E06C75',
        syntax_string: '#98C379',
        syntax_regex: '#56B6C2',
      }.freeze
    end
  end
end
