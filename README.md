# Random Disqus Comment

This application gets a random comment from a disqus thread. It uses ruby for back-end requests, so you need to create a Disqus application (which is also needed if your accessing private data (user emails, user locations, etc).

##Requirements
- Ruby
- Bundler

##Instructions:

- Find the forum id of your disqus application (AKA [shortname](https://help.disqus.com/customer/portal/articles/466208-what-s-a-shortname-))
- Create a .env file in the root of the project with the following vars:

```
API_SECRET=YOURAPISECRETKEY
API_KEY=YOURAPIKEY
ACCESS_TOKEN=YOURAPIACCESSTOKEN
```
- In the project root, run bundle:

```
bundle install --path vendor/bundle
```

- Start the server with
```
rackup
```

Go to localhost:9292 and you'll see a simple form for the forumid and the URL that contains the disqus thread. Submit the form and the winner's data will be displayed.
