# frozen_string_literal: true

class Var < Sequel::Model
  def self.get_and_inc(key)
    var = find_by(key: key) || create(key: key, val: '0')
    val = Integer(var.val, 10)
    var.update(val: (val + 1).to_s)
    val
  end

  def self.get(key)
    find_by(key: key)&.val
  end
end
