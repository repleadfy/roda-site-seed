# frozen_string_literal: true

class Sender < Sequel::Model
  belongs_to :email_user, optional: true

  def self.table_name_prefix
    'cp_'
  end

  def self.rand_support
    Adm
      .where(is_support: true)
      .order('RAND()')
      .first
  end

  def self.rand_sdr
    where(is_sdr: true)
      .limit(1)
      .order('RAND()')
      .first
  end
end
