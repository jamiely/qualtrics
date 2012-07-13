describe "a survey" do
  before(:each) do
    settings = YAML.load_file File.join(File.dirname(__FILE__), 'qualtrics.yml')
    client = Qualtrics::Client.new host: settings['host'],
      user: settings['user'], token: settings['token']
    @survey_id = settings['survey_id']
    @survey = client.get_survey @survey_id
  end

  it "has a response count" do
    @survey.response_count.should be(2)
  end

  it "has an id" do
    @survey.id.should be(@survey_id)
  end
end

