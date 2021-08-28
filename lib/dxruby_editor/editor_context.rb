module DXRubyEditor
  class EditorContext
    attr_reader :file_name, :text, :str
    attr_accessor :cursor_x, :cursor_y, :tab_size, :tick

    # @param [String] file_name
    # @param [String] text
    def initialize(file_name, str)
      @file_name = file_name
      @str = str
      @text = str.split(/\R/)
      @cursor_x = 1
      @cursor_y = 1
      @tab_size = 2
      @tick = 0
    end

    def str=(str)
      @str = str
      @text = str.split(/\R/)
    end

    def text=(text)
      @text = text
      @str = text.join("\n")
    end
  end
end
