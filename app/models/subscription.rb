# frozen_string_literal: true

class Subscription < Sequel::Model
  before_save :update_contact_ident

  def self.update_location
    where('state IS NULL AND city IS NULL').each do |sub|
      next if sub.remote_ip.blank?

      resp = Geoip.get(sub.remote_ip)
      sub.update(
        state: resp['region_name'],
        city: resp['city']
      )
    end
  end

  def update_contact_ident
    ci = mk_contact_ident
    self.contact_ident = ci if ci
  end

  def mk_contact_ident
    [
      email,
      phone
    ].reject(&:blank?)
      .join('-')
      .parameterize
      .presence
  end
end
