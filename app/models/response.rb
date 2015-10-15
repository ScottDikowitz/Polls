class Response < ActiveRecord::Base
  validates :answer_choice_id, :user_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_cant_respond_to_own_poll

  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  belongs_to(
    :respondant,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  def sibling_responses
    self.id.nil? ? question.responses : question.responses.where.not('responses.id = ?', self.id)
  end


  def respondent_has_not_already_answered_question
    unless sibling_responses.where('user_id = ?', self.user_id).empty?
      errors[:message] << "already recorded response"
    end
  end

  def author_cant_respond_to_own_poll
    auth_id = question.poll.author_id
    if auth_id == user_id
      errors[:message] << "author can't respond to own poll"
    end
  end
end
