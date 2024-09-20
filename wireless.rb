require 'sinatra'
require 'sinatra/base'
require 'cr'

set :server, :puma

get '/' do
  halt erb(:index)
end

get '/conn' do
  if params[:name] && params[:password]
    name = params[:name]
    password = params[:password]

    passed = true
    cmd_inject_map = %w[| & > < >> << $( ) ` || &&]

    [name, password].each do |str|
      cmd_inject_map.each do |bad|
        if str.include?(bad)
          passed = false
          break
        end
      end
    end
    return 'Command injection detected!' unless passed

    if name.empty?
      'Wireless name is empty.'
    else
      content_type :txt

      cmd = if password.empty?
              "nmcli dev wifi connect #{name} 2>&1"
            else
              "nmcli dev wifi connect #{name} password #{password} 2>&1"
            end
      Cr.output(cmd)
    end
  end
end

on_start do
  puts '=============='
  puts '  Booting up'
  puts '=============='
end

on_stop do
  puts '================='
  puts '  Shutting down'
  puts '================='
end

__END__

@@ layout
<html>
  <head>
    <title>Connect wireless</title>
    <meta charset="utf-8" />
  </head>
  <body><%= yield %></body>
</html>

@@ index
<form action="/conn">
  <label for='name'>Wireless:</label>
  <input name="name" value="" />
  <br>
  <label for='password'>Password:</label>
  <input type="password" name="password" value="" />
  <br>
  <input type="submit" value="CONNECT" />
</form>
