class DateRangeInput < SimpleForm::Inputs::Base
  def input
    object = @builder.object
    html = @builder.text_field_tag(:date_range)
    html += @builder.hidden_field(attribute_name[0], input_html_options)
    html += @builder.hidden_field(attribute_name[1], input_html_options)
  end
end