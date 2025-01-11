module Rapidfire
  class SurveySerializer < ActiveModel::Serializer
    attributes :id, :name, :introduction, :after_survey_content, :active, :created_at, :updated_at
    has_many :questions
  end
end
