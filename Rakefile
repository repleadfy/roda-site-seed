# frozen_string_literal: true

# Rakefile contains all the application-related tasks.

require_relative './system/application'

# Enable database component.
Application.start(:database)

# Enable logger componnent.
Application.start(:logger)

# Add existing Logger instance to DB.loggers collection.
Application['database'].loggers << Application['logger']
