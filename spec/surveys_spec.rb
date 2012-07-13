describe "a survey" do
  before(:each) do
    @settings = YAML.load_file File.join(File.dirname(__FILE__), 'qualtrics.yml')
    @client = Qualtrics.config host: @settings['host'],
      user: @settings['user'], token: @settings['token']
    @client = Qualtrics.client
  end

  it "gets a list of survey hashes" do
    surveys = @client.get_surveys_raw
    surveys.should_not be_empty
    surveys.first.class.should be Hash
  end

  it "gets a list of survey objects" do
    surveys = @client.get_surveys
    surveys.should_not be_empty
    surveys.first.class.should be Qualtrics::Survey
    surveys.first.id.should_not be nil
    surveys.first.id.should_not be_empty
  end

  describe "loaded from Qualtrics" do
    before :each do
      @survey_id = @settings['survey_id']
      @survey = @client.get_survey @survey_id
    end
    it "has a response count" do
      @survey.response_count.should be(2)
    end

    it "has an id" do
      @survey.id.should be(@survey_id)
    end
  end

  describe "with an example hash" do
    before :each do
      @example = {"survey_id" => "SV_X", "survey_type" => "Cool"}
    end

    def check_properties
      @new_survey.survey_id.should eq "SV_X"
      @new_survey.survey_type.should eq "Cool"
    end

    it "can be loaded from a hash" do
      @new_survey = Qualtrics::Survey.from_hash @example

      check_properties
    end

    it "can be loaded from json" do
      @new_survey = Qualtrics::Survey.from_json(@example.to_json)

      check_properties
    end
  end
end

