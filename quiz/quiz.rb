require 'singleton'

module QuizName
  require 'singleton'

  module QuizName
    class Quiz
      include Singleton

      attr_accessor :yaml_dir, :in_ext, :answers_dir

      def initialize
        @yaml_dir = ''
        @in_ext = ''
        @answers_dir = ''
      end

      def config(&block)
        yield self
      end
    end
  end
end
