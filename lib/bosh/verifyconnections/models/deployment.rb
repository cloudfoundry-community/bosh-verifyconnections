module Bosh::VerifyConnections
  class Deployment
    include BoshExtensions

    attr_reader :deployment, :jobs

    def initialize(deployment_file)
      parse_deployment_file(deployment_file)
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