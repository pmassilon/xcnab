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

  # Converts a string to a Date value.
  # "01/02/2020" # => #<Date: 2020-02-01 ((2458881j,0s,0n),+0s,2299161j)>
  def to_date
    ::Date.parse(self, false) unless blank?
  end

  # Converts a string to a Date value.
  # "01/02/2020 10:30" # => #<Date: 2020-02-01 ((2458881j,0s,0n),+0s,2299161j)>

  def to_datetime
    ::DateTime.parse(self, false) unless blank?
  end

  # Returns the string, first removing all whitespace on both ends of the string, and then changing remaining consecutive whitespace groups into one space each.
  #   str = " foo   bar    \n   \t   boo"
  #   str.squish! # => "foo bar boo"
  #   str # => "foo bar boo"
  # @return [String]
  def squish!
    gsub!(/[[:space:]]+/, " ")
    strip!
    self
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
