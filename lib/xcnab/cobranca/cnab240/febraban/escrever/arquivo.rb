# encoding: UTF-8
#
module Xcnab
  module Cobranca
    module Remessa
      module Cnab240
        module Santander
          class Arquivo < Xcnab::Cobranca::Remessa::Base

            attr_accessor :tipo_inscricao
            attr_accessor :inscricao
            attr_accessor :convenio
            attr_accessor :agencia
            attr_accessor :agencia_dv
            attr_accessor :conta
            attr_accessor :conta_dv
            attr_accessor :digito_verificador
            attr_accessor :nome_benificiario
            attr_accessor :primeira_mensagem
            attr_accessor :segunda_mensagem
            attr_accessor :sequencial
            attr_accessor :data_arquivo
            attr_accessor :data_ocorrencia

            def initialize(fields = {})
              fields = {
                address_street: '',
                address_number: '',
                address_complemnt: '',
                address_city: '',
                address_zip_code: '',
                address_state: ''
              }.merge!(fields)

              # @validation_rules = [
              #   {
              #     fields: %i(
              #       company_payer document_payer
              #       agency account
              #       kind_file number_sequential batches
              #     ),
              #     presence: true
              #   },
              #   { fields: %i(company_payer), length: { max: 30 } },
              #   { fields: %i(document_payer), length: { max: 14 } },
              #   { fields: %i(contract_number), length: { max: 20 } },
              #   { fields: %i(agency), length: { max: 5 } },
              #   { fields: %i(account), length: { max: 12 } },
              #   { fields: %i(kind_file), length: { is: 1 } },
              #   { fields: %i(occurrence), length: { max: 10 } },
              #   { fields: %i(batches), type: { is: Array } }
              # ]

              super(fields)
            end

            # Build file body
            # Expects Zero params
            # Return [String]
            def call
              # self.validate!

              arquivo = []
              arquivo << construir_header_arquivo,
              arquivo << construir_lotes(batches),
              arquivo << construir_trailer_arquivo(batches)


              arquivo = arquivo
                          .join("\r\n")
                          .to_ascii.upcase
              arquivo << "\r\n"
              arquivo = arquivo
                          .encode(arquivo.encoding, universal_newline: true)
                          .encode(arquivo.encoding, crlf_newline: true)

              arquivo
            end

            def codigo_banco
              '033'
            end

            def lote_header
              '0000'
            end

            def lote_trailer
              '9999'
            end

            def tipo_header
              '1'
            end

            def nome_banco
              campo_texto('BANCO SANTANDER S.A.', 30)
            end

            def operacao
              'R' # Remessa
            end

            def servico
              '01' # Corança
            end

            def versao_layout
              '060'
            end

            # Build Header File
            # Expects Zero params
            # Return [String]

            def construir_header_arquivo
              header_file = ''                                                      # Descrição                               Posição    Tamanho
              header_file << codigo_banco                                              # Código do Banco                         001..003   9(003)
              header_file << bloco_zerado(4)                                          # Lote de Serviço                         004..007   9(004)
              header_file << '0'                                                    # Tipo de Registro                        008..008   9(001)
              header_file << bloco_zerado(9)                                         # Filler                                  009..017   X(009)
              header_file << kind_profile(document_payer)                           # Tipo de Inscrição da Empresa            018..018   9(001)
              header_file << formata_documento(document_payer, 14)                    # Número Inscrição da Empresa             019..032   9(014)
              header_file << campo_texto(contract_number, 20)                     # Código do Convenio no Banco             033..052   X(020)
              header_file << campo_numerico(agency, 5)                                 # Agência Mantenedora da Conta            053..057   9(005)
              header_file << campo_texto(agency_cd, 1)                            # Dígito Verificador da Agência           058..058   X(001)
              header_file << campo_numerico(account, 12)                               # Número da Conta Corrente                059..070   9(012)
              header_file << campo_texto(account_cd, 1)                           # Dígito Verificador da Conta             071..071   X(001)
              header_file << campo_texto(check_digit, 1)                          # Dígito Verificador da Agência / Conta   072..072   X(001)
              header_file << campo_texto(company_payer, 30)                       # Nome da Empresa                         073..102   X(030)
              header_file << nome_banco                                              # Nome do Banco                           103..132   X(030)
              header_file << bloco_zerado(10)                                        # Filler                                  133..142   X(010)
              header_file << kind_file                                              # Código Remessa / Retorno                143..143   9(001)
              header_file << formatar_datahora(date_file(timestamp), :date_long)          # Data da Geração do Arquivo              144..151   9(008)
              header_file << formatar_datahora(time_file(timestamp), :time_long)          # Hora da Geração do Arquivo              152..157   9(006)
              header_file << campo_numerico(number_sequential, 6)                      # Número Seqüencial do Arquivo            158..163   9(006)
              header_file << versao_layout                                         # Número da Versão do Layout              164..166   9(003)
              header_file << bloco_zerado(5)                                          # Densidade de Gravação Arquivo           167..171   9(005)
              header_file << bloco_zerado(20)                                        # Uso Reservado do Banco                  172..191   X(020)
              header_file << bloco_zerado(20)                                        # Uso Reservado da Empresa                192..211   X(020)
              header_file << bloco_zerado(19)                                        # Filler                                  212..230   X(019)
              header_file << campo_texto(occurrence, 10)                          # Ocorrências para o Retorno              231..240   X(010)
              clear_line(header_file)
            end


            # Build Header Batch
            # Expects two params, a Batch and Integer
            # Return [String]
            def builder_header_batch(batch, number_batch)
              header_batch = ''                                                     # Descrição                               Posição    Tamanho
              header_batch << codigo_banco                                             # Código do Banco                         001..003   9(003)
              header_batch << counter_batch(number_batch)                           # Lote de Serviço                         004..007   9(004)
              header_batch << '1'                                                   # Tipo de Registro                        008..008   9(001)
              header_batch << 'C'                                                   # Tipo da Operação                        009..009   X(001)
              header_batch << batch.kind_service                                    # Tipo de Serviço                         010..011   9(002)
              header_batch << batch.kind_release                                    # Forma de Lançamento                     012..013   9(002)
              header_batch << batch.versao_batch_layout                            # Número da Versão do Lote                014..016   9(003)
              header_batch << bloco_zerado(1)                                        # Filler                                  017..017   X(001)
              header_batch << kind_profile(document_payer)                          # Tipo de Inscrição da Empresa            018..018   9(001)
              header_batch << formata_documento(document_payer, 14)                   # Número de Inscrição da Empresa          019..032   9(014)
              header_batch << campo_texto(contract_number, 20)                    # Código do Convenio no Banco             033..052   X(020)
              header_batch << campo_numerico(agency, 5)                                # Agência Mantenedora da Conta            053..057   9(005)
              header_batch << campo_texto(agency_cd, 1)                           # Dígito Verificador da Agência           058..058   X(001)
              header_batch << campo_numerico(account, 12)                              # Número da Conta Corrente                059..070   9(012)
              header_batch << campo_texto(account_cd, 1)                          # Dígito Verificador da Conta             071..071   X(001)
              header_batch << campo_texto(check_digit, 1)                         # Dígito Verificador da Agência/Conta     072..072   X(001)
              header_batch << campo_texto(company_payer, 30)                      # Nome da Empresa                         073..102   X(030)
              header_batch << campo_texto(batch.generic_message, 40)              # Informação 1 - Mensagem                 103..142   X(040)
              header_batch << campo_texto(address_street, 30)                     # Endereço                                143..172   X(030)
              header_batch << campo_numerico(address_number, 5)                        # Número                                  173..177   9(005)
              header_batch << campo_texto(address_complemnt, 15)                  # Complemento do Endereço                 178..192   X(015)
              header_batch << campo_texto(address_city, 20)                       # Cidade                                  193..212   X(020)
              header_batch << formata_cep(address_zip_code, :prefix)            # CEP                                     213..217   9(005)
              header_batch << formata_cep(address_zip_code, :suffix)            # Complemento do CEP                      218..220   9(003)
              header_batch << campo_texto(address_state, 2)                       # UF                                      221..222   X(002)
              header_batch << bloco_zerado(8)                                        # Filler                                  223..230   X(008)
              header_batch << campo_texto(batch.occurrence, 10)                   # Ocorrências para o Retorno              231..240   X(010)
              clear_line(header_batch)
            end


            # Build Segment A
            # Expects three params, a Register, Integer and Integer
            # Return [String]
            def builder_segment_a(register, number_batch, number_sequential_batch)
              segmento_a = ''                                                       # Descrição                               Posição    Tamanho
              segmento_a << codigo_banco                                               # Código do Banco                         001..003   9(003)
              segmento_a << counter_batch(number_batch)                             # Lote de Serviço                         004..007   9(004)
              segmento_a << '3'                                                     # Tipo de Registro                        008..008   9(001)
              segmento_a << campo_numerico(number_sequential_batch, 5)                 # Número Seqüencial do Registro no Lote   009..013   9(005)
              segmento_a << 'A'                                                     # Código Segmento do Registro Detalhe     014..014   X(001)
              segmento_a << register.kind_action                                    # Tipo de Movimento                       015..015   9(001)
              segmento_a << register.kind_action_instruction                        # Código da Instrução para Movimento      016..017   9(002)
              segmento_a << register.code_camera_compensation                       # Código Câmara Compensação               018..020   9(003)
              segmento_a << register.codigo_banco_payee                                # Código do Banco Favorecido              021..023   9(003)
              segmento_a << campo_numerico(register.agency_payee, 5)                   # Código da Agência Favorecido            024..028   9(005)
              segmento_a << campo_texto(register.agency_cd_payee, 1)              # Dígito Verificador da Agência           029..029   X(001)
              segmento_a << campo_numerico(register.account_payee, 12)                 # Conta Corrente do Favorecido            030..041   9(012)
              segmento_a << campo_texto(register.account_cd_payee, 1)             # Dígito Verificador da Conta             042..042   X(001)
              segmento_a << campo_texto(register.check_digit_payee, 1)            # Dígito Verificador da Agência/Conta     043..043   X(001)
              segmento_a << campo_texto(register.company_payee, 30)               # Nome do Favorecido                      044..073   X(030)
              segmento_a << campo_numerico(register.payment_number, 20)                # Nro. do Documento Cliente               074..093   X(020)
              segmento_a << formatar_datahora(register.payment_date, :date_long)          # Data do Pagamento                       094..101   9(008)
              segmento_a << register.kind_currency                                  # Tipo da Moeda                           102..104   X(003)
              segmento_a << bloco_zerado(15)                                          # Quantidade de Moeda                     105..119   9(010)V5
              segmento_a << formata_valor(register.payment_value, 15)                # Valor do Pagamento                      120..134   9(013)V2
              segmento_a << campo_texto(register.bank_number, 20)                 # Nro. do Documento Banco                 135..154   X(020)
              segmento_a << formatar_datahora(register.payment_date_happens, :date_long)  # Data Real do Pagamento (Retorno)        155..162   9(008)
              segmento_a << formata_valor(register.payment_value_original, 15)       # Valor Real do Pagamento                 163..177   9(013)V2
              segmento_a << campo_texto(register.specific_message, 40)            # Informação 2 - Mensagem                 178..217   X(040)
              segmento_a << register.finality                                       # Finalidade do DOC e TED                 218..219   X(002)
              segmento_a << campo_texto(register.reference_number, 10)            # Filler                                  220..229   X(010)
              segmento_a << register.notification_payee                             # Emissão de Aviso ao Favorecido          230..230   X(001)
              segmento_a << campo_texto(register.occurrence, 10)                  # Ocorrências para o Retorno              231..240   X(010)
              clear_line(segmento_a)
            end

            # Build Segment B
            # Expects three params, a Register, Integer and Integer
            # Return [String]
            def builder_segment_b(register, number_batch, number_sequential_batch)
              segmento_b = ''                                                       # Descrição                               Posição    Tamanho
              segmento_b << codigo_banco                                               # Código do Banco                         001..003   9(003)
              segmento_b << counter_batch(number_batch)                             # Lote de Serviço                         004..007   9(004)
              segmento_b << '3'                                                     # Tipo de Registro                        008..008   9(001)
              segmento_b << campo_numerico(number_sequential_batch, 5)                 # Número Seqüencial do Registro no Lote   009..013   9(005)
              segmento_b << 'B'                                                     # Código Segmento do Registro Detalhe     014..014   X(001)
              segmento_b << bloco_zerado(3)                                          # Filler                                  015..017   X(003)
              segmento_b << campo_texto(register.kind_document, 1)                   # Tipo de Inscrição do Favorecido         018..018   9(001)
              segmento_b << formata_documento(register.document_payee, 14)            # CNPJ/CPF do Favorecido                  019..032   9(014)
              segmento_b << campo_texto(register.address_street, 30)              # Logradouro do Favorecido                033..062   X(030)
              segmento_b << campo_numerico(register.address_number,5)                  # Número do Local do Favorecido           063..067   9(005)
              segmento_b << campo_texto(register.address_complemnt, 15)           # Complemento do Local Favorecido         068..082   X(015)
              segmento_b << campo_texto(register.address_neighborhood, 15)        # Bairro do Favorecido                    083..097   X(015)
              segmento_b << campo_texto(register.address_city, 20)                # Cidade do Favorecido                    098..117   X(020)
              segmento_b << formata_cep(register.address_zip_code, :full)       # CEP do Favorecido                       118..125   9(008)
              segmento_b << campo_texto(register.address_state, 2)                # Estado do Favorecido                    126..127   X(002)
              segmento_b << formatar_datahora(register.due_date, :date_long)              # Data de Vencimento                      128..135   9(008)
              segmento_b << formata_valor(register.value_document, 15)               # Valor do Documento                      136..150   9(013)V2
              segmento_b << formata_valor(register.value_rebate, 15)                 # Valor do Abatimento                     151..165   9(013)V2
              segmento_b << formata_valor(register.value_discount, 15)               # Valor do Desconto                       166..180   9(013)V2
              segmento_b << formata_valor(register.value_moratorium, 15)             # Valor da Mora                           181..195   9(013)V2
              segmento_b << formata_valor(register.value_mulct, 15)                  # Valor da Multa                          196..210   9(013)V2
              segmento_b << bloco_zerado(4)                                           # Horário de Envio de TED                 211..214   9(004)
              segmento_b << bloco_zerado(11)                                         # Filler                                  215..225   X(011)
              segmento_b << campo_numerico(register.code_historic, 4)                  # Código Histórico para Crédito           226..229   9(004)
              segmento_b << register.notification_payee                             # Emissão de Aviso ao Favorecido          230..230   9(001)
              segmento_b << campo_texto(register.occurrence, 10)                  # Ocorrências para o Retorno              231..240   X(010)
              clear_line(segmento_b)
            end

            # Build Segment Z
            # Expects three params, a Register, Integer and Integer
            # Return [String]
            def builder_segment_z(register, number_batch, number_sequential_batch)
              segmento_z = ''                                                       # Descrição                               Posição    Tamanho
              segmento_z << codigo_banco                                               # Código do Banco                         001..003   9(003)
              segmento_z << counter_batch(number_batch)                             # Lote de Serviço                         004..007   9(004)
              segmento_z << '3'                                                     # Tipo de Registro                        008..008   9(001)
              segmento_z << campo_numerico(number_sequential_batch, 5)                 # Número Seqüencial do Registro no Lote   009..013   9(005)
              segmento_z << 'Z'                                                     # Código Segmento no Registro Detalhe     014..014   X(001)
              segmento_z << campo_texto(register.authentication_payment, 64)      # Autenticação do Pagamento               015..078   X(064)
              segmento_z << campo_numerico(register.protocol_payment, 25)              # Protocolo do Pagamento                  079..103   X(025)
              segmento_z << bloco_zerado(127)                                        # Filler                                  104..230   X(127)
              segmento_z << campo_texto(register.occurrence, 10)                  # Ocorrências para o Retorno              231..240   X(010)
              clear_line(segmento_z)
            end

            # Build Trailer Batch
            # Expects two params, a Batch, Integer
            # Return [String]
            def builder_trailer_batch(batch, number_batch)
              trailer_batch = ''                                                    # Descrição                               Posição    Tamanho
              trailer_batch << codigo_banco                                            # Código do Banco                         001..003   9(003)
              trailer_batch << counter_batch(number_batch)                          # Lote de Serviço                         004..007   9(004)
              trailer_batch << '5'                                                  # Tipo de Registro                        008..008   9(001)
              trailer_batch << bloco_zerado(9)                                       # Filler                                  009..017   X(009)
              trailer_batch << counter_registers(batch.registers, 6)                # Quantidade de Registros do Lote         018..023   9(006)
              trailer_batch << registers_total_value(batch.registers, 18)           # Somatória dos Valores                   024..041   9(016)V2
              trailer_batch << bloco_zerado(18)                                       # Somatória Quantidade Moeda              042..059   9(013)V5
              trailer_batch << bloco_zerado(6)                                        # Número Aviso de Débito                  060..065   9(006)
              trailer_batch << bloco_zerado(165)                                     # Filler                                  066..230   X(165)
              trailer_batch << campo_texto(batch.occurrence, 10)                  # Ocorrências para o Retorno              231..240   X(010)
              clear_line(trailer_batch)
            end

            # Build Trailer File
            # Expects one params, a Batches
            # Return [String]
            def construir_trailer_arquivo(batches)
              trailer_arquivo = ''                                                  # Descrição                               Posição    Tamanho
              trailer_arquivo << codigo_banco                                          # Código do Banco                         001..003   9(003)
              trailer_arquivo << '9999'                                             # Lote de Serviço                         004..007   9(004)
              trailer_arquivo << '9'                                                # Tipo de Registro                        008..008   9(001)
              trailer_arquivo << bloco_zerado(9)                                     # Filler                                  009..017   X(009)
              trailer_arquivo << counter_batches(batches, 6)                        # Quantidade de lotes do arquivo          018..023   9(006)
              trailer_arquivo << counter_batches_registers(batches, 6)              # Quantidade de registros no arquivo      024..029   9(006)
              trailer_arquivo << bloco_zerado(211)                                   # Filler                                  030..240   X(211)
              clear_line(trailer_arquivo)
            end

            # Build Batch
            # Expects two params, Batch and Integer
            # Return [String]
            def builder_batch(batch, number_batch)
              # contador dos registros do lote
              number_sequential_batch = 0
              segments = []
              batch.registers.each do |register|
                register.validate!

                number_sequential_batch += 1
                segments << builder_segment_a(register, number_batch, number_sequential_batch)

                number_sequential_batch += 1
                segments << builder_segment_b(register, number_batch, number_sequential_batch)

                if register.authentication_payment && register.protocol_payment && register.validate_z!
                  number_sequential_batch += 1
                  segments << builder_segment_z(register, number_batch, number_sequential_batch)
                end
              end

              segments
            end

            # Build Batches
            # Expects one params, Batches
            # Return [String]
            def construir_lotes(batches)
              number_batch = 0
              batches_lines = []

              batches.each do |batch|
                batch.validate!

                number_batch += 1
                batches_lines << builder_header_batch(batch, number_batch)
                batches_lines << builder_batch(batch, number_batch)
                batches_lines << builder_trailer_batch(batch, number_batch)
              end

              batches_lines
            end
          end
        end
      end
    end
