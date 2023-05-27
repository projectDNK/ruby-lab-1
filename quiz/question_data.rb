require 'yaml'
require 'json'
require_relative 'question'

module QuizName
  class QuestionData
    attr_reader :collection

    def initialize(yaml_dir, in_ext)
      @collection = []
      @yaml_dir = yaml_dir
      @in_ext = in_ext
      @threads = []
      load_data
    end

    def to_yaml
      @collection.to_yaml
    end

    def save_to_yaml(filename)
      File.write(prepare_filename(filename), to_yaml)
    end

    def to_json
      @collection.to_json
    end

    def save_to_json(filename)
      File.write(prepare_filename(filename), to_json)
    end

    def prepare_filename(filename)
      File.expand_path(File.join(@yaml_dir, filename), __dir__)
    end

    def each_file(&block)
      Dir.glob(File.join(@yaml_dir, "*#{@in_ext}"), &block)
    end

    def in_thread(&block)
      @threads << Thread.new(&block)
    end

    def load_data
      each_file do |filename|
        in_thread do
          load_from(filename)
        end
      end
      @threads.each(&:join)
    end

    def load_from(filename)
      data = YAML.load_file(filename)
      data.shuffle!
      data.each do |q|
        question = Question.new(q['question'], q['answers'])
        @collection << question
      end
    end
  end
end
