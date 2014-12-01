# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Nim < RegexLexer
      # This is pretty much a 1-1 port of the pygments NimrodLexer class
      desc "The Nim programming language (http://nim-lang.org/)"

      tag 'nim'
      aliases 'nimrod'
      filenames '*.nim'

      @@keywords = %w(
        addr as asm atomic bind block break case cast const continue
        converter discard distinct  do elif else end enum except export finally
        for from generic if import include interface iterator let macro method 
        mixin nil object of out proc ptr raise ref return static template try
        tuple type using var when while with without yield
      )

      @@opWords = %w(
        and or not xor shl shr div mod in notin is isnot
      )

      @@pseudoKeywords = %w(
        nil true false
      )

      @@types = %w(
       int int8 int16 int32 int64 float float32 float64 bool char range array
       seq set string
      ) 

      def self.underscorize(words)
        newWords = []
        new      = ""
        words.each do |word|
          word.chars.each do |char|
            new << (char + "_?")
          end
          newWords << new
          new = ""
        end
        return newWords.join("|")
      end

      state :chars do
        rule(/\\([\\abcefnrtvl"\']|x[a-fA-F0-9]{2}|[0-9]{1,3})/, Str::Escape)
        rule(/'/, Str::Char, :pop!)
        rule(/./, Str::Char)
      end

      state :strings do
        rule(/(?<!\$)\$(\d+|#|\w+)+/, Str::Interpol)
        rule(/[^\\\'"\$\n]+/,         Str)
        rule(/[\'"\\]/,               Str)
        rule(/\$/,                    Str)
      end

      state :dqs do
        rule(/\\([\\abcefnrtvl"\']|\n|x[a-fA-F0-9]{2}|[0-9]{1,3})/,
             Str::Escape)
        rule(/""/, Str, :pop!)
        mixin :strings
      end

      state :rdqs do
        rule(/"(?!")/, Str, :pop!)
        rule(/"/,      Str::Escape, :pop!)
        mixin :strings
      end

      state :tdqs do
        rule(/"""(?!")/, Str, :pop!)
        mixin :strings
        mixin :nl
      end

      state :funcname do
        rule(/((?![\d_])\w)(((?!_)\w)|(_(?!_)\w))*/, Name::Function, :pop!)
        rule(/`.+`/,                                 Name::Function, :pop!)
      end

      state :nl do
        rule(/\n/, Str)
      end

      state :root do
        rule(/##.*$/, Str::Doc)
        rule(/#.*$/,  Comment)
        rule(/\*|=|>|<|\+|-|\/|@|\$|~|&|%|\!|\?|\||\\|\[|\]/, Operator)
        rule(/\.\.|\.|,|\[\.|\.\]|{\.|\.}|\(\.|\.\)|{|}|\(|\)|:|\^|`|;/,
             Punctuation)

        # Strings
        rule(/(?:[\w]+)"/,Str, :rdqs)
        rule(/"""/,       Str, :tdqs)
        rule(/"/,         Str, :dqs)

        # Char
        rule(/'/, Str::Char, :chars)

        # Keywords
        rule(%r[(#{Nim.underscorize(@@opWords)})\b], Operator::Word)
        rule(/(p_?r_?o_?c_?\s)(?![\(\[\]])/, Keyword, :funcname)

      end

    end
  end
end
