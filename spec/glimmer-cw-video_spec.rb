require 'spec_helper'

module GlimmerSpec
  describe "Glimmer Video" do
    include Glimmer

    before do
      @original_temp = ENV['temp']
      @target = shell {
        alpha 0 # keep invisible while running specs
      }
      @timeout = Thread.new {
        timeout_duration = 6
        sleep(timeout_duration)
        async_exec {
          @fail = "Time out after #{timeout_duration} seconds!"
          @target&.dispose
        }
      }
    end

    after do
      if @target && !@target.swt_widget.isDisposed
        @target.open
      end
      @timeout.kill
      ENV['temp'] = @original_temp
      fail(@fail) if @fail
    end

    let(:video_file) { File.join(FIXTURES_PATH, 'videos/Pepa-creativeCommonsMp4956_512kb.mp4') }
    let(:video_url) { "http://www.youtube.com/fdajiew" }
    let(:video_url_truncated) { "www.youtube.com/fdajiew" }

    it "initializes video source by file option argument (absolute path)" do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq("file://#{video_file}")
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq("file://#{video_file}")
    end

    it "initializes video source by file option argument (relative path)" do
      @target.content {
        @video = video(file: "spec/fixtures/videos/#{File.basename(video_file)}") {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq("file://#{video_file}")
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq("file://#{video_file}")
    end

    it "raises error if file does not exist" do
      @target.content {
        expect {
          @video = video(file: 'invalid') {
            on_completed {
              expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq("file://#{video_file}")
              @target.dispose
            }
          }
        }.to raise_error('Video file does not exist: invalid')
      }
      @target.dispose
    end

    it "initializes video source by url option argument" do
      @target.content {
        @video = video(url: video_url) {
          on_loaded {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq(video_url)
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq(video_url)
    end

    it 'initializes video source by uri:classloader file (JAR file path)' do
      expected_source = "file:///tmp/glimmer/lib/glimmer/ui/video/#{File.basename(video_file)}"
      @target.content {
        @video = video(file: "uri:classloader://#{video_file}") {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq(expected_source)
            expect(Dir['/tmp/glimmer/lib/glimmer/ui/video/*'].to_a.size).to be > 0
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq(expected_source)
    end

    it 'initializes video source by uri:classloader file (JAR file path) with ENV["temp"] set for windows' do
      ENV['temp'] = '/tmp/tmp'
      expected_source = "file:///tmp/tmp/glimmer/lib/glimmer/ui/video/#{File.basename(video_file)}"
      @target.content {
        @video = video(file: "uri:classloader://#{video_file}") {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq(expected_source)
            expect(Dir['/tmp/tmp/glimmer/lib/glimmer/ui/video/*'].to_a.size).to be > 0
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq(expected_source)
    end

    it "sets video source by file attribute" do
      @target.content {
        @video = video {
          file video_file
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq("file://#{video_file}")
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq("file://#{video_file}")
    end

    it "sets video source by url attribute" do
      @target.content {
        @video = video {
          url video_url
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq(video_url)
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq(video_url)
    end

    it 'sets video source by uri:classloader file attribute (JAR file path)' do
      expected_source = "file:///tmp/glimmer/lib/glimmer/ui/video/#{File.basename(video_file)}"
      @target.content {
        @video = video {
          file "uri:classloader://#{video_file}"
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq(expected_source)
            expect(Dir['/tmp/glimmer/lib/glimmer/ui/video/*'].to_a.size).to be > 0
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq(expected_source)
    end

    it 'sets video source by uri:classloader file (JAR file path) with ENV["temp"] set for windows' do
      ENV['temp'] = '/tmp/tmp'
      expected_source = "file:///tmp/tmp/glimmer/lib/glimmer/ui/video/#{File.basename(video_file)}"
      @target.content {
        @video = video {
          file "uri:classloader://#{video_file}"
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').src")).to eq(expected_source)
            expect(Dir['/tmp/tmp/glimmer/lib/glimmer/ui/video/*'].to_a.size).to be > 0
            @target.dispose
          }
        }
      }
      expect(@video.source).to eq(expected_source)
    end

    it "autoplays video by default" do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').autoplay")).to eq(true)
            @target.dispose
          }
        }
      }
      expect(@video.autoplay).to eq(true)
    end

    it "does not autoplay video when specified with autoplay option argument" do
      @target.content {
        @video = video(file: video_file, autoplay: false) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').autoplay")).to eq(false)
            @target.dispose
          }
        }
      }
    end

    it "displays video controls by default" do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').controls")).to eq(true)
            @target.dispose
          }
        }
      }
      expect(@video.controls).to eq(true)
    end

    it "does not display video controls when specified as an option argument" do
      @target.content {
        @video = video(file: video_file, controls: false) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').controls")).to eq(false)
            @target.dispose
          }
        }
      }
    end

    it "does not loop video by default" do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').loop")).to eq(false)
            @target.dispose
          }
        }
      }
      expect(@video.looped).to eq(false)
    end

    it "loops video when specified as an option argument" do
      @target.content {
        @video = video(file: video_file, looped: true) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').loop")).to eq(true)
            @target.dispose
          }
        }
      }
    end

    it 'sets background to white by default' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('style-body-background').innerHTML")).to include("rgba(255, 255, 255, 255)")
            @target.dispose
          }
        }
      }
      expect(@video.background).to eq(:white)
    end

    it 'sets background to black with option argument' do
      @target.content {
        @video = video(file: video_file, background: :black) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('style-body-background').innerHTML")).to include("rgba(0, 0, 0, 255)")
            @target.dispose
          }
        }
      }
    end

    it 'fits video to width by default' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').width")).to eq(100.0)
            @target.dispose
          }
        }
      }
      expect(@video.fit_to_width).to eq(true)
    end

    it 'does not fit video to width when specified with fit_to_width option argument' do
      @target.content {
        @video = video(file: video_file, fit_to_width: false) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').width")).to eq(0.0)
            @target.dispose
          }
        }
      }
    end

    it 'fits video to height by default' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').height")).to eq(100.0)
            @target.dispose
          }
        }
      }
      expect(@video.fit_to_height).to eq(true)
    end

    it 'does not fit video to height when specified with fit_to_height option argument' do
      @target.content {
        @video = video(file: video_file, fit_to_height: false) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('video').height")).to eq(0.0)
            @target.dispose
          }
        }
      }
    end

    it "plays/stops video manually" do
      @target.content {
        @video = video(file: video_file, autoplay: false) {
          on_completed {
            expect(@video.playing?).to eq(false)
            expect(@video.paused?).to eq(true)
            @video.play
            expect(@video.swt_widget.evaluate("return document.getElementById('video').paused")).to eq(false)
            expect(@video.playing?).to eq(true)
            expect(@video.paused?).to eq(false)
            @video.pause
            expect(@video.playing?).to eq(false)
            expect(@video.paused?).to eq(true)
            expect(@video.swt_widget.evaluate("return document.getElementById('video').paused")).to eq(true)
            @target.dispose
          }
        }
      }
    end
    
    it 'toggles video play/pause action manually' do
      @target.content {
        @video = video(file: video_file, autoplay: false) {
          on_completed {
            expect(@video.playing?).to eq(false)
            expect(@video.paused?).to eq(true)
            @video.toggle
            expect(@video.swt_widget.evaluate("return document.getElementById('video').paused")).to eq(false)
            expect(@video.playing?).to eq(true)
            expect(@video.paused?).to eq(false)
            @video.toggle
            expect(@video.playing?).to eq(false)
            expect(@video.paused?).to eq(true)
            expect(@video.swt_widget.evaluate("return document.getElementById('video').paused")).to eq(true)
            @target.dispose
          }
        }
      }
    end    

    it 'sets offset_x to 0 by default' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('style-body-offset-x').innerHTML")).to include("margin-left:0px")
            @target.dispose
          }
        }
      }
      expect(@video.offset_x).to eq(0)
    end

    it 'sets offset_x to value specified by offset_x option argument' do
      @target.content {
        @video = video(file: video_file, offset_x: -150) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('style-body-offset-x').innerHTML")).to include("margin-left:-150px")
            @target.dispose
          }
        }
      }
    end

    it 'sets offset_y to 0 by default' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('style-body-offset-y').innerHTML")).to include("margin-top:0px")
            @target.dispose
          }
        }
      }
      expect(@video.offset_y).to eq(0)
    end

    it 'sets offset_y to value specified by offset_y option argument' do
      @target.content {
        @video = video(file: video_file, offset_y: -150) {
          on_completed {
            expect(@video.swt_widget.evaluate("return document.getElementById('style-body-offset-y').innerHTML")).to include("margin-top:-150px")
            @target.dispose
          }
        }
      }
    end

    it 'listens to video loaded event' do
      @target.content {
        @video = video(file: video_file) {
          on_loaded {
            expect(@video.loaded?).to eq(true)
            @target.dispose
          }
        }
      }
      expect(@video.loaded?).to eq(false)
    end

    unless ENV['CI']
      it 'listens to video ended event and ensures position == duration at the end, then reloads' do
        @target.content {
          @video = video(file: video_file) {
            on_ended {
              expect(@video.ended?).to eq(true)
              expect(@video.position).to eq(@video.duration)
              @video.on_loaded {
                @target.dispose
              }
              @video.reload
            }
          }
        }
      end
    end

    it 'listens to video play event' do
      @target.content {
        @video = video(file: video_file, autoplay: false) {
          on_playing {
            expect(@video.playing?).to eq(true)
            @target.dispose
          }
          on_completed {
            @video.play
          }
        }
      }
    end

    unless ENV['CI']
      it 'listens to video pause event' do
        @target.content {
          @video = video(file: video_file) {
            on_paused {
              expect(@video.paused?).to eq(true)
              @target.dispose
            }
            on_completed {
              @video.pause
            }
          }
        }
      end
    end

    it 'changes position' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            @video.position = @video.duration
            expect(@video.ended?).to be(true)
            @video.position = -1
            expect(@video.position).to eq(0)
            @video.position = @video.duration + 1
            expect(@video.position).to eq(@video.duration)
            @target.dispose
          }
        }
      }
    end

    it 'rewinds and fast forwards' do
      @target.content {
        @video = video(file: video_file, autoplay: false) {
          on_completed {
              @video.fast_forward(0.01)
              expect(@video.position).to eq(0.01)
              @video.rewind(0.01)
              expect(@video.position).to eq(0)
              @target.dispose
          }
        }
      }
    end
    
    it 'changes volume' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            @video.volume = 0.5
            expect(@video.volume).to eq(0.5)
            @video.volume = -1
            expect(@video.volume).to eq(0)
            @video.volume = 1.1
            expect(@video.volume).to eq(1)
            @target.dispose
          }
        }
      }
    end

    it 'bumps volume up and volumne down' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            @video.volume = 1
            @video.volume_down(0.3)
            expect(@video.volume).to eq(0.7)
            @video.volume_up(0.3)
            expect(@video.volume).to eq(1)
            @target.dispose
          }
        }
      }
    end
    
    it 'mutes/unmutes video volume' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            @video.volume = 0.5
            expect(@video.muted?).to be_falsey
            @video.mute
            expect(@video.muted?).to eq(true)
            @video.unmute
            expect(@video.muted?).to be_falsey
            @target.dispose
          }
        }
      }
    end

    it 'toggles muted attribute' do
      @target.content {
        @video = video(file: video_file) {
          on_completed {
            expect(@video.muted?).to be_falsey
            @video.toggle_muted
            expect(@video.muted?).to eq(true)
            @video.toggle_muted
            expect(@video.muted?).to be_falsey
            @target.dispose
          }
        }
      }
    end

    xit 'starts video muted by default' do
#       @target.content {
#         @video = video(file: video_file, muted: true) {
#           on_completed {
#             expect(@video.muted?).to eq(true)
#             @target.dispose
#           }
#         }
#       }
    end

  end
  
end
