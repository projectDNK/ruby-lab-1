require_relative 'statistics'
require_relative 'input_reader'
require_relative 'file_writer'
require_relative 'question_data'
require_relative "config"


module QuizName
  class Engine
    def initialize
      @question_collection = QuizName::QuestionData.new(QuizName::Config.yaml_dir, QuizName::Config.in_ext)
      @input_reader = QuizName::InputReader.new
      user_name = @input_reader.read(
        welcome_message: 'Please enter your name:',
        validator: ->(answer) { !answer.empty? },
        error_message: "Empty name. Please enter your name."
      )
      current_time = Time.now.strftime('%d.%m.%Y %H:%M:%S')
      @writer = QuizName::FileWriter.new('a', QuizName::Config.answers_dir, user_name + "_" + current_time.to_s)
      @statistics = QuizName::Statistics.new(@writer)
    end

    def run
      welcome_message = "Hello and welcome to the Quiz!\n\n"\
                      "You will be asked a series of questions and will have to choose"\
                      "the correct answer from the list provided.\n\n"\
                      "Let's get started!\n\n"
      @input_reader.read(welcome_message: welcome_message)
      puts @question_collection.class
      @question_collection.collection.each do |question|
        puts "\n#{question.body}"
        puts "Possible answers:"
        puts question.display_answers
        @writer.write("#{question.body}\nPossible answers:\n#{question.display_answers}\n")
        user_answer = get_answer_by_char(question)
        @writer.write("#{user_answer}\n")
        check(user_answer, question.correct_answer)
      end
      @statistics.print_report
    end

    def check(user_answer, correct_answer)
      if user_answer == correct_answer
        puts "That's correct!"
        @writer.write("That's correct!\n\n")
        @statistics.correct_answer
      else
        puts "I'm sorry, that's incorrect."
        @writer.write("I'm sorry, that's incorrect.\n\n")
        @statistics.incorrect_answer
      end
    end

    def get_answer_by_char(question)
      @input_reader.read(
        welcome_message: "Your answer (Enter the letter corresponding to your choice):",
        validator: ->(answer) { !answer.empty? && answer.length == 1 && question.answers.keys.include?(answer.upcase) },
        error_message: "Invalid answer. Please enter a valid letter."
      ).upcase
    end
  end
end
