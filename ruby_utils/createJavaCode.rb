#!/usr/bin/env ruby

#this was originally written to create a series of Java statements.
#since a method cannot have more than 65k of code, this was changed to write a more palatable file for the Java program to ingest
#and populate its own ArrayList
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
