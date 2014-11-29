require 'yaml'

module IBAN
  class IBAN
    attr_reader :iban
    attr_reader :errors

    def self.structures
      YAML.load_file("#{File.dirname(__FILE__)}/structures.yml")
    end

    def initialize(iban)
      @iban = iban.to_s.gsub(/\s+/, '').upcase
      @errors = {}
    end

    def formatted
      iban.gsub(/(.{4})/, '\1 ').strip
    end

    ###################
    # Component parts #
    ###################

    def country_code
      iban[0, 2]
    end

    def check_digits
      iban[2, 2]
    end

    def bank_code
      iban.slice(
        structure[:bank_code_position] - 1,
        structure[:bank_code_length]
      )
    end

    def branch_code
      return unless structure[:branch_code_length] > 0

      iban.slice(
        structure[:branch_code_position] - 1,
        structure[:branch_code_length]
      )
    end

    def account_number
      iban.slice(
        structure[:account_number_position] - 1,
        structure[:account_number_length]
      )
    end

    def iban_national_id
      national_id = branch_code.nil? ? bank_code : bank_code + branch_code
      national_id.slice(0, structure[:iban_national_id_length])
    end

    def bban
      iban[4..-1]
    end

    ###############
    # Validations #
    ###############

    def valid?
      [
        valid_country_code?,
        valid_characters?,
        valid_check_digits?,
        valid_length?,
        valid_format?,
      ].all?
    end

    def valid_country_code?
      if IBAN.structures.key?(country_code)
        @errors.delete(:country_code)
        true
      else
        @errors[:country_code] = "'#{country_code}' is not a valid " \
                                 "ISO 3166-1 IBAN country code"
        false
      end
    end

    def valid_check_digits?
      return unless valid_characters?

      if check_digits == calculated_check_digits
        @errors.delete(:check_digits)
        true
      else
        @errors[:check_digits] = "Check digits failed modulus check. " \
                                 "Expected #{check_digits}, received " \
                                 "#{calculated_check_digits}"
        false
      end
    end

    def valid_length?
      return unless valid_country_code?

      if iban.size == structure[:total_length]
        @errors.delete(:length)
        true
      else
        @errors[:length] = "Length doesn't match SWIFT specification " \
                           "(expected #{structure[:total_length]} " \
                           "characters, received #{iban.size})"
        false
      end
    end

    def valid_characters?
      if iban.scan(/[^A-Z0-9]/).any?
        @errors[:characters] = "Non-alphanumeric characters found: " \
                               "#{iban.scan(/[^A-Z\d]/).join(' ')}"
        false
      else
        @errors.delete(:characters)
        true
      end
    end

    def valid_format?
      return unless valid_country_code?

      if bban =~ Regexp.new(structure[:bban_format])
        @errors.delete(:format)
        true
      else
        @errors[:format] = "Unexpected format for a #{country_code} IBAN."
        false
      end
    end

    ###################
    # Private methods #
    ###################

    private

    def calculated_check_digits
      iban_chars = iban[4..-1] + iban[0..1] + "00"
      iban_digits = iban_chars.bytes.map do |byte|
        case byte
        when 48..57 then byte.chr           # 0..9
        when 65..90 then (byte - 55).to_s   # A..Z
        else raise "Unexpected byte '#{byte}' in IBAN code"
        end
      end
      remainder = iban_digits.join.to_i % 97
      format('%02d', 98 - remainder)
    end

    def structure
      IBAN.structures[country_code]
    end
  end
end
