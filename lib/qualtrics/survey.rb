require 'time'
require 'representable'
require 'representable/json'
require 'xml/libxml'

module Qualtrics
  class Survey
    include Util
    include Representable
    include Representable::JSON

    ATTRS = [:id, :responses, :survey_type, :survey_name, :survey_description, :survey_owner_id, :survey_status, :survey_creation_date, :creator_id, :last_modified, :user_first_name, :user_last_name]

    attr_accessor *ATTRS
    attr_reader :detail

    alias_method :survey_id=, :id=
    alias_method :survey_id, :id

    ATTRS.each do |a|
      property a
    end
    %w{survey_id response_counts response_count}.each do |p|
      property p.to_sym
    end

    # Retrieves the number of responses
    def response_counts!(start_date = Time.parse('2000-1-1'), end_date = Time.now.utc)
      time_fmt = '%Y-%m-%d'
      response = get 'getResponseCountsBySurvey', 'StartDate' => start_date.strftime(time_fmt), 
        'EndDate' => end_date.strftime(time_fmt)
      @response_counts = json_result(response)
    end

    def response_counts(*args)
      response_counts! *args if @response_counts.nil?
      @response_counts
    end

    def response_count!(*args)
      response_counts! *args
      @response_count = @response_counts.values.inject(0) { | sum, v | sum += v }
    end

    def response_count(*args)
      response_count! *args if @response_count.nil?
      @response_count 
    end

    # This method is deprecated by the Qualtrics API
    def legacy_responses(options = {})
      raise :InvalidFormat unless [:xml, :csv, :html].member? format.to_sym
      format = options[:format].to_s.upcase

      get 'getLegacyResponseData', 'Format' => format
    end

    def load!
      xml = get 'getSurvey', 'Format' => 'XML'
      hash = xml_to_hash xml
      @detail = symbolize_keys! hash['SurveyDefinition']
      ATTRS.each do |k|
        k = k.to_sym
        self.send(k.to_s + '=', @detail[k]) if @detail.has_key? k
      end
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

    # adapted from 
    # http://movesonrails.com/articles/2008/02/25/libxml-for-active-resource-2-0

    def xml_to_hash(xml, strict=true) 
      XML.default_load_external_dtd = false
      XML.default_pedantic_parser = strict
      result = XML::Parser.string(xml).parse 
      { result.root.name.to_s => xml_node_to_hash(result.root)} 
    end 

    def xml_node_to_hash(node) 
      # If we are at the root of the document, start the hash 
      if node.element? 
       if node.children? 
          result_hash = {} 

          node.each_child do |child| 
            result = xml_node_to_hash(child) 

            if child.nil? || child.name.nil?
            elsif child.name == "text"
              if !child.next? and !child.prev?
                return result
              end
            elsif result_hash[child.name.to_sym]
                if result_hash[child.name.to_sym].is_a?(Object::Array)
                  result_hash[child.name.to_sym] << result
                else
                  result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << result
                end
              else 
                result_hash[child.name.to_sym] = result
              end
            end

          return result_hash 
        else 
          return nil 
       end 
       else 
        return node.content.to_s 
      end 
    end
  end
end

