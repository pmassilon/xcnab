# encoding: UTF-8
#
module Xcnab
  module Cobranca
    class Lote
      attr_accessor
        :header,
        :registros,
        :trailer

      def initialize(header, registros, trailer)
        @header = header
        @registros = registros
        @trailer = trailer
      end

      def call
        lote = []
        lote << header.call
        lote << registros.call
        lote << trailer.call

        lote
      end
    end
  end
end
