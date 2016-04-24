require 'spec_helper'

module LcDoublet

  RSpec.configure do |config|
    #
    @@expr = [
      {
        s_word: 'man',
       t_word: 'god',
       trans: [
                ["man", "gan", "gad", "god"],
                # ["man", "mon", "mod", "god"]
              ]
      },
      {
        s_word: 'milk',
       t_word: 'wine',
       trans: [
                ["milk", "mile", "mine", "wine"]
#                ["milk", "mink", "wink", "wine"],
              ]
      },
      {
        s_word: 'head',
       t_word: 'tail',
       trans: [
                ["head", "heal", "heil", "hail", "tail"]
#                ["head", "tead", "teal", "taal", "tail"]
#                ["head", "read", "real", "reil", "rail", "tail"],
#                ["head", "heal", "teal", "tell", "tall", "tail"]
              ]
      },
      {
        s_word: 'cold',
         t_word: 'warm',
       trans: [
                ["cold", "cord", "card", "ward", "warm"]
#                ["cold", "wold", "wald", "ward", "warm"]
#                ["cold", "wold", "word", "ward", "warm"],
#                ['cold', 'cord', 'card', 'ward', 'warm' ],
              ]
      },
      {
        s_word: 'ape',
       t_word: 'man',
       trans: [
                ["ape", "abe", "aba", "aaa", "maa", "man"]
#                ["ape", "ope", "ops", "oas", "mas", "man"]
#                [ 'ape', 'apt', 'opt', 'oat', 'mat', 'man' ],
              ]
      },
      {
        s_word: 'door',
       t_word: 'lock',
       trans: [
                ["door", "dook", "dock", "lock"]
#                ["door", "loor", "look", "lock"]
#                ["door", "boor", "book", "look", "lock"],
              ]
      },
      {
        s_word: 'sleep',
       t_word: 'dream',
       trans: [
                ["sleep", "bleep", "bleed", "breed", "bread", "bream", "dream"]
#                ["sleep", "bleep", "bleed", "breed", "dreed", "dread", "dream"]
#                [ 'sleep', 'bleep', 'bleed', 'breed', 'bread', 'dread', 'dream'],
              ]
            },

      {
        s_word: 'cat',
       t_word: 'cct',
        trans: [ [] ],
      },
      {
        s_word:  'word',
       t_word: 'gene',
       trans: [
                ["word", "wore", "gore", "gere", "gene"]
#                ['word', 'wore', 'gore', 'gone', 'gene']
              ]
      }

    ]

    config.before(:all) do
      file = "./resources/wordlist.txt"
      @lc_doublet = with_timing_do("Load dictionary into memory") { LcDoublet::Core.new(file) }
    end
  end

  RSpec.describe LcDoublet do

    it 'has a version number' do
      expect(LcDoublet::VERSION).not_to be nil
    end

    context '# breadth first search context' do
      @@expr.each do |hsh|
        s_word, t_word = hsh[:s_word], hsh[:t_word]

        it "generates a word list for #{s_word}" do
          wl = @lc_doublet.send(:_generate, s_word)
          STDOUT.puts "\tword_List(#{s_word}): #{wl.inspect}" if $VERBOSE
          #
          expect(wl.size).to be > 0
          ## generated words should differ from start word only by one character
          ## => double letter will count only for 1, though! SO WE NEED OUR own intersection
          a = s_word.split('')
          asz = a.size - 1
          wl.each {|_w| expect(Utils::Dict.inter(a, _w.split('')).size).to eq(asz)}
        end

        it "from #{s_word} to #{t_word}" do
          sol = with_timing_do("Lookup for the shortest transition between #{s_word} and #{t_word}") { @lc_doublet.solve(s_word, t_word) }
          STDOUT.puts "\t (actual)   transition: #{sol.inspect}"
          STDOUT.puts "\t (expected) transition: #{sol.inspect}"
          expect(sol).to eq(hsh[:trans].first) # expect(sol).to satisfy {|a| hsh[:trans].include?(a)}
        end
      end

    end # context
  end

end


private

def with_timing_do(msg = "")
  start = Time.now
  STDOUT.puts("[+] #{msg} - started_at: #{start.strftime('%Y-%m-%d %H:%M:%S')}")
  res = yield
  stop  = Time.now
  diff  = stop.to_i - start.to_i
  STDOUT.puts("[+] #{msg} - ended_at:   #{stop.strftime('%Y-%m-%d %H:%M:%S')} - took #{diff} sec.")
  res
end
