# Video 0.1.0 - Glimmer Custom Widget

![Video Widget](images/glimmer-video-widget.png)

Glimmer custom widget for video used via `video` keyword.

## Pre-requisites

- [Glimmer](https://github.com/AndyObtiva/glimmer) application, [Glimmer](https://github.com/AndyObtiva/glimmer) custom shell, or another [Glimmer](https://github.com/AndyObtiva/glimmer) custom widget
- JRuby version required by Glimmer
- Java version required by Glimmer

## Setup

### Glimmer Application

Add the following to a Glimmer application `Gemfile`:

```ruby
gem 'glimmer-cw-video', '0.1.0'
```

Run:

```
jruby -S bundle
```

(or just `bundle` if using RVM)

### Glimmer Custom Shell or Glimmer Custom Widget

When reusing video custom widget in a Glimmer custom shell or custom widget, you can follow the same steps for Glimmer application, and then add a require statement to your library file after `glimmer` and before additional library require statements:

```ruby
require 'glimmer'
require 'glimmer-cw-video'
# ... more require statements follow
```

## Options 

Passed in an options hash as arguments to `video` widget:
- `autoplay` (true [default] or false): plays video automatically as soon as loaded
- `controls` (true [default] or false): displays controls
- `looped` (true or false [default]): plays video in looped mode
- `background` (Glimmer color [default: white]): sets background color just like with any other widget
- `fit_to_width` (true [default] or false): fits video width to widget allotted width regardless of video's original size. Maintains video aspect ratio.
- `fit_to_height` (true [default] or false): fits video height to widget allotted height regardless of video's original size. Maintains video aspect ratio.
- `offset_x` (integer [default: 0]): offset from left border. Could be a negative number if you want to show only an area of the video. Useful when fit_to_width is false to pick an area of the video to display.
- `offset_y` (integer [default: 0]): offset from top border. Could be a negative number if you want to show only an area of the video. Useful when fit_to_height is false to pick an area of the video to display.

## Methods

- `#play`: plays video
- `#pause`: pauses video
- `#reload`: reloads video restarting from beginning
- `#position`: position in seconds (and fractions)
- `#position=`: seeks a new position in video
- `#duration`: length of video, maximum video position possible
- `#loaded?`: returns true when video has been initially loaded or reloaded
- `#playing?`: returns true when video is actively playing
- `#paused?`: returns true when video is not playing
- `#ended?`: returns true when video has reached the end (position == duration)

## Observer Events:

- `on_loaded`: invoked when video `#loaded?` becomes true
- `on_ended`: invoked when video `#ended?` becomes true
- `on_playing`: invoked when video `#playing?` becomes true
- `on_paused`: invoked when video `#paused?` becomes true

## Examples:

Example ([samples/hello_video.rb](samples/video/hello_video.rb)):

```ruby
# ...
shell {
  video(file: video_file)
}.open
```

Example ([samples/hello_looped_video_with_black_background.rb](samples/video/hello_looped_video_with_black_background.rb)):

```ruby
# ...
shell {
  minimum_size 1024, 640
  video(file: video_file, looped: true, background: :black)
}.open
```

Example ([samples/hello_video_observers.rb](samples/video/hello_video_observers.rb)):

```ruby
# ...
def display_video_status(video, status)
  message_box = MessageBox.new(video.swt_widget.getShell)
  message_box.setText(status)
  message = "Video Position: #{video.position} seconds\n"
  message += "Video Duration: #{video.duration} seconds"
  message_box.setMessage(message)
  message_box.open
end

@shell = shell {
  minimum_size 800, 500
  @video = video(file: video_file, background: :black) {
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
```

## Contributing to glimmer-cw-video
 
- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
- Fork the project.
- Start a feature/bugfix branch.
- Commit and push until you are happy with your contribution.
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2020 Andy Maleh. See LICENSE.txt for
further details.
