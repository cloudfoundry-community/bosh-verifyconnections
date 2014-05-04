# bosh verify connections

BOSH CLI plugin that performs job interconnection verifications upon the target deployment

  1. Show jobs with static IPs that aren't referenced elsewhere in the deployment properties
  2. Show IPs in the deployment properties that aren't specified as static IPs by jobs
  3. What internal DNS hostnames are specified but don't map to a job


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

![v1](https://www.evernote.com/shard/s3/sh/41947f58-90fc-4f62-b0d8-ad3fae84c0a9/5bede6c17dacef652a8758037c223642/deep/0/drnic@drnic----gems-bosh-verifyconnections---zsh---204-48.png)

From this example, perhaps `service.host` should be changed to `10.244.0.6`.

Others to try:

```
bosh deployment without verification spec/fixtures/property_is_bosh_dns_but_not_for_bosh_job.yml && bosh verify connections
bosh deployment without verification spec/fixtures/property_is_static_ip_but_not_assigned_to_job.yml && bosh verify connections
```

### Example

You can see that deploying Cloud Foundry on bosh-lite includes two static IPs that aren't referenced properties:

```
$ bosh verify connections

Current deployment is /Users/drnic/Projects/ruby/gems/cloudfoundry/bosh-lite/manifests/cf-manifest.yml

Job static IPs that are not being referenced by any properties:
+----------------------------------+--------------------------------+
| static ip                        | job/index                      |
+----------------------------------+--------------------------------+
| 10.244.0.34                      | ha_proxy_z1/0                  |
| 10.244.0.26                      | runner_z1/0                    |
+----------------------------------+--------------------------------+
```

The `ha_proxy_z1/0` static IP is used for the public access via `10.244.0.34.xip.io`, but theoretically the `runner_z1/0` job has no reason for a static IP.

From the [history of cf-release](https://github.com/cloudfoundry/cf-release/commit/858d1b7e1f0544fb9fd4d9a7a1608e542da6bcdd), the static IP was assigned to ease integration testing.

## Contributing

1. Fork it ( https://github.com/cloudfoundry-community/bosh-verifyconnections/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
