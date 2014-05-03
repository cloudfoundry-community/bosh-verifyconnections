describe Bosh::VerifyConnections::Deployment do
  context "job_with_static_ips_but_not_referenced" do
    let(:manifest) { spec_fixture("job_with_static_ips_but_not_referenced.yml") }
    subject { Bosh::VerifyConnections::Deployment.new(manifest) }

    it { expect(subject.jobs.size).to eq(2) }
    it { expect(subject.dns_offered("suffix")).to eq([
      "0.ephemeral.cf1.job-with-static-ips-but-not-referenced.suffix",
      "1.ephemeral.cf1.job-with-static-ips-but-not-referenced.suffix",
      "0.service.cf1.job-with-static-ips-but-not-referenced.suffix",
      "0.service.floating.job-with-static-ips-but-not-referenced.suffix"
    ])}
  end
end
