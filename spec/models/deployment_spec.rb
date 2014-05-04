describe Bosh::VerifyConnections::Deployment do
  context "job_with_static_ips_but_not_referenced" do
    let(:manifest) { spec_fixture("job_with_static_ips_but_not_referenced.yml") }
    subject { Bosh::VerifyConnections::Deployment.new(manifest, "suffix") }

    it { expect(subject.jobs.size).to eq(2) }
    it { expect(subject.hostnames_offered).to eq([
      "0.ephemeral.cf1.job-with-static-ips-but-not-referenced.suffix",
      "1.ephemeral.cf1.job-with-static-ips-but-not-referenced.suffix",
      "0.service.cf1.job-with-static-ips-but-not-referenced.suffix",
      "0.service.floating.job-with-static-ips-but-not-referenced.suffix"
    ])}

    it { expect(subject.static_ips_assigned).to eq(["10.244.0.6"])}
    it { expect(subject.global_properties).to eq({
      "service" => {
        "host" => "10.244.0.10",
        "port" => 3333
      }
    })}

    it { expect(subject.unreferenced_static_ips_with_job_index).to eq([["10.244.0.6", "service/0"]]) }

    it { expect(subject.property_static_ips_not_assigned_to_job).to eq([["service.host", "10.244.0.10", "global"]]) }

    it { expect(subject.property_hostnames_not_mapping_to_job).to eq([]) }
  end
end
