# encoding: UTF-8
#

module Xcnab
  module Arquivo
    # Data de geracao do arquivo
    #
    # @return [String]
    #
    def data_arquivo(timestamp = nil)
      timestamp != nil ? DateTime.strptime("#{timestamp.to_s} BRT", '%s %Z') : DateTime.now
    end

    # Hora de geracao do arquivo
    #
    # @return [String]
    #
    def hora_arquivo(timestamp = nil)
      timestamp != nil ? Time.at(timestamp.to_i) : Time.now
    end

    def contador_lote(contador, tamanho = 4)
      campo_numerico(contador, tamanho)
    end

    def contador_registro(registros, tamanho = 4)
      campo_numerico(registros.count, tamanho)
    end

    def valor_total_registros(registros, tamanho = 13)
      valor_total = registros.inject(0.0) { |valor, registro| valor + registro.valor_pagamento }
      format_value(valor_total, tamanho)
    end

    def contador_lotes(lotes, tamanho = 4)
      campo_numerico(lotes.count, tamanho)
    end

    def contador_registros_lotes(lotes, tamanho)
      campo_numerico(lotes.map { |lote| lote.registros.count }.sum, tamanho)
    end
  end
end
