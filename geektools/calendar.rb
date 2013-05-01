#
#
#
#  HEY EVERYONE, THERE IS A NEWER VERSION OF THIS SCRIPT ALONG WITH A FEW OTHERS
#  CHECK THEM OUT HERE - http://github.com/rjorgenson/geeklet.scripts
#
#
#

#!/usr/bin/env ruby
#
# Author: Robert Jorgenson
# Author email: rjorgenson@gmail.com

require 'Date'

class GeekletCalendar
  COLOR = "\e[32m"
  COLOR_STRING = "=="
  SEPARATOR_STRING_A = "  "
  SEPARATOR_STRING_B = "=="
  END_COLOR = "\e[0m"
  ABBR_DAYNAMES = {0, 'Su', 1, 'Mo', 2, 'Tu', 3, 'We', 4, 'Th', 5, 'Fr', 6, 'Sa'}
  
  def days_in_month(year, month)
    return (Date.new(year, 12, 31) << (12 - month)).day
  end
  
  def day_in_month(year, month, day)
    return Date.new(year, month, day).wday
  end
  
  def build_day_array(year, month)
    day_array = Array.new
    for d in (1..self.days_in_month(year, month))
      day_array[d] = GeekletCalendar::ABBR_DAYNAMES[self.day_in_month(year, month, d)]
    end
    day_array.shift
    return day_array * GeekletCalendar::SEPARATOR_STRING_A
  end
  
  def build_separator(year, month)
    separator = Array.new
    for d in (1..self.days_in_month(year, month))
      if year == Time.now.year && month == Time.now.month && d == Time.now.day then
        separator[d] = GeekletCalendar::COLOR + GeekletCalendar::COLOR_STRING + GeekletCalendar::END_COLOR
      else
        separator[d] = GeekletCalendar::SEPARATOR_STRING_B
      end
    end
    separator.shift
    return separator * GeekletCalendar::SEPARATOR_STRING_B
  end
  
  def build_date_array(year, month)
    date_array = Array.new
    for d in (1..self.days_in_month(year, month))
      date_array[d] = d
    end
    date_array.shift
    date_array.each do |d|
      if d < 10 then
        date_array[(d -1)] = "0#{d}"
      end
      #if year == Time.now.year && month == Time.now.month && date_array[(d-1)] == Time.now.day then
      #  date_array[(d-1)] = "\e[32m#{date_array[(d-1)]}\e[0m"
      #end 
    end
    return date_array * GeekletCalendar::SEPARATOR_STRING_A
  end
  
end

cal = GeekletCalendar.new

month = Time.now.month
year = Time.now.year

puts cal.build_day_array(year, month)
#puts cal.build_separator(year, month)
puts cal.build_date_array(Time.now.year, month)