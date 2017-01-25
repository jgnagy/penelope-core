module Penelope
  module Core
    class Job
      include DataMapper::Resource

      property :id, Serial
      property :type, Discriminator, required: true, index: true
      property :uri, String,  required: true
      property :entry_point, String, required: true
      property :submitted_by, String, required: true, index: true

      property :created_at, DateTime, index: true

      has 1, :job_report

      def cleanup
        # TODO archive working directory
        FileUtils.rm_rf working_directory
      end

      def perform
        @start_time = Time.now
        begin
          prepare
          retrieve
          run
        rescue Exception => e
          @exceptions ||= []
          @exceptions << e.message
        end
        @end_time = Time.now
        report
        cleanup
      end

      def prepare
        FileUtils.mkdir_p working_directory
      end

      def retrieve
        raise 'Not Implemented'
      end

      def run
        @exceptions = nil
        # TODO wrap in Docker container
        begin
          FileUtils.cd(working_directory) do
            @result = IO.popen(entry_point).read
          end
          @exit_status = $?.exitstatus
          @pid = $?.pid
        rescue Exception => e
          @exit_status ||= -1
          @pid ||= -1
          @exceptions ||= []
          @exceptions << e.message
        end
        @ran = true
      end

      def report
        jr = JobReport.new(
          pid: @pid,
          exit_status: @exit_status,
          start_time: @start_time,
          end_time: @end_time,
          result: @result,
          job_id: id
        )
        jr.exceptions = @exceptions.to_yaml if @exceptions
        jr.save
      end

      def working_directory
        File.join(CONFIG[:data][:directory], self.class.name, id.to_s)
      end
    end
  end
end
