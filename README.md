# Random Disqus Comment

This application gets a random comment from a disqus thread. It uses ruby for back-end requests, so you need to create a Disqus application (which is also needed if your accessing private data (user emails, user locations, etc).

## Deployment


The project comes with a Dockerfile for deploying the application using Nginx and passenger.

Change this line
```
thread = Thread.new('archdailycom', params[:url])
```

With your forumid


Then using docker (or boot2docker if you're on Mac OS X)

```
docker build -t drc .
docker run --name drc -p 80:80 -e API_SECRET=YOURAPISECRET -e API_KEY=YOURAPIKEY -e ACCESS_TOKEN=YOURACCESSTOKEN -d drc
```

Visit your container ip.
