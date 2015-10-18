#!/usr/bin/env ruby


input = File.open(ARGV[0]).read

routes = input.split("\n\n")
routes.each do |route|
  city = route.split("\n")
  chain = ""
  chain_arr = []
  city.each do |line|
    line.gsub!("[", "")
    line.gsub!("]", "")
    line.gsub!(" ", "")
    contents = line.split(",")
    chain << "\"" << contents[0] << "\""
    chain_arr << contents[0]
  end
  #str = "routes_.put(\"#{chain_arr[0]}-#{chain_arr[-1]}\", new ArrayList<String>(Arrays.asList(#{chain_arr})));".gsub("[", "").gsub("]","")
  str = "#{chain_arr[0]}-#{chain_arr[-1]}==#{chain_arr}".gsub("[", "").gsub("]","").gsub("\"", "").gsub(",", "")
  puts str
end
