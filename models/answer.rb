# frozen_string_literal: true

# Answers per question for user
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [:question_id]
end
