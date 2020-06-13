# encoding: UTF-8
#
module Xcnab
  module Cobranca
    class Arquivo
      attr_accessor
        :header,
        :lotes,
        :trailer

      def initialize(header, lotes, trailer)
        @header = header
        @lotes = lotes
        @trailer = trailer
      end

      def call
        arquvo = []
        arquvo << header.call
        arquvo << lotes.call
        arquvo << trailer.call

        arquivo = arquivo
                    .join("\r\n")
                    .to_ascii.upcase

        arquivo << "\r\n"
        arquivo = arquivo
                    .encode(arquivo.encoding, universal_newline: true)
                    .encode(arquivo.encoding, crlf_newline: true)

        arquivo
        arquvo
      end
    end
  end
end
