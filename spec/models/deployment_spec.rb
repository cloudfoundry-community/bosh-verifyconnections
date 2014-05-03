describe Bosh::VerifyConnections::Deployment do
  context "job_with_static_ips_but_not_referenced" do
    let(:manifest) { spec_fixture("job_with_static_ips_but_not_referenced.yml") }
    subject { Bosh::VerifyConnections::Deployment.new(manifest) }

    it { expect(subject.jobs.size).to eq(2) }
  end
end
