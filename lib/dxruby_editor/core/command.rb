module DXRubyEditor
  module Core
    module Command
      # when push Ctrl + S do
      # execute save

      module_function def update(context)
        if (Input.key_down?(K_LCONTROL) || Input.key_down?(K_RCONTROL)) && Input.key_down?(K_S)
          save(context)
        end
      end

      def self.save(context)
        puts "Save #{context.file_name}"
        # DXRuby 付属のファイル保存機能だと、保存するファイル名のデフォルト値を付けれなかったり
        # ディレクトリが違ったりして少し不便なので、自作する可能性あり
        p Window.save_filename([["Ruby(*.rb)", "*.rb"], ["すべてのファイル(*.*)", "*.*"]], "Save File")
      end
    end
  end
end
