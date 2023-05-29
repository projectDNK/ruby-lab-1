module QuizName
  class Statistics
    def initialize(writer)
      @correct_answers = 0
      @incorrect_answers = 0
      @writer = writer
    end

    def correct_answer
      @correct_answers += 1
    end

    def incorrect_answer
      @incorrect_answers += 1
    end

    def print_report
      total_answers = @correct_answers + @incorrect_answers
      percentage_correct = (@correct_answers.to_f / total_answers) * 100

      report = "\nTotal questions: #{total_answers}\n" \
             "Correct answers: #{@correct_answers}\n" \
             "Incorrect answers: #{@incorrect_answers}\n" \
             "Percentage correct: #{'%.2f' % percentage_correct}%\n"
      # puts report
      # @writer.write(report)
    end
  end
end
