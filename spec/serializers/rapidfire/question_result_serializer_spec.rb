require "spec_helper"

describe Rapidfire::QuestionResultSerializer do
  include Rapidfire::QuestionSpecHelper
  include Rapidfire::AnswerSpecHelper

  let(:survey) { FactoryBot.create(:survey) }
  let(:results) do
    Rapidfire::SurveyResults.new(survey: survey).extract
  end

  before do
    create_questions(survey)
    create_answers
  end

  describe "#to_json" do
    let(:aggregatable_result) do
      results.select { |r| r.question.is_a?(Rapidfire::Questions::Radio) }.first
    end

    let(:source) do
      described_class.new(aggregatable_result)
    end

    let(:json_data) do
      ActiveSupport::JSON.decode(source.to_json)
    end

    it "has valid questions to work with" do
      expect(@question_radio.question_text).to_not be_empty
      expect(@question_radio.survey).to eql(survey)
      expect(survey.questions.to_a).to_not be_empty
    end

    it "has valid results to work with" do
      expect(results).to_not be_empty
    end

    it "generates json_data" do
      expect(source).not_to be_nil
      expect(source.to_json).not_to eql("null")
      expect(json_data).not_to be_nil
    end

    it "converts to with a hash of results" do
      expect(json_data["question_type"]).to eq "Rapidfire::Questions::Radio"
      expect(json_data["question_text"]).to eq aggregatable_result.question.question_text
      expect(json_data["results"]).not_to be_empty
      expect(json_data["results"]).to be_a Hash
    end

    context "when question cannot be aggregated" do
      let(:aggregatable_result) do
        results.select { |r| r.question.is_a?(Rapidfire::Questions::Short) }.first
      end

      it "returns an array of results" do
        expect(json_data["results"]).not_to be_empty
        expect(json_data["results"]).to be_a Array
      end
    end
  end
end
