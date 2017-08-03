require ::File.expand_path('../../config/environment', __FILE__)

class ACMUpload
  attr_accessor :domain

  def initialize(domain)
    @domain = domain
  end

  def run
    client.import_certificate(
      certificate_arn: remote_certificate.try(:certificate_arn),
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

  def list_certificates
    @list_certificates ||= client.list_certificates.certificate_summary_list
  end

  def remote_certificate
    @remote_certificate ||= list_certificates.find do |certificate|
      certificate.domain_name == domain
    end
  end
end
