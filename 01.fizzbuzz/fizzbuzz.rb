# frozen_string_literal: true

(1..20).each do |num|
  text = ''
  # 3の倍数のとき
  text += 'Fizz' if (num % 3).zero?
  # 5の倍数のとき
  text += 'Buzz' if (num % 5).zero?
  # 3の倍数でも5の倍数でもないとき
  text = num unless (num % 3).zero? || (num % 5).zero?

  puts text
end
