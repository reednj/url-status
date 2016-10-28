#
# Get the status of a list of web pages
# Nathan Reed, 2016-10-28 
#

require 'rest-client'
require 'colorize'
require 'yaml'

class App
    def main
        data_file_name = 'sites.yaml' 
        YAML.load_file(data_file_name).each do |url|
            response = get_response(url)
            code = response.ok? ? response.code.to_s.green : response.code.to_s.red
            puts "[#{code}] #{url}"
        end
    end

    def get_response(url)
        begin
            result = RestClient.get(url)
        rescue RestClient::ExceptionWithResponse => e
            result = e.response
        end
    end
end

class RestClient::Response
    def ok?
        code == 200
    end
end

App.new.main

