require "core-ext/hash_to_dotted_notation"

module Bosh::Cli::Command
  # Performs job interconnection verifications upon the target deployment
  # 1. Show jobs with static IPs that aren't referenced elsewhere in the deployment properties
  # 2. Show IPs in the deployment properties that aren't specified as static IPs by jobs
  # 3. What .*bosh hostnames are specified but don't map to a job
  # 4. Hostnames that don't resolve to any IP
  class VerifyConnections < Base
    include Bosh::Cli::Validation
    include BoshExtensions

    usage "verify connections"
    desc "Performs job interconnection verifications upon the target deployment"
    def verify_connections
      require "bosh/verifyconnections"

      show_deployment
      director_model = Bosh::VerifyConnections::Director.new(director.get_status)
      deployment_model = Bosh::VerifyConnections::Deployment.new(deployment, director_model.domain_name)

      errors = false
      warnings = false

      items = deployment_model.unreferenced_static_ips_with_job_index
      if items.size > 0
        warnings = true
        nl
        say "Job static IPs that are not being referenced by any properties:".make_yellow
        view = table(items) do |t|
          t.headings = ["static ip", "job/index"]
          items.each { |item| t << item }
        end
        say(view)
      end

      items = deployment_model.property_static_ips_not_assigned_to_job
      if items.size > 0
        errors = true
        nl
        say "Properties referencing static IPs that do not belong to any job:".make_red
        view = table(items) do |t|
          t.headings = ["property", "static ip", "job name"]
          items.each { |item| t << item }
        end
        say(view)
      end

      items = deployment_model.property_hostnames_not_mapping_to_job
      if items.size > 0
        errors = true
        nl
        say "Internal hostnames not mapping to any job:".make_red
        view = table(items) do |t|
          t.headings = ["property", "hostname", "job name"]
          items.each { |item| t << item }
        end
        say(view)
      end

      nl
      err("Please review errors above") if errors
      warning("Please review warnings above") if warnings
    end
  end
end
