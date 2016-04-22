# encoding: UTF-8

module LcDoublet

  # load dictionary into a hash (RAM)
  module Utils
    extend self
    
    def setup(file)
      @content = []
      load(file)
      self
    end

    def load(file)
      File.open(file, "r:utf-8") do |fh|
        fh.each_line do |line|
          _line = line.downcase.chomp
          next if _line.length < 2 || _line.length > 5
          @content << _line
        end
      end
      STDOUT.print ">> Loaded dict in memory - #{@content.size} entries" if $VERBOSE
      @content.sort!
      #
    rescue IOError => e
      @content = []  # reset
      STDERR.print "[!] intercepted #{e.message}"
      raise e
      #
    end

    def include?(word)
      @content.include?(word)
    end

    def empty?
      @content.size == 0
    end

    def size
      @content.size
    end

    # def to_hsh(word)
    #   word.split('').inject({}) {|h, l| h.has_key?(l.to_sym) ? h.merge({l.to_sym => h[l.to_sym] + 1}) : h.merge({l.to_sym => 1})}
    # end
    
    # def count(hsh)
    #   hsh.inject(0) {|s, (_, v)| s += v}
    # end

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
  
end
