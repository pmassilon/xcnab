# encoding: UTF-8
#
module Xcnab
  module Cobranca
    module Cnab240
      module Febraban
        module Escrever
          class Lote
            attr_accessor
              :header,
              :segmentos,
              :trailer

            def initialize(header, segmentos, trailer)
              @header = header
              @segmentos = segmentos
              @trailer = trailer
            end

            def call
              lote = []
              lote << header.call
              lote << segmentos.call
              lote << trailer.call

              lote
            end
          end
        end
      end
    end
  end
end
