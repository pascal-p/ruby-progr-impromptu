module LcDoublet

  class Core

    def initialize(file)
      @@dict ||= Utils::Dict.setup(file)
    end

    def solve(s_word, t_word)
      raise "Empty dictionary" if @@dict.empty?
      sol = _bfs(s_word, t_word)
      sol == [] ? [] : _get_path(sol, t_word)  # retracing the path
    end

    class << self
      def get_dict
        @@dict
      end

      def get_keys
        @@dict.content.keys.sort
      end

      def get_size
        @@dict.content.keys.size
      end
    end

    Q = Struct.new(:q, :visited, :pred) do
      def q_enq(val)
        self.q.enq val
      end

      def q_deq
        self.q.deq
      end

      def q_size
        self.q.size
      end

      def add_to(key, nval, oval=nil)
        if key.to_sym == :visited
          add_to_visited(nval)
        else
          add_to_pred(nval, oval) # kval == curr, oval -- prev.
        end
      end

      def add_to_visited(key)
        self.visited[key] = true
        self
      end

      def add_to_pred(curr, pred)
        self.pred[curr] = pred
        self
      end

      def visited?(key)
        self.visited[key]
      end

      def update(c_word, p_word)
        self.pred[c_word] = p_word
        self.q.enq c_word
        self.visited[c_word] = true
        self
      end
    end

    private
    def _generate(word)
      wlen = word.length
      ary = []
      (0...wlen).zip(word.split('')).each do |ix, char|
        ('a'..'z').reject {|_c| _c == char }.inject([]) do |_ary, _char|
          _pword = word[0...ix] + _char + word[ix+1..wlen]
          @@dict.include?(_pword) ? _ary << _pword : _ary
        end.flat_map {|a| ary << a}
      end
      ary.sort.uniq
    end

    def _get_path(hsh, goal)
      ary = [ goal ]
      c_word = goal
      loop do
        break if hsh[c_word].nil?
        c_word = hsh[c_word]
        ary << c_word
      end
      ary.reverse
    end

    def _bfs(s_word, e_word)
      #            q        visited           pred
      ds = Q.new(Queue.new, {s_word => true}, {})
      ds.q_enq(s_word)
      #
      while ds.q_size > 0
        c_word = ds.q_deq
        break if c_word == e_word
        _process(ds, c_word)
      end
      ds.q_size == 0 && c_word != e_word ? [] : ds.pred
    end

    def _process(ds, word)
      _generate(word).each do |c_word|
        ds.update(c_word, word) unless ds.visited?(c_word)
      end
    end

  end

end
