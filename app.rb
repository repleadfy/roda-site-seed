# frozen_string_literal: true

require 'roda'

require_relative './system/boot'

# The main class for Roda Application.
class App < Roda
  # Adds support for handling different execution environments (development/test/production).
  plugin :environments

  configure :development, :production do
    # A powerful logger for Roda with a few tricks up it's sleeve.
    plugin :enhanced_logger
  end

  # Assets
  plugin(
    :assets,
    css: 'app.scss',
    js: 'app.js',
    precompiled: File.expand_path('compiled_assets.json', __dir__),
    path: 'app/assets',
    css_opts: { style: :compressed, source_map_embed: true, source_map_contents: true, source_map_file: '.' },
    postprocessor: lambda do |file, type, content|
      puts("assets postprocessor: file=#{file}, type=#{type}, content-size=#{content.to_s.size}")
      content
    end
  )
  compile_assets unless ENV['RACK_ENV'] == 'development'

  # Render views
  plugin :render, layout: 'layouts/main', engine: 'html.erb', views: 'app/views'

  # Response caching
  plugin :caching

  # Handle specific errors
  plugin :status_handler

  status_handler(403) do
    'You are forbidden from seeing that!'
  end

  status_handler(404) do
    'Where did it go?' # TODO: render 404 error page here
  end

  # Adds ability to automatically handle errors raised by the application.
  plugin :exception_page

  plugin :error_handler do |e|
    next exception_page(e) if ENV['RACK_ENV'] == 'development'

    if e.instance_of?(Exceptions::InvalidParamsError)
      error_object    = e.object
      response.status = 422
    elsif e.instance_of?(Sequel::ValidationFailed)
      error_object    = e.model.errors
      response.status = 422
    elsif e.instance_of?(Sequel::NoMatchingRow)
      error_object    = { error: I18n.t('not_found') }
      response.status = 404
    else
      error_object    = { error: I18n.t('something_went_wrong') }
      response.status = 500
    end
    response.write(error_object.to_json)
  end

  # Allows modifying the default headers for responses.
  # plugin :default_headers,
  #        'Content-Type' => 'application/json',
  #        'Strict-Transport-Security' => 'max-age=16070400;',
  #        'X-Frame-Options' => 'deny',
  #        'X-Content-Type-Options' => 'nosniff',
  #        'X-XSS-Protection' => '1; mode=block'

  # Use public folder as location of files
  plugin :public

  plugin :hash_routes

  Dir['app/routes/**/*.rb'].each do |route_file|
    require_relative route_file
  end

  route do |r|
    # Serve assets in development mode
    r.assets unless ENV['RACK_ENV'] == 'production'

    # Make GET /images/foo.png look for public/images/foo.png
    r.public

    # Split routes to own files
    r.hash_routes

    # Heartbeat
    r.get('health_check_ztKwHt') do
      Var.limit(1).select_map(:id).to_s
    end
  end
end
