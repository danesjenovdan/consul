require "rails_helper"

describe SpeechToTextController do
  let(:user) { create(:user) }
  let(:audio_file) { fixture_file_upload("clippy.jpg") }
  let(:response_double) { double(errors: [], text: "hello world", segments: []) }

  before do
    sign_in user
    allow(SpeechToText::Llm::Client).to receive(:call).and_return(response_double)
  end

  describe "POST create" do
    it "returns transcribed text on success" do
      post :create, params: { audio_file: audio_file }, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["text"]).to eq("hello world")
    end

    it "returns error when audio file is missing" do
      post :create, params: {}, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to eq("No audio submitted.")
    end

    it "returns error when audio file is too large" do
      allow_any_instance_of(ActionDispatch::Http::UploadedFile).to receive(:size).and_return(11.megabytes)

      post :create, params: { audio_file: audio_file }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to eq("Audio file is too large.")
    end

    it "returns processing errors from speech-to-text client" do
      allow(SpeechToText::Llm::Client).to receive(:call)
        .and_return(double(errors: ["Transcription failed"], text: "", segments: []))

      post :create, params: { audio_file: audio_file }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["errors"]).to eq("Transcription failed")
    end

    context "when rate limit is exceeded" do
      before { SpeechToTextController.cache_store.clear }

      it "returns too many requests error" do
        20.times { post :create, params: { audio_file: audio_file }, format: :json }

        post :create, params: { audio_file: audio_file }, format: :json

        expect(response).to have_http_status(:too_many_requests)
        expect(response.parsed_body["errors"]).to eq("Please wait a few minutes before dictating again.")
      end
    end
  end
end
