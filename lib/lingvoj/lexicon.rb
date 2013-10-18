module Lingvoj
  class Lexicon

    attr_accessor :locale, :corpus, :missing

    def self.load(file_path)
      Lexicon.new.tap do |lexicon|
        data = YAML.load_file(File.expand_path(file_path))
        lexicon.locale = data.keys.first
        lexicon.corpus = data[lexicon.locale]
      end
    end

    def initialize
      @missing = {}
    end

    def [](value)
      corpus[value]
    end

    def corpus_at(key_chain)
      context = corpus
      key_chain.each do |key|
        context = context[key] rescue nil
      end
      context
    end

    def compare_to_base(other)
      other.corpus.keys.each do |key|
        compare_level(other, [key])
      end
      nil
    end

    def compare_level(other, key_chain)
      context = other.corpus_at(key_chain)
      if context.is_a?(Hash)
        context.keys.each do |key|
          compare_level(other, key_chain + [key])
        end
      else
        check_missing(other, key_chain)
      end
    end

    def check_missing(other, key_chain)
      unless corpus_at(key_chain)
        add_missing(key_chain, other.corpus_at(key_chain))
      end
    end

    def add_missing(key_chain, value)
      context = @missing
      key_chain[0..-2].each do |key|
        context[key] ||= {}
        context = context[key]
      end
      context[key_chain.last] = value
    end

    def write_report(path)
      puts "Writing #{locale} to #{path}"
      file_name = File.expand_path(path + locale + "-missing.yml")
      File.open(file_name, 'w') do |f|
        f.write(@missing.to_yaml)
      end
    end
  end
end