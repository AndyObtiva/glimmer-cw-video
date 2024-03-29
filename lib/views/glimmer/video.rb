require 'glimmer/ui/custom_widget'

module Glimmer
  class Video
    include Glimmer::UI::CustomWidget
    include_package 'org.eclipse.swt.browser'

    options :file, :url
    option :autoplay, default: true
    option :controls, default: true
    option :looped, default: false
    option :background, default: :white
    option :fit_to_width, default: true
    option :fit_to_height, default: true
    option :offset_x, default: 0
    option :offset_y, default: 0

    alias autoplay? autoplay
    alias controls? controls
    alias looped? looped
    alias fit_to_width? fit_to_width
    alias fit_to_height? fit_to_height
    
    before_body {
      file_source = file
      raise "Video file does not exist: #{file_source}" if file_source && !file_source.start_with?('uri:classloader') && !File.exist?(File.expand_path(file_source))
    }
    
    body {
      browser(:no_scroll) {
        text html {
          head {
            style(id: "style") {
              css {
                body {
                  margin 0
                  padding 0
                  overflow :hidden
                }
              }
            }
            style(id: "style-body-background") {
              css {
                body {
                  pv 'background', browser_body_background
                }
              }
            }
            style(id: "style-body-offset-x") {
              css {
                body {
                  margin_left "#{browser_body_offset_x}px"
                }
              }
            }
            style(id: "style-body-offset-y") {
              css {
                body {
                  margin_top "#{browser_body_offset_y}px"
                }
              }
            }
          }
          body {
            video(browser_video_loop, browser_video_controls, browser_video_autoplay, id: 'video', src: source, width: browser_video_width, height: browser_video_height)
          }
        }
        on_completed {
          @completed = true
        }
      }
    }

    def source
      file_source = file
      if file_source
        if file_source.start_with?('uri:classloader')
          file_path = file_source.split(/\/\//).last
          file_name = File.basename(file_source)
          # supporting windows ENV['temp'] or mac/unix /tmp
          tmp_dir = ENV['temp'] ? File.expand_path(ENV['temp']) : '/tmp'
          tmp_dir += '/glimmer/lib/glimmer/ui/video'
          FileUtils.mkdir_p(tmp_dir)
          tmp_file = File.join(tmp_dir, file_name)
          file_content = File.binread(file_source) rescue File.binread(file_path)
          File.binwrite(tmp_file, file_content)
          "file://#{tmp_file}"
        else
          file_source = File.expand_path(file_source)
          "file://#{file_source}"
        end
      else
        url
      end
    end

    def file=(a_file)
      options[:file] = a_file
      set_video_source
    end

    def url=(a_url)
      options[:url] = a_url
      set_video_source
    end

    def play
      video_action('play')
    end

    def pause
      video_action('pause')
    end
    
    def toggle
      paused? ? play : pause
    end

    def reload
      video_action('load')
    end

    def paused?
      video_attribute('paused')
    end

    def playing?
      !paused?
    end

    def ended?
      video_attribute('ended')
    end

    # Video fully loaded and ready for playback
    def loaded?
      !!@completed
    end

    def position
      video_attribute('currentTime')
    end

    def position=(new_position)
      new_position = [new_position, 0].max
      new_position = [new_position, duration].min
      video_attribute_set('currentTime', new_position)
    end
    
    def fast_forward(seconds=15)
      self.position += seconds
    end

    def rewind(seconds=15)
      self.position -= seconds
    end

    def duration
      video_attribute('duration')
    end
    
    def volume
      video_attribute('volume')
    end

    def volume=(value)
      value = [value, 0].max
      value = [value, 1].min
      video_attribute_set('volume', value)
    end
    
    def volume_up(value=0.05)
      self.volume += value
    end

    def volume_down(value=0.05)
      self.volume -= value
    end
    
    def mute
      video_attribute_set('muted', true)
    end
    
    def unmute
      video_attribute_set('muted', false)
    end
    
    def muted?
      video_attribute('muted')
    end
    
    def toggle_muted
      muted? ? unmute : mute
    end

    def can_handle_observation_request?(observation_request)
      result = false
      observation_request = observation_request.to_s
      if observation_request.start_with?('on_')
        attribute = observation_request.sub(/^on_/, '')
        result = OBSERVED_ATTRIBUTE_TO_PROPERTY_MAPPING.keys.include?(attribute)
      end
      result || super
    end

    def handle_observation_request(observation_request, &block)
      observation_request = observation_request.to_s
      if observation_request.start_with?('on_')
        attribute = observation_request.sub(/^on_/, '')
        if attribute == 'loaded' && !@completed
          super('on_completed', &block)
        elsif OBSERVED_ATTRIBUTE_TO_PROPERTY_MAPPING.keys.include?(attribute)
          add_video_observer(block, OBSERVED_ATTRIBUTE_TO_PROPERTY_MAPPING[attribute])
        else
          super
        end
      end
    end
    
    private

    class VideoObserverBrowserFunction < BrowserFunction
      def initialize(video, observer_proc, attribute)
        @observer_proc = observer_proc
        @attribute = attribute
        name = self.class.generate_name(@attribute)
        super(video.swt_widget, name)
      end

      def function(arguments)
        @observer_proc.call
      rescue => e
        Glimmer::Config.logger&.error "#{e.message}\n#{e.backtrace.join("\n")}"
      ensure
        nil
      end

      private

      class << self
        def generate_name(attribute)
          "video#{attribute}#{generate_attribute_id(attribute)}"
        end

        def generate_attribute_id(attribute)
          attribute_max_ids[attribute] = attribute_max_id(attribute) + 1
        end

        def attribute_max_id(attribute)
          attribute_max_ids[attribute] ||= 0
        end

        def attribute_max_ids
          @attribute_max_ids ||= {}
        end
      end
    end

    OBSERVED_ATTRIBUTE_TO_PROPERTY_MAPPING = {
      'playing' => 'play',
      'paused' => 'pause',
      'ended' => 'ended',
      'loaded' => 'canplay',
    }

    def set_video_source
      run_on_completed do
        video_attribute_set('src', source)
      end
    end

    def video_action(action)
      run_on_completed do
        swt_widget.execute("document.getElementById('video').#{action}()")
      end
    end

    def video_attribute(attribute)
      swt_widget.evaluate("return document.getElementById('video').#{attribute}") if @completed
    end

    def video_attribute_set(attribute, value)
      value = "'#{value}'" if value.is_a?(String) || value.is_a?(Symbol)
      run_on_completed do
        swt_widget.execute("document.getElementById('video').#{attribute} = #{value}")
      end
    end

    def add_video_observer(observer_proc, attribute)
      run_on_completed do
        video_observer_browser_function = VideoObserverBrowserFunction.new(self, observer_proc, attribute)
        swt_widget.execute("document.getElementById('video').addEventListener('#{attribute}', function() {#{video_observer_browser_function.getName}()})")
      end
    end

    def run_on_completed(&block)
      if @completed
        block.call
      else
        on_completed(&block)
      end
    end

    def browser_video_autoplay
      'autoplay' if autoplay?
    end

    def browser_video_controls
      'controls' if controls?
    end

    def browser_video_loop
      'loop' if looped?
    end

    def browser_video_width
      "100%" if fit_to_width
    end

    def browser_video_height
      "100%" if fit_to_height
    end

    def browser_body_background
      color = background
      if color.is_a?(Symbol) || color.is_a?(String)
        color = color(color)
      end
      if color.respond_to?(:swt_color)
        color = color.swt_color
      end
      "rgba(#{color.getRed}, #{color.getGreen}, #{color.getBlue}, #{color.getAlpha})"
    end

    def browser_body_offset_x
      offset_x
    end

    def browser_body_offset_y
      offset_y
    end
  end
end
