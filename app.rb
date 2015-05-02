class App < Sinatra::Base

  DisqusApi.config = {api_secret: ENV['API_SECRET'],
                      api_key: ENV['API_KEY'],
                      access_token: ENV['ACCESS_TOKEN']}

  Haml::Options.defaults[:format] = :html5

  DB = Sequel.connect('postgres://pacuna@localhost:5432/postgres')

  DB.create_table? :prizes do
    primary_key :id
    varchar :link
    varchar :name
    timestamp :created_at
    varchar :email
    varchar :location
    varchar :message
  end


  class Prize < Sequel::Model; end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  get '/' do
    if params[:url]
      thread = Thread.new('archdailycom', params[:url])
      winner_index = rand(thread.posts_count)
      @winner_post = thread.posts[winner_index]
      response = Geocoder.search("#{@winner_post["approxLoc"]["lat"]},#{@winner_post["approxLoc"]["lng"]}")
      @formatted_address = response.first.data["formatted_address"] if response
    end

    puts Prize.all.inspect
    haml :index, :format => :html5
  end

  post '/' do
    prizes = DB[:prizes]
    prizes.insert(link: params[:link], name: params[:name], created_at: params[:created_at], email: params[:email] , location: params[:location], message: params[:message])
    puts 'post enviado'
    redirect to('/')
  end

  class Thread

    def initialize(forum, url)
      @forum  = forum
      @url = url
    end

    def id
      thread = DisqusApi.v3.get('threads/list.json', forum: @forum, "thread:link" => @url)
      thread["response"][0]["id"].to_i
    end

    def posts
      DisqusApi.v3.posts.list(forum: @forum, thread: id.to_i).all
    end

    def posts_count
      posts.count
    end
  end

end
