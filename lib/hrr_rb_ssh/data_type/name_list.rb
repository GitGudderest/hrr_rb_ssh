# coding: utf-8
# vim: et ts=2 sw=2

module HrrRbSsh
  class DataType
    class NameList < DataType
      def self.encode arg
        unless arg.kind_of? Array
          raise ArgumentError, "must be a kind of Array, but got #{arg.inspect}"
        end
        unless (arg.map(&:class) - [::String]).empty?
          raise ArgumentError, "must be with all elements of String, but got #{arg.inspect}"
        end
        joined_arg = arg.join(',')
        if joined_arg.length > 0xffff_ffff
          raise ArgumentError, "must be shorter than or equal to #{0xffff_ffff}, but got length #{joined_arg.length}"
        end
        [joined_arg.length, joined_arg].pack("Na*")
      end

      def self.decode io
        length = io.read(4).unpack("N")[0]
        io.read(length).unpack("a*")[0].split(',')
      end
    end
  end
end