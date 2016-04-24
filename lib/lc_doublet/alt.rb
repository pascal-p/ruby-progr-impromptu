module LcDoublet

  class Alt < Core

    Node = Struct.new(:value, :date, :f, :g) do
      def update(hopt) # (val, tnow, f, g=nil )
        self.value = hopt[:value] if hopt.has_key?(:value)
        self.date = hopt[:date] if hopt.has_key?(:date)
        self.f = hopt[:f] if hopt.has_key?(:f)
        self.g = hopt[:g] if hopt.has_key?(:g)
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

    def solve(s_word, t_word)
      raise "Empty dictionary" if @@dict.empty?
      sol = _a_star(s_word, t_word)
      # retracing the path
      _get_path(sol, t_word)
    end

    private
    def _a_star(start, goal,
                g = ->(prev) {prev + 1},
                h = ->(cword) { Utils::Dict.inter(goal.split(''), cword.split('')).size } # closure
               )
      closed_list = []
      # f = g + h
      g_start = 0
      h_start = Utils::Dict::SIGNED_MAX # does not matter yet
      f_start = g_start + h_start            # == Utils::Dict::SIGNED_MAX
      open_list = [ Node.new(start, Time.now, f_start, g_start) ]  # node is a Struct
      node_path = {}
      #
      loop do
        cnode = _find_lowest_f_node(open_list)
        return node_path if cnode.value == goal
        ##
        _ = delete(open_list, cnode)
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
            _node = Node.new(c_word, Time.now, Utils::Dict::SIGNED_MAX, g_score)
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
      init_node = Node.new('_', Time.now, Utils::Dict::SIGNED_MAX, 0)
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
      n
    end

    def _include?(list, value)
      return nil if list.empty?
      ##
      list.find {|node| node.value == value}
    end

    def delete(list, node)
      ix = list.find_index {|n| n.value == node.value}
      list.delete_at(ix)
    end

  end

end
