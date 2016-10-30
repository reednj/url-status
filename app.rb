#
# Get the status of a list of web pages
# Nathan Reed, 2016-10-28 
#

require 'rest-client'
require 'colorize'
require 'yaml'
require 'trollop'

class App
    def main
        url_list.each do |url|
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

    def url_list
        opts = Trollop::options do
			version "url-status (c) 2016 @reednj (reednj@gmail.com)"
			opt :config, "YAML config file containing array of urls", :type => :string
		end

        if ARGV.empty?
            begin
                data_file_name = opts[:config] || "#{ENV['HOME']}/sites.yaml"
                YAML.load_file(data_file_name)
            rescue => e
                puts "Could not open '#{data_file_name}' (#{e})"
                exit(false)
            end
        else
            ARGV.clone
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

