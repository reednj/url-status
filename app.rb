#
# Get the status of a list of web pages
# Nathan Reed, 2016-10-28 
#

require 'rest-client'
require 'colorize'

class App
    def main
        urls = [
            'http://reddit-stream.com/',
            'http://reddit-stream.com/error/raise'
        ]

        urls.each do |url|
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

