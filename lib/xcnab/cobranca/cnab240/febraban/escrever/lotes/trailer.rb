# encoding: UTF-8
#
module Xcnab
  module Cobranca
    module Cnab240
      module Febraban
        module Escrever
          module Lotes
            class Trailer
              attr_accessor
                :codigo_banco,
                :sequencial_lote,
                :quantidade_registros,
                :quantidade_cobranca_simples,
                :valor_cobranca_simples,
                :quantidade_cobranca_vinculada,
                :valor_cobranca_vinculada,
                :quantidade_cobranca_aucionada,
                :valor_cobranca_aucionada,
                :quantidade_cobranca_escontada,
                :valor_cobranca_descontada,
                :aviso

              def initialize(fields = {})
                fields = {}.merge!(fields)

                fields.each do |field, value|
                  send "#{field}=", value
                end
              end

              def tipo_trailer '5'; end

              def montar_controle
                controle = ''
                controle << campo_numerico(codigo_banco, 3)
                controle << campo_numerico(sequencial_lote, 4)
                controle << campo_numerico(tipo_trailer, 1)
                controle << bloco_branco(9)

                controle
              end

              def montar_quantidade_registros
                campo_numerico(quantidade_registros, 6)
              end

              def montar_totalizacao_cobranca_simples
                simples = ''
                simples << campo_numerico(quantidade_cobranca_simples, 6)
                simples << formatar_valor(valor_cobranca_simples, 17)

                simples
              end

              def montar_totalizacao_cobranca_vinculada
                vinculada = ''
                vinculada << campo_numerico(quantidade_cobranca_vinculada, 6)
                vinculada << formatar_valor(valor_cobranca_vinculada, 17)

                vinculada
              end

              def montar_totalizacao_cobranca_caucionada
                aucionada = ''
                aucionada << campo_numerico(quantidade_cobranca_aucionada, 6)
                aucionada << formatar_valor(valor_cobranca_aucionada, 17)

                aucionada
              end

              def montar_totalizacao_cobranca_descontada
                descontada = ''
                descontada << campo_numerico(quantidade_cobranca_descontada, 6)
                descontada << formatar_valor(valor_cobranca_descontada, 17)

                descontada
              end

              def montar_aviso
                campo_texto(aviso, 8)
              end

              def montar_reservado
                bloco_branco(117)
              end

              def call
                trailer = ''
                trailer << montar_controle
                trailer << montar_quantidade_registros
                trailer << montar_totalizacao_cobranca_simples
                trailer << montar_totalizacao_cobranca_vinculada
                trailer << montar_totalizacao_cobranca_caucionada
                trailer << montar_totalizacao_cobranca_descontada
                trailer << montar_aviso
                trailer << montar_reservado

                trailer
              end
            end

            def trailer_layout
              puts 'Campo                      |   Descrição                              |   Posição      |   Tipo     |   Padrão'
              puts 'Banco                      |   Código do Banco na Compensação         |   [1......3]   |   0(3)     |   '
              puts 'Lote                       |   Lote de Serviço                        |   [4......7]   |   0(4)     |   '
              puts 'Registro                   |   Tipo de Registro                       |   [8......8]   |   0(1)     |   ‘5’'
              puts 'CNAB                       |   Uso Exclusivo FEBRABAN/CNAB            |   [9.....17]   |   X(9)     |    Brancos'
              puts 'Qtde de Registros          |   Quantidade de Registros no Lote        |   [18....23]   |   0(6)     |'
              puts 'Totalização da Cobrança'
              puts '   Simples                 |   Quantidade de Títulos em Cobrança      |   [24....29]   |   0(6)     |'
              puts '   Simples                 |   Valor Total dos Títulos em Carteiras   |   [30....46]   |   0(15,2)  |'
              puts '   Vinculada               |   Quantidade de Títulos em Cobrança      |   [47....52]   |   0(6)     |'
              puts '   Vinculada               |   Valor Total dos Títulos em Carteiras   |   [53....69]   |   0(15,2)  |'
              puts '   Caucionada              |   Quantidade de Títulos em Cobrança      |   [70....75]   |   0(6)     |'
              puts '   Caucionada              |   Valor Total dos Títulos em Carteiras   |   [76....92]   |   0(15,2)  |'
              puts '   Descontada              |   Quantidade de Títulos em Cobrança      |   [93....98]   |   0(6)     |'
              puts '   Descontada              |   Valor Total dos Títulos em Carteiras   |   [99...115]   |   0(15,2)  |'
              puts 'N. do Aviso                |   Número do Aviso de Lançamento          |   [116..123]   |   X(8)     |'
              puts 'CNAB                       |   Uso Exclusivo FEBRABAN/CNAB            |   [124..240]   |   X(117)   |    Brancos'
            end
          end
        end
      end
    end
  end
end
