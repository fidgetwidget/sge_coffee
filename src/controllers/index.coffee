Post = require '../models/post'

module.exports = 

  # Lists all posts
  index: (req, res) ->
    res.render 'index'
    # Post.find {}, (err, posts) ->
    #   res.render 'posts/index', { posts: posts }

