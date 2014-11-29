# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Nim < RegexLexer
      desc "The Nim programming language (http://nim-lang.org/)"

      tag 'nim'
      aliases 'nimrod'
      filenames '*.nim'

      keywords = %w(
        addr as asm atomic bind block break case cast const continue
        converter discard distinct  do elif else end enum except export finally
        for from generic if import include interface iterator let macro method 
        mixin nil object of out proc ptr raise ref return static template try
        tuple type using var when while with without yield
      )

      opWords = %w(
        and or not xor shl shr div mod in notin is isnot
      )

      pseudoKeywords = %w(
        nil true false
      )

      types = %w(
       int int8 int16 int32 int64 float float32 float64 bool char range array
       seq set string
      ) 

      state :root do
        rule(/##.*$/, Str::Doc)
        rule(/#.*$/,  Comment)
      end

    end
  end
end
