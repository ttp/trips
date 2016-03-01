class Locale
  @locales = { uk: { code: 'uk', abbr: 'Укр', name: 'Українська' },
               en: { code: 'en', abbr: 'Eng', name: 'English' },
               ru: { code: 'ru', abbr: 'Рус', name: 'Русский' } }

  class << self
    attr_reader :locales
  end
end
