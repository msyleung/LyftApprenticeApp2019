require 'sinatra'
require 'json'

# It only needs to accept a POST request to the route “/test” which accepts one argument “string_to_cut”
# returns a JSON object with the key “return_string” and a string containing every third letter from the original string.
#
# E.g. if you POST {"string_to_cut": "iamyourlyftdriver"}, it will return: {"return_string": "muydv"}.]
#
# To see expected behavior you can test against a current working example with the command:
#
# curl -X POST https://lyft-interview-test.herokuapp.com/test --data '{"string_to_cut": "iamyourlyftdriver"}' -H 'Content-Type: application/json'

helpers do
	def base_url
		@base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
	end

	def params
		begin
			JSON.parse(request.body.read)
		rescue
			halt 400, { message:'Invalid param' }.to_json
		end
	end
end

def as_json(string)
	 data = {
		 "return_string": string
	 }
	 data
 end

def split_string(string_to_cut)
	res = ""
	string_to_cut.chars.each_with_index do |chr, index|
		indexplusone = index + 1
		if indexplusone % 3 == 0
			res += chr
		end
	end
	res
end

post '/test' do
	# in case of no string
	content_type :json
	string = params['string_to_cut']
	if !string.empty?
		{ :return_string => split_string(string) }.to_json
	end
end
