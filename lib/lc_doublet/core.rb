module LcDoublet

  class Core

    def initialize(file)
      @@dict ||= Utils::Dict.setup(file)
    end

    def solve(s_word, t_word)
      raise "Empty dictionary" if @@dict.empty?
      sol = _bfs(s_word, t_word)
      # retracing the path
      sol == [] ? [] : _get_path(sol, t_word)
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
      q, pred = Queue.new, {}
      q.enq(start)
      #
      while q.size > 0
        c_word = q.deq
        break if c_word == goal
        #
        _generate(c_word).each do |wc| # word candidate
          unless visited[wc.to_sym]
            pred[wc.to_sym] = c_word
            q.enq wc
            visited[wc.to_sym] = true
          end
        end
      end
      #
      if q.size == 0 && c_word != goal
        []
      else
        pred
      end
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
