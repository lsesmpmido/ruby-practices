# frozen_string_literal: true

1.upto(20) do |num|
  text = ''
  text += 'Fizz' if (num % 3).zero?
  text += 'Buzz' if (num % 5).zero?
  text = num unless (num % 3).zero? || (num % 5).zero?

  puts text
end
