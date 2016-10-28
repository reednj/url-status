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
            begin
                response = get_response(url)
                code = response.ok? ? response.code.to_s.green : response.code.to_s.red
                final_url = response.request.url
                text = "[#{code}] #{final_url}"
                text += " (requested #{url})".yellow unless final_url.include?(url)
                puts text
            rescue StandardError => e
                puts "[#{"---".red}] #{url} (#{e.to_s.red})"
            end
        end
    end

    def get_response(url)
        url = 'http://' + url unless url.start_with? 'http'

        begin
            return RestClient.get(url)
        rescue RestClient::ExceptionWithResponse => e
            return e.response
        end
    end
end

class RestClient::Response
    def ok?
        code == 200
    end
end

App.new.main

