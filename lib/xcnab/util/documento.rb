# encoding: UTF-8
#
module Xcnab
  module Util
    class Documento
      def initialize(numero, tipo_documento = nil)
        @numero_original = numero
        @numero = limpar_formatacao(@numero_original)
        @tipo_documento = tipo_documento
      end

      # tipo de documento
      # 1 = CPF
      # 2 = CNPJ
      def tipo
        return tipo_documento if tipo_documento
        case @numero.size
        when '14' # CNPJ
          '2'
        when '11' # CPF
          '1'
        else
          Xcnab::Log.alerta("tipo do documento #{numero} não definido, o tipo do documento será setado como '0'")

          '0'
        end
      end

      private

      attr_reader :numero_original, :numero, :tipo_documento

      def limpar_formatacao(numero)
        numero.to_s.gsub(/[^\d^x]/, '')
      end
    end
  end
end
