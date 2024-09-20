require 'sinatra'
require 'cr'

get('/') do 
  content_type :txt

  Cr.output("uname") 
end
