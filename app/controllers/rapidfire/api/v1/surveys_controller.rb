module Rapidfire
  module Api
    module V1
      class SurveysController < Rapidfire::ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :find_survey!, only: [:destroy, :show, :update, :attempts, :show_attempt]

        def index
          @surveys = Rapidfire::Survey.all
          render json: @surveys
        end

        def show
          render json: @survey
        end

        def create
          @survey = Rapidfire::Survey.new(survey_params)

          if @survey.save
            render json: @survey, status: :created
          else
            render json: { errors: @survey.errors }, status: :unprocessable_entity
          end
        end

        def update
          if @survey.update(survey_params)
            render json: @survey
          else
            render json: { errors: @survey.errors }, status: :unprocessable_entity
          end
        end

        def destroy
          if @survey.destroy
            render json: { message: "Survey deleted successfully" }, status: :ok
          else
            render json: { errors: @survey.errors }, status: :unprocessable_entity
          end
        end

        def attempts
          @attempts = @survey.attempts.collect do |attempt|
            {
              id: attempt.id,
              user_id: attempt.user_id,
              user_type: attempt.user_type,
              created_at: attempt.created_at,
              answers: attempt.answers.map do |answer|
                {
                  question: answer.question.question_text,
                  answer: answer.answer_text,
                }
              end,
            }
          end

          render json: @attempts
        end

        def show_attempt
          begin
            attempt = @survey.attempts.find(params[:attempt_id])
            result = {
              id: attempt.id,
              user_id: attempt.user_id,
              user_type: attempt.user_type,
              created_at: attempt.created_at,
              answers: attempt.answers.includes(:question).map do |answer|
                {
                  question: answer.question.question_text,
                  answer: answer.answer_text,
                }
              end,
            }

            render json: result
          rescue ActiveRecord::RecordNotFound => e
            render json: {
              error: "Attempt #{params[:attempt_id]} not found for Survey #{@survey.id}",
              available_attempts: @survey.attempts.pluck(:id),
            }, status: :not_found
          end
        end

        private

        def survey_params
          params.require(:survey).permit(:name, :introduction, :after_survey_content)
        end

        def find_survey!
          @survey = Rapidfire::Survey.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Survey #{params[:id]} not found" }, status: :not_found
        end
      end
    end
  end
end
