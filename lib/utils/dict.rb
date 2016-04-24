# encoding: UTF-8

module Utils

  # load dictionary into a hash (RAM)
  module Dict
    extend self

    attr_reader :content

    def setup(file)
      @content = {}
      load_(file)
      self
    end

    def load_(file)
      File.open(file, "r:ISO-8859-15:UTF-8") do |fh|
        fh.each_line do |line|
          word = line.chomp
          next if word.length < 2 || word.length > 5 ||
                  word =~ /'/ ||
                  word =~ /[^abcdefghijklmnopqrstuvwxyz]+/i
          @content.merge!(word.downcase => 1)
        end
      end
      STDOUT.print ">> Loaded dict in memory - #{@content.keys.size} entries\n" if $VERBOSE
    #
    rescue IOError => e
      @content = {}  # reset
      STDERR.print "[!] intercepted #{e.message}"
      raise e
      #
    end

    def include?(word)
      @content.has_key?(word)
    end

    def empty?
      @content.keys.size == 0
    end

    def size
      @content.keys.size
    end

    ##
    def inter(a, b)
      ca = a.clone             # shallow copy
      b.inject([]) do |r, k|
        if ca.include?(k)
          s, x = ca.size, ca.delete(k)
          ns = ca.size
          ca << x unless s - 1 == ns
          r << x
        else
          r
        end
      end
    end

    ##
    def _calc
      machine_bytes = ['foo'].pack('p').size
      8 * machine_bytes # == machine_bits
    end

    SIGNED_MAX = 2 ** (_calc - 2) - 1 # SIGNED_MAX(Fixnum), SIGNED_MAX + 1(Bignum)
    SIGNED_MIN = -SIGNED_MAX - 1

    def const_missing(const_name)
      if const_name =~ /^MAX$|^MIN$/
        STDOUT.print("WARNING did you mean SIGNED_#{const_name}?\n")
        self.const_get "SIGNED_#{const_name}"
      else
        raise NameError, "uninitialized constant #{self}::#{const_name}"
      end
    end

  end # end of Utils

end

# module FixnumRefinement

#   def _calc
#     machine_bytes = ['foo'].pack('p').size
#     8 * machine_bytes # == machine_bits
#   end

#   refine Fixnum do

#     SIGNED_MAX = 2 ** (_calc - 2) - 1 # SIGNED_MAX(Fixnum), SIGNED_MAX + 1(Bignum)
#     SIGNED_MIN = -SIGNED_MAX - 1

#     def const_missing(const_name)
#       if const_name =~ /^MAX$|^MIN$/
#         STDOUT.print("WARNING did you mean SIGNED_#{const_name}?\n")
#         self.const_get "SIGNED_#{const_name}"
#       else
#         # raise NameError, "uninitialized constant #{self}::#{const_name}"
#         super
#       end
#     end

#   end

# end # end FixnumRefinement
