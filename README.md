# Bosh::Verifyconnections

BOSH CLI plugin that performs job interconnection verifications upon the target deployment

  1. Show jobs with static IPs that aren't referenced elsewhere in the deployment properties
  2. Show IPs in the deployment properties that aren't specified as static IPs by jobs
  3. What .*bosh hostnames are specified but don't map to a job
  4. What external hostnames (e.g. .com) are referenced but do not resolve (via dig for example)
     to a static IP of a job


## Installation

Add this line to your application's Gemfile:

```
gem 'bosh-verifyconnections'
```

## Usage

```
bosh verify connections
```

To see demonstration deployment manifests:

```
bosh deployment without verification spec/fixtures/job_with_static_ips_but_not_referenced.yml && bosh verify connections
```


## Contributing

1. Fork it ( https://github.com/cloudfoundry-community/bosh-verifyconnections/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
