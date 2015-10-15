class CreateIndexestoForeignKeys < ActiveRecord::Migration
  def change
    create_table :indexesto_foreign_keys do |t|
      add_index :answer_choices, :question_id
      add_index :polls, :author_id
      add_index :questions, :poll_id
      add_index :responses, :answer_choice_id
      add_index :responses, :user_id
    end
  end
end
