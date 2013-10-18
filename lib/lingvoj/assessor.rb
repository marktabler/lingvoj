module Lingvoj
  class Assessor

    BASE_LOCALE = "en"

    def self.run(project_path)
      new.run(project_path)
    end

    def run(project_path)
      locale_path = File.join(project_path, "config/locales/")
      load_lexicons(locale_path)
      find_missing_translations
      write_reports(locale_path)
    end

    def load_lexicons(locale_path)
      @lexicons = []
      Dir.glob(File.join(locale_path, "**/*.yml")).each do |locale_file|
        lexicon = Lexicon.load(locale_file)
        if lexicon.locale == BASE_LOCALE
          @base_lexicon = lexicon
        else
          @lexicons << lexicon
        end
      end
    end

    def find_missing_translations
      @lexicons.each do |lexicon|
        lexicon.compare_to_base(@base_lexicon)
      end
    end

    def write_reports(locale_path)
      @lexicons.each do |lexicon|
        lexicon.write_report(locale_path)
      end
    end

  end
end