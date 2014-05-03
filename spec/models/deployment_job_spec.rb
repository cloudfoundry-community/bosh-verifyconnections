describe Bosh::VerifyConnections::DeploymentJob do
  context "static_ips" do
    subject do
      Bosh::VerifyConnections::DeploymentJob.new({
        "name" => "service_name",
        "instances" => 1,
        "templates" => [{
          "name" => "postgres"
        }],
        "networks" => [
          {
            "name" => "internal_network",
            "default" => ["dns", "gateway"]
          },
          {
            "name" => "floating",
            "static_ips" => ["10.244.0.6"]
          }
        ],
        "properties" => {
          "port" => 3333
        }
      })
    end
    it { expect(subject.instances).to eq(1) }
    it { expect(subject.static_ips_assigned).to eq(["10.244.0.6"])}
    it { expect(subject.hostnames_offered("my_deployment", "suffix")).to eq([
      "0.service-name.internal-network.my-deployment.suffix",
      "0.service-name.floating.my-deployment.suffix"
    ])}
    it { expect(subject.job_properties).to eq({"port" => 3333}) }
  end
end
