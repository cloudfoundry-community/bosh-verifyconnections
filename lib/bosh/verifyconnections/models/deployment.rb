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

    def static_ips_with_job_index
      jobs.inject([]) do |ips, job|
        job.static_ips_assigned.each_with_index do |ip, index|
          job_index = "#{job.job_name}/#{index}"
          ips << [ip, job_index]
        end
        ips
      end
    end

    # TODO reject if static_ip in properties
    # @return Array [ip, job_index]
    def unreferenced_static_ips_with_job_index
      static_ips_with_job_index
    end

    # @return Array [ip, job_name, property_name]
    def property_static_ips_not_assigned_to_job
      [
        ["10.244.1.10", "global", "ccdb.host"],
        ["10.244.1.10", "uaa_z1", "uaadb.host"],
      ]
    end

    # @return Array [hostname, job_name, property_name]
    def property_hostnames_not_mapping_to_job
      [
        ["0.ephemeral.cf1.job-with-static-ips-but-not-referenced.bosh", "global", "ccdb.host"],
        ["0.ephemeral.cf1.job-with-static-ips-but-not-referenced.bosh", "uaa_z1", "uaadb.host"],
      ]
    end

    def global_properties
      @deployment["properties"]
    end

    def job(job_name)
      jobs.find { |job| job.job_name == job_name }
    end

    def job_properties(job_name)
      global_properties.deep_merge(job(job_name).job_properties)
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
