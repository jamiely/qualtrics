require 'rest_client'

module Qualtrics
  def self.config(options)
    @config = options
  end
  def self.client
    @client = Client.new @config if @client.nil?
    @client
  end
  class Client
    attr_accessor :host, :user, :token

    include Util

    def initialize(options)
      %w{host user token}.each do |var_name|
        instance_variable_set '@'+var_name, options[var_name.to_sym] || ""
      end
    end
    def get(request, options = {})
      url = "https://#{@host}/WRAPI/ControlPanel/api.php"
      params = {
        'Request' => request,
        'User' => @user,
        'Token' => @token,
        'Format' => 'XML' || options[:format],
        'Version' => '2.0'
      }.merge(options)
      RestClient.get url, params: params
    end
    def get_survey(survey_id)
      s = Survey.new
      s.id = survey_id
      s
    end
    def get_surveys_raw
      response = get 'getSurveys', 'Format' => 'JSON'
      surveys = (json_result response)[:surveys]
      surveys.collect do |s|
        new_hash = symbolize_keys! s
      end
    end
    def get_surveys
      raw = get_surveys_raw
      raw.collect do |s|
        s.each do |k, v|
          s[k.to_s] = v
        end
        Survey.from_hash s
      end
    end
  end
end

