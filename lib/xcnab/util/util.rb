# encoding: UTF-8
#
require 'date'
require 'i18n'

module Xcnab
  module Util
    def tipo_empresa(documento, tamanho = 1)
      (documento.delete('/.-').length > 11 ? '2' : '1').rjust(tamanho, '0')
    end

    def formatar_datahora(datahora, tipo = :data_completa)
      case tipo
      when :data_completa
        formato = '%d%m%Y'
      when :data_curta
        formato = '%d%m%y'
      when :hora_completa
        formato = '%H%M%S'
      when :hora_curta
        formato = '%H%M'
      else
        return '0000'
      end

      datahora.strftime(formato)
    rescue StandardError
      case tipo
      when :data_completa
        '00000000'
      when :data_curta
        '000000'
      when :hora_completa
        '000000'
      when :hora_curta
      else
        '0000'
      end
    end

    def bloco_branco(tamanho, texto = '', alinhamento = :left)
      texto ||= ''

      if alinhamento == :left
        texto.to_s.ljust(tamanho, ' ')
      else
        texto.to_s.rjust(tamanho, ' ')
      end
    end

    def bloco_zerado(tamanho, numero = '0', alinhamento = :right)
      numero ||= ''

      if alinhamento == :right
        numero.to_s.rjust(tamanho, '0')
      else
        numero.to_s.ljust(tamanho, '0')
      end
    end

    def campo_texto(texto, tamanho, alinhamento = :left)
      texto = texto.to_s

      if texto.to_s.size > tamanho
        truncate(texto, tamanho)
      else
        bloco_branco(tamanho, texto, alinhamento)
      end
    end

    def campo_numerico(numero, tamanho, alinhamento = :right)
      numero = numero.to_s

      if numero.to_s.size > tamanho
        truncate(numero, tamanho)
      else
        bloco_zerado(tamanho, numero)
      end
    end

    def formatar_cep(cep, formato = :completo)
      cep = campo_numerico(cep, 8)

      case formato
      when :completo
        cep
      when :prefixo
        campo_numerico(cep[0..4], 5)
      when :sufixo
        campo_numerico(cep[5..7], 3)
      else
        '00000000'
      end
    rescue StandardError
      case formato
      when :completo
        '00000000'
      when :prefixo
        '00000'
      when :sufixo
        '000'
      else
        '00000000'
      end
    end

    def formatar_valor(valor, tamanho, decimal = 2)
      valor = converter_valor(valor)
      valor =  format("%.#{decimal}f", valor).delete('.')
      campo_numerico(valor, tamanho)
    end

    def formatar_documento(documento, tamanho = 14)
      campo_numerico(documento.delete('/.-'), tamanho)
    end

    def limpar_texto(texto)
      I18n.config.available_locales = :en
      texto = I18n.transliterate(texto) # Remove accents
      texto.gsub!(/[^\-\/\\\.0-9A-Za-z ]/, ' ')
      texto
    end

    private

    def truncate(texto, tamanho)
      texto.to_s[0..(tamanho - 1)]
    end

    def converter_valor(valor)
      valor = valor.dup
      return '0' if valor.nil?
      return valor if valor.is_a?(Numeric)

      valor.gsub!(/[^\d^,.]/, '')
      if valor.include?(',')
        valor.delete!('.')
        valor.gsub!(',', '.')
      end

      valor.squish!
      valor.to_f
    end
  end
end
