# encoding: UTF-8
#
module Xcnab
  module Cobranca
    class Registro
      attr_accessor :kind_segment
      attr_accessor :kind_action
      attr_accessor :kind_action_instruction
      attr_accessor :code_camera_compensation
      attr_accessor :company_payee
      attr_accessor :kind_document
      attr_accessor :document_payee
      attr_accessor :bank_code_payee
      attr_accessor :agency_payee
      attr_accessor :agency_cd_payee
      attr_accessor :account_payee
      attr_accessor :account_cd_payee
      attr_accessor :check_digit_payee
      attr_accessor :address_street
      attr_accessor :address_number
      attr_accessor :address_complemnt
      attr_accessor :address_neighborhood
      attr_accessor :address_city
      attr_accessor :address_zip_code
      attr_accessor :address_state
      attr_accessor :payment_number
      attr_accessor :payment_date
      attr_accessor :kind_currency
      attr_accessor :payment_value
      attr_accessor :bank_number
      attr_accessor :payment_date_happens
      attr_accessor :payment_value_original
      attr_accessor :due_date
      attr_accessor :specific_message
      attr_accessor :finality
      attr_accessor :reference_number
      attr_accessor :notification_payee
      attr_accessor :authentication_payment
      attr_accessor :protocol_payment
      attr_accessor :occurrence

      attr_accessor :value_document
      attr_accessor :value_rebate
      attr_accessor :value_discount
      attr_accessor :value_moratorium
      attr_accessor :value_mulct
      attr_accessor :code_historic

      def initialize(fields = {})
        fields = {
          kind_currency: 'BRL',
          code_camera_compensation: '000',
          finality: '00',
          occurrence: '00',
          notification_payee: '0',
          value_document: 0.0,
          value_rebate: 0.0,
          value_discount: 0.0,
          value_moratorium: 0.0,
          value_mulct: 0.0
        }.merge!(fields)

        fields.each do |field, value|
          send "#{field}=", value
        end

        yield self if block_given?
      end
    end
  end
end
