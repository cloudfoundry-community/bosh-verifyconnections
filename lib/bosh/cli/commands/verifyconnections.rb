module Bosh::Cli::Command
  # Performs job interconnection verifications upon the target deployment
  # 1. Show jobs with static IPs that aren't referenced elsewhere in the deployment properties
  # 2. Show IPs in the deployment properties that aren't specified as static IPs by jobs
  # 3. What .*bosh hostnames are specified but don't map to a job
  class VerifyConnections < Base
    include Bosh::Cli::Validation
    include BoshExtensions

    usage "verify connections"
    desc "Performs job interconnection verifications upon the target deployment"
    def verify_connections
      require "bosh/verifyconnections"

      show_deployment
      deployment_model = Bosh::VerifyConnections::Deployment.new(deployment)
      director_model = Bosh::VerifyConnections::Director.new(director.get_status)

      require "pp"

      header "Job static IPs that are not being referenced by any properties:"
      with_indent "  " do
        say "10.244.0.6 by cloud_controller_api_z1/0".make_yellow
        say "10.244.0.14 by cloud_controller_api_z1/1".make_yellow
      end

      header "Internal static IPs not assigned to any job:"
      with_indent "  " do
        say "10.244.0.10 by global property: ccdb.host".make_yellow
        say "10.244.0.10 by cloud_controller_api_z1 property: ccdb.host".make_yellow
      end

      header "Internal hostnames not mapping to any job:"
      with_indent "  " do
        say "0.ephemeral.cf1.job-with-static-ips-but-not-referenced.bosh by global property: ccdb.host".make_yellow
        say "0.ephemeral.cf1.job-with-static-ips-but-not-referenced.bosh by cloud_controller_api_z1 property: ccdb.host".make_yellow
      end

    end
  end
end
