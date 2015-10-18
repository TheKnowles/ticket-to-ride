#!/usr/bin/env ruby
#todo add colors, tunnels, maps, etc
class Edge 
  attr_reader :name, :length
  attr_accessor :visited, :distance
  def initialize(name, length)
    @name = name
    @length = length
    @visited = false
    @distance = 999 #sufficient to represent infinity, longest route is 8
  end
  
  def to_s
    "[#{@name}, #{@length}]"
  end
end

class Board
  attr_reader :adj_list
  def initialize
    @error = false
    #puts "Loading European map [default]..."
    #puts "Building graph..."
    @adj_list = Hash.new
    build_graph
    verify_graph
  end
  
  def reset
    #puts "Resetting board"
    @adj_list.each do |entry|
      entry[1].each do |edge|
      edge.visited = false
      edge.distance = 999
     end
    end
  end
  
  def find_path(start, finish)
    if start == finish
      #puts "Shortest path cost from #{start} to #{finish}: 0"
      return
    end
    cur_node_edge_list = @adj_list[start]
    dest_node_edge_list = @adj_list[finish]
    if cur_node_edge_list == nil or dest_node_edge_list == nil
      puts "ERROR start or dest node not in graph"
      return
    end
    #puts "Calculating shortest route from #{start} to #{finish}..."
    cur_node = cur_node_edge_list[0]
    dest_node = dest_node_edge_list[0]
    
    cur_node.distance = 0
    start_node = cur_node
    while dest_node.visited == false
      next_node = nil
      cur_node_edge_list.each do |edge|
        if edge.name == cur_node.name then next end
        if edge.visited == false
          tenative_distance = cur_node.distance + edge.length.to_i
          if tenative_distance < edge.distance
            edge.distance = tenative_distance
            #update all nodes in the list, TODO make one master node list for ref
            @adj_list.each do |listing|
              listing[1].each do |item|
                if item.name == edge.name then item.distance = edge.distance end
              end
            end
          end #distance update
        end #visited == false
      end #cur_node edge list
      
      cur_node.visited = true
      #need to set visited true for each copy of this edge in the list
      #yes inefficient, todo fix later
      @adj_list.each do |node|
        node[1].each do |city|
          if city.name == cur_node.name
            city.visited = true
            city.distance = cur_node.distance
          end
         end
       end
              
       #determine next node, must be unvisited 
       #shortest distance for any edge connected to any visited node
       @adj_list.each do |node|
         if node[1][0].visited == true
           node[1].each do |city|
             if city.name == cur_node.name then next end
             if next_node == nil and not city.visited then next_node = city end
             if not city.visited and next_node != nil and city.distance < next_node.distance
               next_node = city
             end #if
           end #city do
         end #visited list include check
       end #node
       cur_node = next_node
       if cur_node == nil then break end #we hit the destination
       cur_node_edge_list = @adj_list[cur_node.name]
    end #while dest.visited == false
    
    #puts "Shortest path cost from #{start} to #{finish}: #{dest_node.distance}"
    #start at dest and work backwards
    temp = dest_node
    path = []
    path << temp
    while temp.name != start_node.name
      dest_node_edge_list.each do |edge|
        #don't check origin node
        if edge.name == temp.name then next end
        #clever me: find the shortest node by subtracting the edge length
        #from the total distance calculated for the node we're looking at
        #it should match the node that is in the shortest path
        if ((temp.distance - edge.length.to_i) == edge.distance)
          temp = edge 
        end
      end
      dest_node_edge_list = @adj_list[temp.name]
      path << temp
    end
    path.reverse!
    puts path
    puts
  end #find_path
  
 def print_graph
    @adj_list.each do |x|
      puts "#{x[0]}:   \t#{x[1]}"
    end #do
  end #print_graph
    
private
 
  def build_graph
    city_file = File.new("cities.distances")
    city_file.readlines.each do |line|
      contents = line.split
      #odd: origin city + [destinations+length...]
      if (contents.size % 2 == 0) then puts "Should be odd -  Error in file" end
      @adj_list[contents[0]] = []
      #add the node itself as the first element in the edge map
      @adj_list[contents[0]] << Edge.new(contents[0],0)
      i = 1
      while i <= (contents.size-2)
        @adj_list[contents[0]] << Edge.new(contents[i], contents[i+1]) #make these Edge objects
        i = i + 2
      end
    end
  end #build_graph
  
  def verify_graph
    #verify that there are no spelling errors or such with the data set
    #edges that do not exist
    @adj_list.each do |origin|
      origin[1].each do |edge|
        if @adj_list[edge.name] == nil
          @error = true
         puts "ERROR in data set: #{origin[0]}: #{edge.name} check spelling?"
        end
      end
    end
  end #verify graph 
end #Board


test = Board.new
#misc test paths
#test.find_path("Zurich", "Edinburgh")
#test.reset
#test.find_path("Cadiz", "Pamplona")
#test.reset
#test.find_path("Munchen", "Smolensk")
#test.reset
#test.find_path("Zurich", "Paris")
#test.reset
#test.find_path("Paris", "Paris")
#test.reset
#test.find_path("Brest", "Petrograd")
#test.reset
#test.find_path("Angora", "Petrograd")
#test.reset
#test.find_path("Lisboa", "Erzurum")
#test.reset

start = Time.now
#do every combination test
test.adj_list.each do |node|
  test.adj_list.each do |other|
    test.find_path(node[0],other[0])
    test.reset  
  end
end
puts "Executed all permutations in #{Time.now - start} seconds..."

