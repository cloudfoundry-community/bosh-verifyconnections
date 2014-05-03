describe Bosh::VerifyConnections::Deployment do
  context "job_with_static_ips_but_not_referenced" do
    let(:manifest) { spec_fixture("job_with_static_ips_but_not_referenced.yml") }
    subject { Bosh::VerifyConnections::Deployment.new(manifest) }

    it { expect(subject.jobs.size).to eq(2) }
    it { expect(subject.hostnames_offered("suffix")).to eq([
      "0.ephemeral.cf1.job-with-static-ips-but-not-referenced.suffix",
      "1.ephemeral.cf1.job-with-static-ips-but-not-referenced.suffix",
      "0.service.cf1.job-with-static-ips-but-not-referenced.suffix",
      "0.service.floating.job-with-static-ips-but-not-referenced.suffix"
    ])}

    it { expect(subject.static_ips_assigned).to eq(["10.244.0.6"])}
    it { expect(subject.global_properties).to eq({
      "service" => {
        "host" => "10.244.0.6",
        "port" => 3333
      }
    })}

    it { expect(subject.job_properties("service")).to eq({
      "service" => {
        "host" => "10.244.0.6",
        "port" => 4444
      },
      "extra" => "property",
    })}
    it { expect(subject.job_properties("ephemeral")).to eq({
      "service" => {
        "host" => "10.244.0.6",
        "port" => 3333
      }
    })}


  end
end
