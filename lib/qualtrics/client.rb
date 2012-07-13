require 'rest_client'

module Qualtrics
  class Client
    attr_accessor :host, :user, :token

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
      Survey.new self, survey_id
    end
  end
end

