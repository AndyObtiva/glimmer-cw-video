require_relative '../../lib/glimmer-cw-video'

include Glimmer

video_file = File.expand_path('../videos/Blackpool_Timelapse.mp4', __FILE__)

shell {
  text 'Hello, Looped Video with Black Background!'
  minimum_size 1024, 640

  video(file: video_file, looped: true, background: :black)
}.open
