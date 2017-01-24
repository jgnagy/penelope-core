module Penelope
  module Core
    class GitJob < Job
      def retrieve
        RJGit::RubyGit.clone uri, working_directory
      end
    end
  end
end
