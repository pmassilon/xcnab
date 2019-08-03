# encoding: UTF-8
#
# Include helpers methods for life

class Object
  def present?
    !blank?
  end

  def presence
    self if present?
  end
end

class NilClass
  # +nil+ is blank:
  #
  #   nil.blank? # => true
  #
  # @return [true]
  def blank?
    true
  end
end

class FalseClass
  # +false+ is blank:
  #
  #   false.blank? # => true
  #
  # @return [true]
  def blank?
    true
  end
end

class TrueClass
  # +true+ is not blank:
  #
  #   true.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class Array
  # An array is blank if it's empty:
  #
  #   [].blank?      # => true
  #   [1,2,3].blank? # => false
  #
  # @return [true, false]
  alias_method :blank?, :empty?
end

class Hash
  # A hash is blank if it's empty:
  #
  #   {}.blank?                # => true
  #   { key: 'value' }.blank?  # => false
  #
  # @return [true, false]
  alias_method :blank?, :empty?
end

class Numeric #:nodoc:
  # No number is blank:
  #
  #   1.blank? # => false
  #   0.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class String #:nodoc:
  # No number is blank:
  #
  #   1.blank? # => false
  #   0.blank? # => false
  #
  # @return [false]
  def blank?
    empty?
  end
end

class Date #:nodoc:
  # No Time is blank:
  #
  #   Time.now.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class Time #:nodoc:
  # No Time is blank:
  #
  #   Time.now.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class DateTime #:nodoc:
  # No Time is blank:
  #
  #   Time.now.blank? # => false
  #
  # @return [false]
  def blank?
    false
  end
end

class File
  def mime_type
    `file --brief --mime-type #{self.path}`.strip
  end

  def charset
    `file --brief --mime #{self.path}`.split(';').second.split('=').second.strip
  end
end
