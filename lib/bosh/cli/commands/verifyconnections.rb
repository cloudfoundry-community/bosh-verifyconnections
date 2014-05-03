module Bosh::Cli::Command
  # Performs job interconnection verifications upon the target deployment
  # 1. Show jobs with static IPs that aren't referenced elsewhere in the deployment properties
  # 2. Show IPs in the deployment properties that aren't specified as static IPs by jobs
  # 3. What .*bosh hostnames are specified but don't map to a job
  # 4. What external hostnames (e.g. .com) are referenced but do not resolve (via dig for example)
  #    to a static IP of a job
  class VerifyConnections < Base
    include Bosh::Cli::Validation

    usage "verify connections"
    desc "Performs job interconnection verifications upon the target deployment"
    def verify_connections
      show_deployment
      require "pp"
      pp jobs_and_indexes
      pp deployment
    end
  end
end
