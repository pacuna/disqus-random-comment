class App < Sinatra::Base

  DisqusApi.config = {api_secret: ENV['API_SECRET'],
                      api_key: ENV['API_KEY'],
                      access_token: ENV['ACCESS_TOKEN']}


  get '/' do
    if params[:forum] && params[:url]
      thread = Thread.new(params[:forum], params[:url])

      winner_index = rand(thread.posts_count)
      @winner_post = thread.posts[winner_index]
      response = Geocoder.search("#{@winner_post["approxLoc"]["lat"]},#{@winner_post["approxLoc"]["lng"]}")

      @formatted_address = response.first.data["formatted_address"] if response
    end

    haml :index, :format => :html5
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
