require "url_status/version"
require 'rest-client'
require 'colorize'
require 'yaml'
require 'trollop'

module RestClient::Response
	def ok?
		code == 200
	end
end

module UrlStatus

	class App
		def main
			success = true

			url_list.each do |url|
				begin
					response = get_response(url)
					success = success && response.ok?
					code = response.ok? ? response.code.to_s.green : response.code.to_s.red
					final_url = response.request.url
					
					text = "[#{code}] #{final_url}"
					text += " (requested #{url})".yellow unless final_url.include?(url)
					puts text					
				rescue StandardError => e
					success = false
					puts "[#{"---".red}] #{url} (#{e.to_s.red})"
				end

				STDOUT.flush
			end

			# unless *every* request completed properly, return an error code
			#, then we can do something else, like send an email
			exit(false) unless success
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
				raise e if e.response.nil?
				return e.response
			end
		end
	end

end
