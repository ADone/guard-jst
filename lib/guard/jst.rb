require 'guard'
require 'guard/plugin'
require 'ejs'

module Guard
  class Jst < Plugin
    def initialize(options = {})
      super
      @options = { extnames: %w[jst ejs jst.ejs] }.merge options

      @output = Pathname.new @options[:output]
      @input  = Pathname.new @options[:input]
    end

    def start
      UI.info 'Guard::Jst is now watching for changes.'
      # Run all if the option is true.
      run_all if @options[:run_on_start]
    end

    # Compile all templates.
    def run_all
      paths = Dir.glob("#{@options[:input]}/**/*#{extnames}").select { |path| not File.directory? path }
      run_on_modifications paths
    end

    # Run when the guardfile changes.
    def run_on_changes(paths)
      run_on_modifications paths
    end

    def run_on_additions(paths)
      run_on_modifications paths
    end

    # Compile each template at the passed in paths.
    def run_on_modifications(paths = [])
      paths
        .select { |path| @options[:extnames].includes? path.scan(/\.(.+)/).flatten[0] }
        .map { |path| Pathname path }
        .uniq.each do |path|
          relative_path = path.relative_path_from @input

          UI.info "[JST] COMPILE: #{path}"

          File.open(@output.join(relative_path).tap { |target| target.dirname.mkpath }.to_s.sub(/\..+/, '.js'), 'w+') do |file|
            file.write <<-JS
(function() {
  this.JST || (this.JST = {});
  this.JST["#{relative_path.to_s.sub(/\..+/, '')}"] = #{EJS.compile path.read}
}).call(this)
          JS
          end
        end
    end

    def run_on_removals(paths)
      paths.each do |path|
        UI.info "[JST] REMOVE: #{path}"
        File.delete @output.join(Pathname.new(path).relative_path_from(@input)).to_s.sub(/\..+/, '.js')
      end
    end

    private

    def extnames
      "{#{@options[:extnames].map { |ext| ".#{ext}" }.join(',')}}"
    end
  end
end
