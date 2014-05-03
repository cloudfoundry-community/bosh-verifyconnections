class Bosh::VerifyConnections::DeploymentJob
  class DnsInvalidCanonicalName < StandardError; end

  def initialize(job_from_manifest)
    @from_manifest = job_from_manifest
  end

  def job_name
    @from_manifest["name"]
  end

  def instances
    @from_manifest["instances"]
  end

  def networks
    @from_manifest["networks"]
  end

  def static_ips_assigned
    networks.inject([]) do |ips, network|
      if network["static_ips"]
        ips.push(*network["static_ips"])
      end
      ips
    end
  end

  def hostnames_offered(deployment_name, dns_suffix)
    deployment_name = dns_canonical(deployment_name)
    dns_suffix = dns_canonical(dns_suffix)
    job_name = dns_canonical(self.job_name)
    networks.inject([]) do |hostnames, network|
      network_name = dns_canonical(network["name"])
      0.upto(instances-1) do |n|
        hostnames << [n, job_name, network_name, deployment_name, dns_suffix].join(".")
      end
      hostnames
    end
  end

  def job_properties
    @from_manifest["properties"] || {}
  end

  private
    def dns_canonical(string)
      unless string
        raise DnsInvalidCanonicalName, "Must provide a string"
      end
      # a-z, 0-9, -, case insensitive, and must start with a letter
      string = string.downcase.gsub(/_/, "-").gsub(/[^a-z0-9-]/, "")
      if string =~ /^(\d|-)/
        raise DnsInvalidCanonicalName,
              "Invalid DNS canonical name `#{string}', must begin with a letter"
      end
      if string =~ /-$/
        raise DnsInvalidCanonicalName,
              "Invalid DNS canonical name `#{string}', can't end with a hyphen"
      end
      string
    end

end
