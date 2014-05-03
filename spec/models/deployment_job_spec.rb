describe Bosh::VerifyConnections::DeploymentJob do
  context "static_ips" do
    subject do
      Bosh::VerifyConnections::DeploymentJob.new({
        "name" => "service",
        "instances" => 1,
        "templates" => [{
          "name" => "postgres"
        }],
        "networks" => [
          {
            "name" => "cf1",
            "default" => ["dns", "gateway"]
          },
          {
            "name" => "floating",
            "static_ips" => ["10.244.0.6"]
          }
        ]
      })
    end
    it { expect(subject.instances).to eq(1) }
  end
end
