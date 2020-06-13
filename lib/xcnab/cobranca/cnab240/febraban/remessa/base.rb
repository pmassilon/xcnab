# encoding: UTF-8
#
module Xcnab
  module Cobranca
    module Remessa
      class Base
        include Xcnab::Arquivo

        def initialize(campos = {})
          campos.each do |campo, valor|
            send "#{campo}=", valor
          end

          yield self if block_given?
        end
      end
    end
  end
end
