require_relative '../../lib/glimmer-cw-video'

include Glimmer

video_file = File.expand_path('../videos/Ants.mp4', __FILE__)

def display_video_status(video, status)
  message_box {
    text status
    message "#{video.position.round(2)}/#{video.duration.round(2)} seconds have elapsed."
  }.open
end

@shell = shell {
  text 'Hello, Video Observers!'
  minimum_size 800, 500

  @video = video(file: video_file, background: :black) {
    on_swt_show { |event|
      # set focus as soon as the SWT widget is shown to grab keyboard events below
      @video.set_focus
    }
    
    on_key_pressed { |event|
      case event.keyCode
      when swt(:space), swt(:cr)
        @video.toggle
      when swt(:arrow_left)
        @video.rewind
      when swt(:arrow_right)
        @video.fast_forward
      when swt(:arrow_up)
        @video.volume_up
      when swt(:arrow_down)
        @video.volume_down
      end
    }   
    
    on_playing {
      display_video_status(@video, 'Playing')
    }
    
    on_paused {
      display_video_status(@video, 'Paused')
    }
    
    on_ended {
      display_video_status(@video, 'Ended')
    }
  }
}
@shell.open
