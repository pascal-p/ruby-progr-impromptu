module LcDoublet

  class Core
    
    Node = Struct.new(:value, :date, :f, :g) do
      def update(hopt) # (val, tnow, f, g=nil )
        self.value = hopt[:value] if hopt.has_key?(:value)
        self.date = hopt[:date] if hopt.has_key?(:date)
        self.f = hopt[:f] if hopt.has_key?(:f)
        self.g = hopt[:g] if hopt.has_key?(:g)
        #
        #puts " /////// self: #{self.inspect} // #{self.instance_variables.inspect} "        
        #self.instance_variables.each do |ivar|
        #  puts "[UPDATE] hopt: #{hopt.inspect} // ivar: #{ivar.inspect}"
        ##  var = ivar.to_s.sub('@', '')
        #  ivar = hopt[var.to_sym] if hopt.has_key?(var.to_sym)
        #end
        #
        self
      end
      
      def to_a
        [self.value, self.f, self.date]
      end
      
      def to_h
        {value: self.value, f: self.f, date: self.date}
      end      
    end
    
    def initialize(file)
      # @s_word = s_word
      # @t_word = t_word
      @@dict ||= LcDoublet::Utils.setup(file)
    end

    def solve(s_word, t_word)
      raise "Empty dictionary" if @@dict.empty?
      # sol = _bfs(s_word, t_word)
      sol = _a_star(s_word, t_word)
      # retracing the path
      _get_path(sol, t_word)
    end

    def get_sz
      @@dict.size
    end

    private
    def _generate(word)
      ary = []
      wlen = word.length
      0.upto(wlen - 1) do |ix|
        ('a'..'z').each do |c|
          next if c == word[ix]
          pword = word[0...ix] + c + word[ix+1..wlen]
          ary << pword if @@dict.include?(pword)
        end
      end
      ary
    end

    def _get_path(hsh, goal)
      ary = [ goal ]
      c_word = goal
      loop do
        break if hsh[c_word.to_sym].nil?
        c_word = hsh[c_word.to_sym]
        ary << c_word
      end
      # ary << start
      ary.reverse
    end

    def _bfs(start, goal) # start is s_word, goal is t_word
      visited = { start.to_sym => true }
      pred = {}
      q = Queue.new
      q.enq(start)
      #
      while q.size > 0
        c_word = q.deq
        break if c_word == goal
        #
        # puts " [2] ==> proc. #{c_word} // target: #{goal}"
        #        
        _generate(c_word).each do |wc| # word candidate
          # puts "\t==> proc. word cand. #{wc.inspect}"
          unless visited[wc.to_sym]
            pred[wc.to_sym] = c_word
            q.enq wc
            visited[wc.to_sym] = true
          end
        end
      end
      #
      pred
    end

    def _a_star(start, goal,
                g = ->(prev) {prev + 1},
                h = ->(cword) { LcDoublet::Utils.inter(goal.split(''), cword.split('')).size } # closure
               )
      closed_list = []
      # f = g + h
      g_start = 0
      h_start = LcDoublet::Utils::SIGNED_MAX # does not matter yet
      f_start = g_start + h_start            # == LcDoublet::Utils::SIGNED_MAX
      open_list   = [ Node.new(start, Time.now, f_start, g_start) ]  # node is a Struct
      node_path   = {}      
      #
      loop do
        cnode = _find_lowest_f_node(open_list)
        return node_path if cnode.value == goal
        ##
        _ = delete(open_list, cnode) # open_list.delete(cnode)
        closed_list << cnode # == cnode
        ##
        _generate(cnode.value).each do |c_word|   # current word to consider
          ##
          #puts " ===>>> proc. neighbor of #{cnode.value} ==> #{c_word}"
          ##
          next if _include?(closed_list, c_word)
          ##
          g_score = cnode.g + 1
          _node = open_list.find {|node| node.value == c_word}
          ##
          if _node.nil?  # Not yet in the open_list so add it as it needs to be considered
            _node = Node.new(c_word, Time.now, LcDoublet::Utils::SIGNED_MAX, g_score)
            open_list << _node
          elsif g_score >= _node.g
            next
          end
          ##
          node_path[c_word.to_sym] = cnode.value  # memorize the node
          _node.update(date: Time.now, f: g_score + h.call(c_word), g: g_score)
        end
      end
    end # a_star

    def _find_lowest_f_node(open_list)
      init_node = Node.new('_', Time.now, LcDoublet::Utils::SIGNED_MAX, 0)
      #
      n = open_list.inject(init_node) do |node, onode|
        # puts "\t#{node.inspect} // #{onode.inspect}"
        if onode.f < node.f
          node.update(value: onode.value, date: onode.date, f: onode.f)
          #
        elsif onode.f == node.f
          onode.date < node.date ?
            node.update(value: onode.value, date: onode.date, f: onode.f) :
            node
        else
          node
        end
      end
      #
      # puts("\t++++> n: #{n.inspect}")
      #
      n
    end

    # def _recons(node_path, key)
    #   _path = [ key ]      
    #   loop do
    #     break unless node_path.has_key?(key)
    #     key = node_path[key]
    #     _path << key
    #   end
    #   _path
    # end
    
    def _include?(list, value)
      return nil if list.empty?
      # puts " ........ list: #{list.inspect}"
      ##
      res = list.find {|node| node.value == value}
      # puts " ........ res: #{res.inspect}"
      res
    end

    def delete(list, node)
      ix = list.find_index {|n| n.value == node.value}
      list.delete_at(ix)
    end
  end

end
