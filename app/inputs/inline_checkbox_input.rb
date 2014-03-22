class InlineCheckboxInput < SimpleForm::Inputs::Base
  def input
    out = ''
    out << @builder.hidden_field(attribute_name, value: 0).html_safe
    out << "<label>"
    out << @builder.check_box(attribute_name, {}, 1, nil)
    out << "#{options[:label]}</label>"
    out
  end
end