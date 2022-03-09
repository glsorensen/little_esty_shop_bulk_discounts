module ApplicationHelper

  def monetize(number)
    if number == 0
      return "$0.00"
    end
    string_num = number.to_s.insert(-3, "")
    number_to_currency(string_num, precision: 2)
  end
end
