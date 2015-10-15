class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many(
    :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id
  )
  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id

  )


  def completed_polls
    # returns polls where the user has answered all the questions

    number_of_questions = Poll.first.questions.length

    answered_questions = User.count_by_sql([<<-SQL, self.id])


        SELECT
          COUNT(c.id)
        FROM
          questions
        INNER JOIN
          answer_choices AS a
        ON
          questions.id = a.question_id
        INNER JOIN
          responses AS b
        ON
          a.id = b.answer_choice_id
        INNER JOIN
          users AS c
        ON
          c.id = b.user_id
        WHERE
          c.id = ?

    SQL

    return true if answered_questions == number_of_questions
    return false
  end
end
