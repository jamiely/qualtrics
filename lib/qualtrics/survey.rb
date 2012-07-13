require 'time'

module Qualtrics
  class Survey
    attr_reader :id

    include Util

    def initialize(client, survey_id)
      @client = client
      @id = survey_id 
    end

    def response_count(start_date = Time.parse('2000-1-1'), end_date = Time.now.utc)
      time_fmt = '%Y-%m-%d'
      response = get 'getResponseCountsBySurvey', 'StartDate' => start_date.strftime(time_fmt), 
        'EndDate' => end_date.strftime(time_fmt)
      responses = json_result(response)
      responses.values.inject(0) { | sum, v | sum += v }
    end

    # This method is deprecated by the Qualtrics API
    def legacy_responses(options = {})
      raise :InvalidFormat unless [:xml, :csv, :html].member? format.to_sym
      format = options[:format].to_s.upcase

      get 'getLegacyResponseData', 'Format' => format
    end

    private
    def get(request, options= {})
      params = {
        'SurveyID' => @id,
        'Format' => 'JSON'
      }.merge(options)
      @client.get request, params
    end
  end
end

