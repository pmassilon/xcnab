# encoding: UTF-8
#
module Xcnab
  module Cobranca
    module Cnab240
      module Febraban
        module Escrever
          module Segmentos
            class P
              attr_accessor
                :codigo_banco,
                :sequencial_lote,
                :sequencial_segmento,
                :tipo_segmento,
                :movimento,
                :agencia,
                :agencia_dv,
                :conta,
                :conta_dv,
                :digito_verificador,
                :codigo_carteira,
                :forma_cadastra,
                :tipo_documento,
                :emitir_boleto,
                :distribuir_boleto,
                :numero_documento,
                :vencimento_titulo,
                :valor_titulo,
                :agencia_cobradora,
                :agencia_dv_cobradora,
                :especie_titulo,
                :data_emissao_titulo,
                :codigo_mora,
                :data_mora,
                :valor_mora,
                :codigo_desconto,
                :data_desconto,
                :valor_desconto

            def initialize(fields = {})
              fields = {
                especie_titulo: '',
                aceite: 'A'
              }.merge!(fields)

              fields.each do |field, value|
                send "#{field}=", value
              end
            end

            def tipo_registro '3'; end

            def montar_controle
              controle = ''
              controle << campo_numerico(codigo_banco, 3)
              controle << campo_numerico(sequencial_lote, 4)
              controle << campo_numerico(tipo_registro, 1)

              controle
            end

            def tipo_segmento 'P'; end

            def montar_servico
              servico = ''
              servico << campo_numerico(sequencial_segmento, 5)
              servico << campo_texto(tipo_segmento, 1)
              servico << bloco_branco(1)
              servico << campo_numerico(movimento, 2)
              servico
            end

            def montar_agencia
              agencia = ''
              agencia << campo_numerico(agencia, 5)
              agencia << campo_texto(agencia_dv, 1)

              agencia
            end

            def montar_conta
              conta = ''
              conta << campo_numerico(conta, 12)
              conta << campo_texto(conta_dv, 1)

              conta
            end

            def montar_conta_bancaria
              conta_bancaria = ''
              conta_bancaria << montar_agencia
              conta_bancaria << montar_conta
              conta_bancaria << campo_texto(digito_verificador, 1)

              conta_bancaria
            end

            def monrae_nosso_numero
              campo_texto(nosso_numero, 20)
            end

            def montar_caracteristica_cobranca
              caracteristica = ''
              caracteristica << campo_numerico(codigo_carteira, 0)
              caracteristica << campo_numerico(forma_cadastra, 0)
              caracteristica << campo_texto(tipo_documento, 0)
              caracteristica << campo_numerico(emitir_boleto, 0)
              caracteristica << campo_texto(distribuir_boleto, 0)

              caracteristica
            end

            def montar_documento
              documento = ''
              documento << campo_texto(numero_documento, 15)
              documento << formatar_datahora(vencimento_titulo, :data_completa)
              documento << formatar_valor(valor_titulo, 15)

              documento
            end

            def montar_agencia_cobradora
              cobradora = ''
              cobradora << campo_numerico(agencia_cobradora, 5)
              cobradora << campo_texto(agencia_dv_cobradora, 1)

              cobradora
            end

            def montar_especie_titulo
              campo_numerico(especie_titulo, 2)
            end

            def montar_aceite
              campo_texto(aceite, 1)
            end

            def montar_data_emissao_titulo
              formatar_datahora(data_emissao_titulo, :data_completa)
            end

            def montar_valor_mora
              formatar_valor(valor_mora, 15)
            end

            def montar_juros_mora
              mora = ''
              mora << campo_texto(codigo_mora, 1)
              mora << formatar_datahora(data_mora, :data_completa)
              mora << montar_valor_mora

              mora
            end

            def montar_valor_desconto
              formatar_valor(valor_desconto, 15)
            end

            def montar_desconto
              desconto = ''
              desconto << campo_texto(codigo_desconto, 1)
              desconto << formatar_datahora(data_desconto, :data_completa)
              desconto << montar_valor_desconto

              desconto
            end

            def p_layout
              puts 'Campo                      |   Descrição                              |   Posição      |   Tipo     |   Padrão'
              puts 'Banco                      |   Código do Banco na Compensação         |   [1......3]   |   0(003)   |   '
              puts 'Lote                       |   Lote de Serviço                        |   [4......7]   |   0(004)   |   '
              puts 'Registro                   |   Tipo de Registro                       |   [8......8]   |   0(001)   |   ‘3’'
              puts 'Nº do Registro             |   Nº Sequencial do Registro no Lote      |   [9.....13]   |   0(005)   |   '
              puts 'Segmento                   |   Cód. Segmento do Registro Detalhe      |   [14....14]   |   X(001)   |   ‘P‘'
              puts 'CNAB                       |   Uso Exclusivo FEBRABAN/CNAB            |   [15....15]   |   X(001)   |   Brancos'
              puts 'Cód. Mov.                  |   Código de Movimento Remessa            |   [16....17]   |   0(002)   |   '
              puts 'Código                     |   Agência Mantenedora da Conta           |   [18....22]   |   0(005)   |   '
              puts 'Digíto                     |   Dígito Verificador da Conta            |   [23....23]   |   X(001)   |   '
              puts 'Número                     |   Número da Conta Corrente               |   [24....35]   |   0(012)   |   '
              puts 'Digíto                     |   Dígito Verificador da Conta            |   [36....36]   |   X(001)   |   '
              puts 'Digíto verificador         |   Dígito Verificador da Ag/Conta         |   [37....37]   |   X(001)   |   '
              puts 'Nosso Número               |   Identificação do Título no Banco       |   [38....57]   |   X(020)   |   '
              puts 'Carteira                   |   Código da Carteira                     |   [58....58]   |   0(001)   |   '
              puts 'Cadastramento              |   Forma de Cadastr. do Título no Banco   |   [59....59]   |   0(001)   |   '
              puts 'Documento                  |   Tipo de Documento                      |   [60....60]   |   X(001)   |   '
              puts 'Emissão Boleto de Pag      |   Ident. da Emissão do Boleto de Pag     |   [61....61]   |   0(001)   |   '
              puts 'Distrib. Boleto de Pag     |   Ident. da Distribuição                 |   [62....62]   |   X(001)   |   '
              puts 'Nº do Documento            |   Número do Documento de Cobrança        |   [63....77]   |   X(015)   |   '
              puts 'Vencimento                 |   Data de Vencimento do Título           |   [78....85]   |   0(008)   |   '
              puts 'Valor do Título            |   Valor Nominal do Título                |   [86...100]   |   0(13,2)  |   '
              puts 'Ag. Cobradora              |   Agência Encarregada da Cobrança        |   [101..105]   |   0(005)   |   '
              puts 'DV                         |   Dígito Verificador da Agência          |   [106..106]   |   X(001)   |   '
              puts 'Espécie de Título          |   Espécie do Título                      |   [107..108]   |   0(002)   |   '
              puts 'Aceite                     |   Identific. de Título Aceito/Não Aceito |   [109..109]   |   X(001)   |   '
              puts 'Data Emissão do Título     |   Data da Emissão do Título              |   [110..117]   |   0(008)   |   ‘A/N‘'
              puts 'Cód. Juros                 |   Mora Código do Juros de Mora           |   [118..118]   |   0(001)   |   ‘3‘'
              puts 'Data Juros                 |   Mora Data do Juros de Mora             |   [119..126]   |   0(008)   |   '
              puts 'Juros Mora                 |   Juros de Mora por Dia/Taxa             |   [127..141]   |   0(13,2)  |   '
              puts 'Desc 1 Cód.                |   Desc. 1 Código do Desconto 1           |   [142..142]   |   0(001)   |   '
              puts 'Data Desc. 1               |   Data do Desconto 1                     |   [143..150]   |   0(008)   |   '
              puts 'Desconto 1                 |   Valor/Percentual a ser Concedido       |   [151..165]   |   0(13,2)  |   '
            end
          end
        end
      end
    end
  end
end
