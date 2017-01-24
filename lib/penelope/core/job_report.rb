module Penelope
  module Core
    class JobReport
      include DataMapper::Resource

      property :id, Serial

      belongs_to :job

      property :exit_status, Integer, index: true
      property :pid, Integer
      property :start_time, DateTime, index: true
      property :end_time, DateTime, index: true
      property :result, Text, required: true
      property :exceptions, Text
    end
  end
end
