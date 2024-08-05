# frozen_string_literal: true

1.upto(20) do |num|
  text = ''
  text += 'Fizz' if (num % 3).zero?
  text += 'Buzz' if (num % 5).zero?
  text = num if text.empty?

  puts text
end
