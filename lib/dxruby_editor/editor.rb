module DXRubyEditor
  class Editor < RenderTarget
    attr_reader :width, :height, :context
    attr_accessor :theme, :x, :y

    # TODO: @position

    # @param [Integer] size エディターのサイズ
    # @param [Integer] theme エディターのカラーテーマを設定します
    # call once
    def initialize(width: 640, height: Window.height, theme: nil)
      Window.before_call[:editor_update] = method(:update)
      Window.after_call[:editor_draw] = method(:draw_at_window)

      @width = width
      @height = height
      @theme = theme || Core::Theme.new
      super(width, height, @theme[:bg])

      @x = Window.width - @width
      @y = 0
      @context = nil

      self
    end

    # 新しいファイルを作成してエディターを開きます

    # @param [String] text 最初に表示数テキスト
    def new_file(text: '')
      file_name = 'untitled-1.rb'
      @context = EditorContext.new(file_name, text)
    end

    # 既にあるファイルをエディターを開きます

    # @param [String] file_name 開くファイルの名前
    # @param [Integer] size エディターのサイズ
    # @param [Integer] theme エディターのカラーテーマを設定します
    def open(file_name, size: 640, theme: nil)
      file = File.open(file_name, 'r')
      text = file.read
      file.close

      @context = EditorContext.new(file_name, text)
    end

    def debug; end

    def production; end

    # main loop
    def update
      Core::KeyInput.update(@context)
      # Core::MouseInput.update(@context)

      @run_code = @context.str if Input.key_push?(K_F5)
      begin
        eval(@run_code)
      rescue StandardError => e
        puts(e.message)
        @run_code = ''
      end

      @context.tick += 1
    end
  end

  def draw_at_window
    Core::Renderer.update(self, @context, @theme)
    Window.draw(@x, @y, self)
  end
end
