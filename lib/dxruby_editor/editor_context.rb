module DXRubyEditor
  class EditorContext
    attr_reader :file_name
    attr_accessor :text, :cursor_x, :cursor_y, :tab_size, :tick

    # @param [String] file_name
    # @param [String] text
    def initialize(file_name, text)
      @file_name = file_name
      @text = text.split(/\R/)
      @cursor_x = 1
      @cursor_y = 1
      @tab_size = 2
      @tick = 0
    end
  end
end
