require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'guard/notifier'

module Guard
  class Elixir < Guard
    def initialize(watchers=[], options={})
      super
      @options = {
        all_on_start: true,
        dry_run: false,
      }.update(options)
    end

    def start
      run_all if @options[:all_on_start]
    end

    def run_all
      files = Dir.glob("**/*.*")
      targets = Watcher.match_files(self, files)
      run_on_change targets
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      get_deps if paths.include? "mix.exs"

      if @options[:dry_run]
        paths.each { |path| UI.info "Dry run: #{path}" }
        return
      end

      total    = 0
      failures = 0
      duration = 0
      run_command("mix test #{paths.join(' ')}") do |line|
        puts line
        if /Finished in ([0-9.]+) seconds/.match(line)
          duration = Regexp::last_match[1]
        elsif /([0-9]+) tests, ([0-9]+) failures/.match(line)
          total = Regexp::last_match[1].to_i
          failures = Regexp::last_match[2].to_i
        end
      end

      Notifier.notify(
        guard_message(total, failures, duration),
        :title => "Elixir results",
        :image => guard_image(failures),
        :priority => guard_priority(failures)
      )
    end


    def get_deps
      if @options[:dry_run]
        UI.info "Dry run: deps.get, deps.compile"
        return
      end

      run_command("mix deps.get")
      run_command("mix deps.compile")
    end

    private

    def run_command(cmd)
      UI.debug "+ #{cmd}"
      IO.popen(cmd, :err => [:child, :out]).each do |line|
        if block_given?
          yield line
        else
          puts line
        end
      end
      Process.wait
      $?.success?
    end

    def guard_image(failures)
      if failures > 0
        :failed
      else
        :success
      end
    end

    def guard_priority(failures)
      if failures > 0
        2
      else
        -2
      end
    end

    def guard_message(total, failures, duration)
      "#{total} tests, #{failures} failures\nin #{duration} seconds"
    end

  end
end
