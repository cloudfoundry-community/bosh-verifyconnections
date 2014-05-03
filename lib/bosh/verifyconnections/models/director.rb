module Bosh::VerifyConnections
  class Director
    def initialize(status)
      @status = status
    end

    def dns?
      @status["features"]["dns"] && @status["features"]["dns"]["status"]
    end

    def domain_name
      @status["features"]["dns"]["extras"]["domain_name"]
    end
  end
end
