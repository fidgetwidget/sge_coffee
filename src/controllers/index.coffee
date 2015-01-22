Post = require '../models/post'

module.exports = 

  # Lists all posts
  index: (req, res) ->
    Post.find {}, (err, posts) ->
      res.render 'posts/index', { posts: posts }

