module ProcessTestHelper
  class GroveProcess
    @@counter = 0
    def initialize(file_content)
      @filename = "#{dir}/testfile-#{@@counter += 1}.rb"
      File.open(@filename, 'w') do |f|
        f.write <<-TESTFILE
          require 'lib/grove'
          #{file_content}
        TESTFILE
      end
    end
    def dir
      File.expand_path(File.dirname(__FILE__) + "/..")
    end
    def run
      Dir.chdir(dir)
      pipe = IO.popen("ruby #{@filename} 2>&1")
      @pid = pipe.pid
      @output = pipe.read
    end
    attr_reader :output
    def kill
      Process.kill("HUP", @pid)
    end
    def cleanup
      kill
      File.delete(@filename)
    end
  end

  def process code
    p = GroveProcess.new(code)
    @processes << p
    p.run
  end

  def server_process code
    Thread.new {
      process code
    }
  end

  def client_process code
    p = GroveProcess.new(code)
    @processes << p

    t0 = Time.now
    loop do
      p.run
      if p.output.include?('#<Errno::ECONNREFUSED: Connection refused - connect(2)> (DRb::DRbConnError)')
        puts "- isclude"
        if Time.now - t0 > 3
          break
        end
        sleep 0.1
      else
        break
      end
    end
  end

  attr_reader :processes

  def setup
    @processes = []
  end

  def teardown
    @processes.each(&:cleanup)
  end

end

