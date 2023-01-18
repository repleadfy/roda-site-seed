# frozen_string_literal: true

class App
  hash_branch 'team' do |r|
    r.hash_routes(:team)
    'team'
  end
end
