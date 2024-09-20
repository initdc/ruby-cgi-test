require 'sinatra/base'
require 'cr'

class Stream < Sinatra::Base
  get '/' do
    content_type :txt

    stream do |out|
      Cr.each_line("ping 1.0.0.1 -c 4") do |line|
        out << line
      end
    end
  end
end

run Stream
