class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true

  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  def results
    answer_choice_count = Hash.new (0)

    query = self.answer_choices
    .select("answer_choices.*, COUNT(responses.id) AS num_responses")
    .joins("LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id")
    .where("answer_choices.question_id = ?", self.id)
    .group("answer_choices.id")

    query.each do |answer|
      answer_choice_count[answer.text] = answer.num_responses
    end

    answer_choice_count

  end

  def results2
    answer_choice_count = Hash.new (0)

    query = AnswerChoice.find_by_sql([<<-SQL, self.id])
        SELECT
          answer_choices.*, COUNT(responses.id) AS num_responses
        FROM
          answer_choices
        LEFT OUTER JOIN
          responses
        ON
          answer_choices.id = responses.answer_choice_id
        WHERE
          answer_choices.question_id = ?
        GROUP BY
          answer_choices.id
    SQL

    query.each do |answer|
      answer_choice_count[answer.text] = answer.num_responses
    end

    answer_choice_count
  end

end
