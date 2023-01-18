# frozen_string_literal: true

# {Constants} module is responsible for storing constants that are used across the application.
module Constants
  # Regex that is used during email validation process.
  EMAIL_REGEX = /^[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+$/

  public_constant :EMAIL_REGEX

  # List of valid values for sort directions.
  SORT_DIRECTIONS = %w[desc asc].freeze

  public_constant :SORT_DIRECTIONS
end
