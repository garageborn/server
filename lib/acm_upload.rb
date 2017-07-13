require ::File.expand_path('../../config/environment', __FILE__)

class ACMUpload
  attr_accessor :domain

  def initialize(domain)
    @domain = domain
  end

  def run
    client.import_certificate(
      certificate: certificate,
      private_key: private_key,
      certificate_chain: certificate_chain
    )
  end

  private

  def client
    @client ||= Aws::ACM::Client.new
  end

  def certificate
    @certificate ||= File.open("#{ base_path }/cert.pem")
  end

  def private_key
    @private_key ||= File.open("#{ base_path }/privkey.pem")
  end

  def certificate_chain
    @certificate_chain ||= File.open("#{ base_path }/chain.pem")
  end

  def base_path
    ::File.expand_path("../../config/nginx/ssl/#{ domain }", __FILE__)
  end
end
