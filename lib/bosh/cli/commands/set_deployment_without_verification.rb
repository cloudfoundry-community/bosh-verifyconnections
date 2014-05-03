module Bosh::Cli::Command
  class SetDeploymentWithoutVerification < Base
    include Bosh::Cli::Validation

    usage "deployment without verification"
    desc "Ignore the director_uuid being incorrect and set the new deployment anyway"
    def set_current_without_verification(filename = nil)
      if filename.nil?
        show_current
        return
      end

      manifest_filename = find_deployment(filename)

      unless File.exists?(manifest_filename)
        err("Missing manifest for `#{filename}'")
      end

      manifest = load_yaml_file(manifest_filename)

      unless manifest.is_a?(Hash)
        err("Invalid manifest format")
      end

      manifest["director_uuid"] = director.uuid

      tmp_manifest_filename = File.join("/tmp/", "#{manifest["name"]}.yml")
      File.open(tmp_manifest_filename, "w") do |f|
        f.puts(manifest.to_yaml)
      end

      # change director_uuid
      # store manifest to tmp file
      # set_deployment

      say("Deployment set to `#{tmp_manifest_filename.make_yellow}'")
      config.set_deployment(tmp_manifest_filename)
      config.save
    end
  end
end
