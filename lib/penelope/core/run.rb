module Penelope
  module Core
    module Run
      @queue = :job_run

      def self.perform(id)
        job = Core::Job.get(id)
        job.perform
      end
    end
  end
end
