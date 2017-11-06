import java.awt.Color;
import java.util.Map;
import java.util.Collections;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.Set;
import java.util.HashSet;
import java.util.Collection;

import controlP5.*;


class Map {
  //pub to make pulling from dropdown box events easier
  public HashMap<String, ArrayList<String>> routes_;
  public HashMap<String, City> cityObjMap_;
  private List<String> cities_;
  
  Map(){
    routes_ = new HashMap<String, ArrayList<String>>();
    Set citySet = new HashSet<String>();
    String[] lines = loadStrings("routes");
    for(String line : lines){
      String[] contents = line.split("==");
      String[] route = contents[1].split(" ");
      routes_.put(contents[0], new ArrayList<String>(Arrays.asList(route)));
      String[] cities = contents[0].split("-");
      citySet.add(cities[0]);
    }
    cities_ = new ArrayList<String>(citySet);
    Collections.sort(cities_);
    
    //load x,y coords for city obj creation
    lines = loadStrings("city_coords");
    cityObjMap_ = new HashMap<String, City>();
    for(String line : lines){
      String[] contents = line.split("==");
      String[] coords = contents[1].split(" ");
      if (coords[0].equals("x")){
        continue;
      }
      City city = new City(contents[0], Integer.parseInt(coords[0]), Integer.parseInt(coords[1]));
      cityObjMap_.put(contents[0], city);
    }
  }//constructor
  
  public void printRoutes(){
    for(Entry route : routes_.entrySet()){
      System.out.println(route.getKey());
    }
  }
  
  public List<String>     getCities()   { return cities_;}
  public Collection<City> getCityObjs() { return cityObjMap_.values();} 
}//map class


class City {
  private String name_;
  private int x_;
  private int y_;
  
  City(String name, int x, int y) {
    name_ = name;
    x_ = x;
    y_ = y;
  }
  
  public String getName()      {return name_;}
  public int getX()            {return x_;};
  public int getY()            {return y_;};
}


PFont f;
PImage img;
Map map;

ControlP5 p5;
DropdownList startCity, endCity;

City activeStart, activeEnd;
boolean displayNames;

void setup() {
  size(1280, 1024);
  f = createFont("Arial Bold", 14); 
  p5 = new ControlP5(this);
  img = loadImage("europe.png");
  map = new Map();
  startCity = p5.addDropdownList("Start City").setPosition(100,100).setOpen(false).setBarHeight(30).setItemHeight(30);
  endCity = p5.addDropdownList("End City").setPosition(200, 100).setOpen(false).setBarHeight(30).setItemHeight(30);
  p5.addButton("Toggle City Names").setPosition(300,100).setSize(100,50);
  startCity.addItems(map.getCities());
  endCity.addItems(map.getCities());
  
  //pinkish
  startCity.setColorActive(color(255, 128, 255));
  startCity.setColorActive(color(255, 128, 255));
  
  activeStart = null;
  activeEnd = null;
  displayNames = false;
}

//TODO clean up event detection
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    if(theEvent.getController().toString().equals("Start City [DropdownList]")){
      activeStart = map.cityObjMap_.get(map.getCities().get((int)(theEvent.getController().getValue())));
    }
    else if(theEvent.getController().toString().equals("End City [DropdownList]")){
      activeEnd = map.cityObjMap_.get(map.getCities().get((int)(theEvent.getController().getValue())));
    }
    else if(theEvent.getController().toString().equals("Toggle City Names [Button] [ 1.0 ] Button (class controlP5.Controller)")){
      displayNames = !displayNames;
    }
  }
}

void draw() {
  //map background
  image(img, 0, 0);

  //city display
  fill(Color.GREEN.getRGB());
  for(City city : map.getCityObjs()){
    boolean flagged = false;
    if(activeStart != null && city.getName().equals(activeStart.getName())){
      fill(Color.ORANGE.getRGB());
      ellipse(city.getX(), city.getY(), 10, 10);
      flagged = true;
    }
    if (activeEnd != null && city.getName().equals(activeEnd.getName())){
      fill(Color.RED.getRGB());
      ellipse(city.getX(), city.getY(), 10, 10);
      flagged = true;
    }
    
   if(!flagged){
      fill(Color.GREEN.getRGB());
      ellipse(city.getX(), city.getY(), 10, 10);
    }
    
    if(displayNames){
      fill(Color.BLACK.getRGB());
      textFont(f);
      text(city.getName(), city.getX(), city.getY() + 20);
    }
    
    //draw path, pull route based on start-end name, draw point to point
    if(activeStart != null && activeEnd != null && (!activeStart.getName().equals(activeEnd.getName()))){
      String routePath = activeStart.getName() + "-" + activeEnd.getName();
      List<String> route = map.routes_.get(routePath);
      City curStep = map.cityObjMap_.get(route.get(0));
      for(int i = 1; i < route.size(); i++){
        City step = map.cityObjMap_.get(route.get(i));
        line(curStep.getX(), curStep.getY(), step.getX(), step.getY());
        curStep = step;
      }
    }
  }
}//end draw