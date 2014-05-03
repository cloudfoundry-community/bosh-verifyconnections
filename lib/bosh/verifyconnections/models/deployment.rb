require "common/deep_copy"
require "core-ext/hash_deep_merge"

module Bosh::VerifyConnections
  class Deployment
    include BoshExtensions

    attr_reader :deployment, :jobs

    def initialize(deployment_file)
      parse_deployment_file(deployment_file)
    end

    def deployment_name
      @deployment["name"]
    end

    def hostnames_offered(suffix)
      jobs.inject([]) do |dns, job|
        dns.push(*job.hostnames_offered(deployment_name, suffix))
        dns
      end
    end

    def static_ips_assigned
      jobs.inject([]) do |ips, job|
        ips.push(*job.static_ips_assigned)
        ips
      end
    end

    def global_properties
      @deployment["properties"]
    end

    def all_properties
      properties = Bosh::Common::DeepCopy.copy(global_properties)
      jobs.each do |job|
        properties.deep_merge!(job.job_properties)
      end
      properties
    end

    private
    def parse_deployment_file(deployment_file)
      @deployment_file = deployment_file
      @deployment = load_yaml_file(@deployment_file)
      @jobs = @deployment["jobs"].map do |manifest_job|
        DeploymentJob.new(manifest_job)
      end
    end
  end
end
