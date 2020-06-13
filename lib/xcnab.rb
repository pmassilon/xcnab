# encoding: UTF-8
#
require 'byebug'
require 'unidecoder'

require "xcnab/version"
require "xcnab/arquivo"
require "xcnab/util"
require "helpers"

require 'logger'

module Xcnab
  include Xcnab::Util

  class Erro < StandardError; end

  class Log
    LOG = Logger.new(STDOUT)
    LOG.level = Logger::WARN

    class << self
      # :debug < :info < :warn < :error < :fatal < :unknown

      def dev(mensagem)
        # DEBUG     Low-level information for developers.
        LOG.debug(mensagem)
      end

      def info(mensagem)
        # INFO      Generic (useful) information about system operation.
        LOG.info(mensagem)
      end

      def alerta(mensagem)
        # WARN      A warning.
        LOG.warn(mensagem)
      end

      def erro(mensagem)
        # ERROR     A handleable error condition.
        LOG.error(mensagem)
      end

      def fatal(mensagem)
        # FATAL     An unhandleable error that results in a program crash.
        LOG.fatal(mensagem)
      end

      def desconhecido(mensagem)
        # UNKNOWN   An unknown message that should always be logged.
        LOG.unknown(mensagem)
      end
    end
  end
  # Your code goes here...

  # Módulo para classes de Cobranças
  module Cobranca
    module Remessa
      autoload :Base,           'xcnab/cobranca/remessa/base'
      module Cnab240
        module Santander
          autoload :Base,       'xcnab/cobranca/remessa/cnab240/santander/base'
        end
      end
    end
  end
end
