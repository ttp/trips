module Translatable
  def translation(field_name)
    return self.send(field_name).to_s if self.send(field_name).present?
    if self.send(field_name).translation[I18n.default_locale].present?
      self.send(field_name).translation[I18n.default_locale]
    else
      self.send(field_name).any
    end.to_s
  end

  def all_translations(field_name)
    I18n.available_locales.inject({}) do |result, locale|
      result[locale] = if self.send(field_name).translation[locale].present?
                         self.send(field_name).translation[locale]
                       elsif self.send(field_name).translation[I18n.default_locale].present?
                         self.send(field_name).translation[I18n.default_locale]
                       else
                         self.send(field_name).any
                       end.to_s
      result
    end
  end
end
