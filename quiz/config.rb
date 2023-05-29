module QuizName
  module Config
    extend self

    attr_accessor :yaml_dir, :answers_dir, :in_ext, :token

    def config
      yield self
    end

    self.yaml_dir = "quiz/yml"
    self.answers_dir = "quiz/answers"
    self.in_ext = "yml"
    self.token = '6213138221:AAG_6rl2m_-mFur9VzSOtiBN245T58eNYAs'
  end
end
