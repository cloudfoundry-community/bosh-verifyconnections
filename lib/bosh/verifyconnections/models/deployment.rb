require "common/deep_copy"
require "core-ext/hash_deep_merge"
require "core-ext/hash_to_dotted_notation"

module Bosh::VerifyConnections
  class Deployment
    include BoshExtensions

    attr_reader :deployment, :jobs, :domain_name

    def initialize(deployment_file, domain_name)
      parse_deployment_file(deployment_file)
      @domain_name = domain_name
    end

    def deployment_name
      @deployment["name"]
    end

    def hostnames_offered
      jobs.inject([]) do |dns, job|
        dns.push(*job.hostnames_offered(deployment_name, domain_name))
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

    # @return Array [ip, job_index]
    def unreferenced_static_ips_with_job_index
      static_ips_with_job_index.reject do |ip, _|
        all_property_values.include?(ip)
      end
    end

    def all_properties_by_job
      @all_properties_by_job ||= begin
        all = { "global" => global_properties }
        jobs.each do |job|
          all[job.job_name] = job.job_properties
        end
        all
      end
    end

    def all_property_values
      @all_property_values ||=
        all_properties_by_job.values.map(&:to_dotted_hash).map(&:values).flatten
    end

    # @return Array [ip, job_name, property_name]
    def property_static_ips_not_assigned_to_job
      result = []
      all_properties_by_job.each do |job_name, properties|
        properties.to_dotted_hash.each do |key, value|
          result << [key, value, job_name] if invalid_static_ip?(value)
        end
      end
      result
    end

    # @return Array [hostname, job_name, property_name]
    def property_hostnames_not_mapping_to_job
      result = []
      all_properties_by_job.each do |job_name, properties|
        properties.to_dotted_hash.each do |key, value|
          result << [key, value, job_name] if invalid_internal_hostname?(value)
        end
      end
      result
    end

    def job(job_name)
      jobs.find { |job| job.job_name == job_name }
    end

    def job_and_global_properties(job_name)
      global_properties.deep_merge(job(job_name).job_properties)
    end

    def global_properties
      @deployment["properties"]
    end

    private
    def parse_deployment_file(deployment_file)
      @deployment_file = deployment_file
      @deployment = load_yaml_file(@deployment_file)
      @jobs = @deployment["jobs"].map do |manifest_job|
        DeploymentJob.new(manifest_job)
      end
    end

    def invalid_static_ip?(value)
      return false unless value.is_a? String
      parts = value.split(".")
      return false if parts.size != 4
      parts.each do |part|
        return false if part.to_i.to_s != part
      end
      return !static_ips_assigned.include?(value)
    end

    def invalid_internal_hostname?(value)
      return false unless value.is_a? String
      return false unless (value =~ /\.#{domain_name}$/)
      return !hostnames_offered.include?(value)
    end

  end
end
