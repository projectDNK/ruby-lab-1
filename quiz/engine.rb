require_relative 'statistics'
require_relative 'input_reader'
require_relative 'file_writer'
require_relative 'question_data'
require_relative "config"
require 'telegram/bot'


original_object = { 'A': 'some text', 'B': 'some text', 'C': 'some text', 'D': 'some text' }

transformed_object = original_object.keys.each_slice(2).map do |slice|
  slice.map { |key| { text: key.to_s } }
end

module QuizName
  class Engine
    def initialize
      @question_collection = QuizName::QuestionData.new(QuizName::Config.yaml_dir, QuizName::Config.in_ext)
      user_name = 'user'
      current_time = Time.now.strftime('%d.%m.%Y %H:%M:%S')
      @writer = QuizName::FileWriter.new('a', QuizName::Config.answers_dir, user_name + "_" + current_time.to_s)
      @statistics = QuizName::Statistics.new(@writer)
    end

    def run_bot
      Telegram::Bot::Client.run(QuizName::Config.token) do |bot|
        command = ''
        number_q = ''
        bot.listen do |message|
          command, parameter = message.text.split(' ', 2)
          case command
          when '/start'
            welcome_message = "Hello and welcome to the Quiz!\n\n"\
            "You will be asked a series of questions and will have to choose"\
            "the correct answer from the list provided.\n\n"\
            "Let's get started!\n\n"
            bot.api.send_message(chat_id: message.chat.id, text: welcome_message)
          when '/c'
            if (parameter.to_i <= @question_collection.collection.length) && (parameter.to_i >= 1)
              answers =
                Telegram::Bot::Types::ReplyKeyboardMarkup.new(
                  keyboard: [
                    [{ text: 'A' }, { text: 'B' }],
                    [{ text: 'C' }, { text: 'D' }]
                  ],
                  one_time_keyboard: true
                )
              number_q = parameter.to_i - 1
              bot.api.send_message(chat_id: message.chat.id, text: @question_collection.collection[number_q].body.to_s + "\n\n" + @question_collection.collection[number_q].display_answers.to_s, reply_markup: answers)
            else
              bot.api.send_message(chat_id: message.chat.id, text: "Please, provide question number with command")
            end
          when '/stop'
            bot.api.send_message(chat_id: message.chat.id, text: @statistics.print_report)
          else
            puts command
            puts parameter
            puts @question_collection.collection[number_q].correct_answer
            check(command, @question_collection.collection[number_q].correct_answer)
          end
        end
      end
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
