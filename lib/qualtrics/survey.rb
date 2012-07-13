require 'time'
require 'representable'
require 'representable/json'

module Qualtrics
  class Survey
    include Util
    include Representable
    include Representable::JSON

    attr_accessor :id, :responses, :survey_type, :survey_name, :survey_description, :survey_owner_id, :survey_status, :survey_creation_date, :creator_id, :last_modified, :user_first_name, :user_last_name
    alias_method :survey_id=, :id=
    alias_method :survey_id, :id

    property :id
    property :responses
    property :survey_type
    property :survey_id
    property :survey_name
    property :survey_description
    property :survey_owner_id
    property :survey_status
    property :survey_creation_date
    property :creator_id
    property :last_modified
    property :user_first_name
    property :user_last_name


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

    #def self.from_hash(props)
      #s = Survey.new
      #props.each do | k, v |
        #s.send(k.to_s + '=', v)
      #end
      #s
    #end

    private
    def get(request, options= {})
      params = {
        'SurveyID' => id,
        'Format' => 'JSON'
      }.merge(options)
      Qualtrics.client.get request, params
    end
  end
end

