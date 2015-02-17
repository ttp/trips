class DateRangeInput < SimpleForm::Inputs::Base
  def input
    @builder.text_field_tag(:date_range) +
      @builder.hidden_field(attribute_name[0], input_html_options) +
      @builder.hidden_field(attribute_name[1], input_html_options)
  end
end
