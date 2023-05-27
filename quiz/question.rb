require 'json'
require 'yaml'

module QuizName
  class Question
    attr_accessor :body, :answers, :correct_answer

    def initialize(raw_text, raw_answers)
      @body = raw_text.chomp
      @answers = load_answers(raw_answers)
      @correct_answer = answers.key(raw_answers[0])
    end

    def display_answers
      @answers.map do |key, value|
        "#{key}. #{value}"
      end
    end

    def to_s
      @body
    end

    def to_h
      {
        body: @body,
        correct_answer: @correct_answer,
        answers: @answers
      }
    end

    def to_json
      JSON.generate(to_h)
    end

    def to_yaml
      YAML.dump(to_h)
    end

    def load_answers(raw_answers)
      shuffled_answers = raw_answers.shuffle
      keys = ('A'..'Z').to_a[0, shuffled_answers.length]
      Hash[keys.zip(shuffled_answers)]
    end

    def find_answer_by_char(char)
      @answers[char]
    end
  end
end
