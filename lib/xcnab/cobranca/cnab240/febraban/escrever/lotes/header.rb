# encoding: UTF-8
#
module Xcnab
  module Cobranca
    module Cnab240
      module Febraban
        module Escrever
          module Lotes
            class Header
              attr_accessor
                :codigo_banco,
                :sequencial_lote,
                :operacao,
                :tipo_documento_empresa,
                :documento_empresa,
                :convenio,
                :agencia,
                :agencia_dv,
                :conta,
                :conta_dv,
                :digito_verificador,
                :nome_benificiario,
                :primeira_mensagem,
                :segunda_mensagem,
                :sequencial,
                :data_arquivo,
                :data_ocorrencia

              def initialize(fields = {})
                fields = {}.merge!(fields)

                fields.each do |field, value|
                  send "#{field}=", value
                end
              end

              def tipo_header '1'; end

              def servico '01'; end

              def versao_layout '060'; end

              def montar_controle
                controle = ''
                controle << campo_numerico(codigo_banco, 3)
                controle << campo_numerico(sequencial_lote, 4)
                controle << campo_numerico(tipo_header, 1)

                controle
              end

              def montar_servico
                servico = ''
                servico << campo_texto(operacao, 1)
                servico << campo_numerico(servico, 2)
                servico << bloco_branco(2)
                servico << campo_numerico(versao_layout, 3)
                servico << bloco_branco(1)

                servico
              end

              def montar_instricao
                documento = Xcnab::Util::Documento.new(documento, tipo_documento)

                instricao = ''
                instricao << campo_numerico(documento.numero, 1)
                instricao << campo_numerico(documento.tipo, 15)

                instricao
              end

              def montar_convenio
                campo_numerico(convenio, 20)
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

              def montar_benificiario
                campo_texto(nome_benificiario, 30)
              end

              def montar_mensagens
                mensagens = ''
                mensagens << campo_texto(primeira_mensagem, 40)
                mensagens << campo_texto(segunda_mensagem, 40)

                mensagens
              end

              def montar_controle_cobranca
                controle = ''
                controle << campo_numerico(sequencial, 8)
                controle << campo_numerico(data_arquivo, 8)

                controle
              end

              def montar_data_ocorrencia
                bloco_zerado(data_ocorrencia, 8)
              end

              def montar_reservado
                bloco_branco(33)
              end

              def call
                header = ''
                header << montar_controle ## Controle
                header << montar_servico  ## Serviço
                header << montar_instricao ## Benificiario ### Inscrição
                header << montar_convenio ## Benificiario ### Convênio
                header << montar_conta_bancaria ## Benificiario ### C/C #### AgÊncia-dv #### Conta-dv #### A/C-dv
                header << montar_benificiario ## Benificiario ### Razão
                header << montar_mensagens ## Mensagens
                header << montar_controle_cobranca ## Controle da Cobrança
                header << montar_data_ocorrencia ## Data do Crédito
                header << montar_reservado ## Reservado

                header
              end

              def header_layout
                puts 'Campo                |   Descrição                          |   Posição      |   Tipo     |   Padrão'
                puts 'Banco                |   Código do Banco na Compensação     |   [1......3]   |   0(003)   |   '
                puts 'Lote                 |   Lote de Serviço                    |   [4......7]   |   0(004)   |   '
                puts 'Registro             |   Tipo de Registro                   |   [8......8]   |   0(001)   |   1'
                puts 'Operação             |   Código do Banco na Compensação     |   [9......9]   |   X(001)   |   '
                puts 'Serviço              |   Lote de Serviço                    |   [10....11]   |   0(002)   |   01'
                puts 'CNAB                 |   Uso Exclusivo FEBRABAN/CNAB        |   [12....13]   |   X(002)   |   BRANCOS'
                puts 'Layout do Lote       |   Nº da Versão do Layout do Lote     |   [14....16]   |   0(003)   |   060'
                puts 'CNAB                 |   Uso Exclusivo FEBRABAN/CNAB        |   [17....17]   |   X(001)   |   BRANCOS'
                puts 'Tipo                 |   Tipo de Inscrição da Empresa       |   [18....18]   |   0(001)   |   '
                puts 'Número               |   Nº de Inscrição da Empresa         |   [19....33]   |   0(015)   |   '
                puts 'Convênio             |   Código do Convênio no Banco        |   [34....53]   |   X(020)   |   '
                puts 'Código               |   Agência Mantenedora da Conta       |   [54....68]   |   0(005)   |   '
                puts 'Digíto               |   Dígito Verificador da Conta        |   [59....59]   |   X(001)   |   '
                puts 'Número               |   Número da Conta Corrente           |   [60....71]   |   0(012)   |   '
                puts 'Digíto               |   Dígito Verificador da Conta        |   [72....72]   |   X(001)   |   '
                puts 'Digíto verificador   |   Dígito Verificador da Ag/Conta     |   [73....73]   |   X(001)   |   '
                puts 'Nome                 |   Nome da Empresa                    |   [74...103]   |   X(030)   |   '
                puts 'Informação 1         |   Mensagem 1                         |   [103..143]   |   X(040)   |   '
                puts 'Informação 2         |   Mensagem 2                         |   [144..183]   |   X(040)   |   '
                puts 'Nº Rem./Ret.         |   Número Remessa/Retorno             |   [184..191]   |   0(008)   |   '
                puts 'Dt. Gravação         |   Data de Gravação Remessa/Retorno   |   [192..199]   |   0(008)   |   '
                puts 'Data do Crédito      |   Data do Crédito do Retorno         |   [200..207]   |   0(008)   |   Data de efetivação do crédito referente ao pagamento do título de cobrança. Informação enviada somente no arquivo de retorno.'
                puts 'CNAB                 |   Uso Exclusivo FEBRABAN/CNAB        |   [208..240]   |   X(033)   |   '
              end
            end
          end
        end
      end
    end
  end
end
