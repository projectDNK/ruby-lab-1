module QuizName
  class InputReader
    def read(welcome_message: nil, validator: nil, error_message: nil, process: nil)
      puts welcome_message if welcome_message
      input = gets.chomp
      input = process.call(input) if process
      while validator && !validator.call(input)
        puts error_message if error_message
        input = gets.chomp
        input = process.call(input) if process
      end
      input
    end
  end
end
