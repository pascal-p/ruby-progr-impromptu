require 'spec_helper'

module LcDoublet
  
  RSpec.configure do |config|
    #
    @@expr = [
      # {
      #   s_word: 'man',
      #  t_word: 'god',
      #  trans: [
      #           ["man", "mon", "mod", "god"]
      #         ]
      # },
      # {
      #   s_word: 'milk',
      #  t_word: 'wine',
      #  trans: [
      #           ["milk", "mink", "wink", "wine"],
      #         ]
      # },      
      # {
      #   s_word: 'head',
      #  t_word: 'tail',
      #  trans: [
      #           ["head", "read", "real", "reil", "rail", "tail"],
      #           ["head", "heal", "teal", "tell", "tall", "tail"]
      #         ]
      # },
      # {
      #   s_word: 'cold',
      #    t_word: 'warm',
      #  trans: [
      #           ["cold", "wold", "word", "ward", "warm"],
      #           ['cold', 'cord', 'card', 'ward', 'warm' ],
      #         ]
      # },
      {
        s_word: 'ape',
       t_word: 'man',
       trans: [
                [ 'ape', 'apt', 'opt', 'oat', 'mat', 'man' ],
              ]
      },
      {
        s_word: 'door',
       t_word: 'lock',
       trans: [
                ["door", "boor", "book", "look", "lock"],
              ]
      },      
      # {
      #   s_word: 'sleep',
      #  t_word: 'dream',
      #  trans: [
      #           [ 'sleep', 'bleep', 'bleed', 'breed', 'bread', 'dread', 'dream'],
      #         ]
      # },
      # {
      #   s_word:  'word',
      #  t_word: 'gene',
      #  trans: [
      #           ['word', 'wore', 'gore', 'gone', 'gene']
      #         ]
      # }
    ]
    
    config.before(:all) do
      file = "./resources/US.dic"
      @lc_doublet = LcDoublet::Core.new(file)
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
          STDOUT.puts "\tword_List(#{s_word}): #{wl.inspect}"
          #
          expect(wl.size).to be > 0
          ## generated words should differ from start word only by one character
          ## => double letter will count only for 1, though! SO WE NEED OUR own intersection
          a = s_word.split('')
          asz = a.size - 1
          wl.each {|_w| expect(LcDoublet::Utils.inter(a, _w.split('')).size).to eq(asz)}
        end
        
        it "from #{s_word} to #{t_word}" do
          sol = @lc_doublet.solve(s_word, t_word)
          STDOUT.puts "\ttransition: #{sol.inspect}"
          # expect(sol).to eq(hsh[:trans])
          expect(sol).to satisfy {|a| hsh[:trans].include?(a)}
        end        
      end
      
    end # context    
  end
  
end

