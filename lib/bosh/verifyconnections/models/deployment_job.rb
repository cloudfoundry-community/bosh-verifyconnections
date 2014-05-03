class Bosh::VerifyConnections::DeploymentJob
  def initialize(job_from_manifest)
    @from_manifest = job_from_manifest
  end

  def instances
    @from_manifest["instances"]
  end

  def static_ips_assigned
    []
  end

  def dns_offered
    []
  end

  def job_properties
    {}
  end
end
