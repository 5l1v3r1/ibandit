module Ibandit
  module Constants
    SUPPORTED_COUNTRY_CODES = %w[AT AU BE BG CY CZ DE DK EE ES FI FR GB GR HR
                                 HU IE IS IT LT LU LV MC MT NL NO PL PT RO SE
                                 SI SK SM].freeze

    PSEUDO_IBAN_COUNTRY_CODES = %w[AU SE].freeze
    CONSTRUCTABLE_IBAN_COUNTRY_CODES = SUPPORTED_COUNTRY_CODES - %w[AU]
    DECONSTRUCTABLE_IBAN_COUNTRY_CODES =
      SUPPORTED_COUNTRY_CODES - PSEUDO_IBAN_COUNTRY_CODES

    PSEUDO_IBAN_CHECK_DIGITS = "ZZ".freeze
  end
end
