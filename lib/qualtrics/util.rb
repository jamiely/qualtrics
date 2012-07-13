require 'json'

module Qualtrics
  module Util
    def json_result(response)
      obj = JSON.parse response
      symbolize_keys! obj['Result']
    end
    # File activesupport/lib/active_support/core_ext/hash/keys.rb, line 23
    def symbolize_keys!(hash)
      hash.keys.each do |key|
        new_key = underscore key.to_s
        hash[(new_key.to_sym rescue key) || key] = hash.delete(key)
      end
      hash
    end

    def camel_case_keys!(hash)
      hash.keys.each do |key|
        new_key = camel_case key.to_s
        hash[(new_key rescue key) || key] = hash.delete(key)
      end
      hash
    end

    #http://stackoverflow.com/questions/1509915/converting-camel-case-to-underscore-case-in-ruby
    def underscore(str)
      str.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def camel_case(str)
      return str if str !~ /_/ && str =~ /[A-Z]+.*/
      str.split('_').map{|e| e.capitalize}.join
    end

  end
end

