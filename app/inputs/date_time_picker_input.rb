class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group date datetimepicker') do
      template.concat @builder.text_field(attribute_name, input_html_options)
      template.concat span_table
    end
  end

  def input_html_options
    super.merge({ value: default_value, class: "text datetimepicker form-control",
                  data: { date_format: "YYYY-MM-DD hh:mm A" } })
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_table
    end
  end

  def icon_table
    "<span class='glyphicon glyphicon-calendar'></span>".html_safe
  end

  def input_html_options
    classes = (super[:class] || [])
    classes << :'form-control'
    options = super
    options.merge({class: classes})
    options.merge({readonly: false}) unless options[:readonly]
    options
  end
 end