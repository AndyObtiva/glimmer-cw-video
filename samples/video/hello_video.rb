require_relative '../../lib/glimmer-cw-video'

include Glimmer

video_file = File.expand_path('../videos/Clouds_passing_by_CCBY_NatureClip.mp4', __FILE__)

shell {
  text 'Hello, Video!'
  minimum_size 384, 240
  
  video(file: video_file)
}.open
