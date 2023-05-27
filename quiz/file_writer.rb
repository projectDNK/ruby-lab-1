module QuizName
  class FileWriter
    def initialize(mode, *args)
      @answers_dir = args[0]
      @filename = args[1]
      @mode = mode
    end

    def write(message)
      File.open(prepare_filename(@answers_dir, @filename), @mode) do |f|
        f.write(message)
      end
    end

    def prepare_filename(answers_dir, filename)
      File.expand_path("#{filename}.txt", answers_dir)
    end
  end
end
