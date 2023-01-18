#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

class DeployContext
  def initialize
    @dir_script = __dir__
    @dir_deploy = File.dirname(@dir_script)
    @app_conf = read_app_conf
  end

  def get
    validate_context!
    @app_conf
  end

  private

  def read_app_conf
    c = YAML.safe_load(File.read(app_conf_path)).transform_keys(&:to_sym)
    c[:dir_deploy] = @dir_deploy
    c[:dir_script] = @dir_script
    c
  end

  def app_conf_path
    File.join(@dir_deploy, 'app.yml')
  end

  def validate_context!
    return if current_context == @app_conf[:context]

    warn("Wrong context. Switch to #{@app_conf[:context]}.")
    exit(1)
  end

  def current_context
    `kubectl config current-context`.strip
  end
end
