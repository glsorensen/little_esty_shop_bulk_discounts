module ApplicationHelper

  def monetize(number)
    string_num = number.to_s.insert(-3, "")
    number_to_currency(string_num, precision: 2)
  end
end
