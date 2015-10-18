import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.JPanel;


public class EuropeMap extends JFrame{

	private HashMap<String, ArrayList<String>> routes_;
	private ArrayList<City> cities;
	private BufferedImage europeMap;
	private JPanel surface;
	
	//TODO put in city array, will require some trial and error for x,y coords
	//put in mouse click listeners that track what has been selected
	//put in routes - have it read from a formatted file from the ruby script
	public EuropeMap(){
		cities = new ArrayList<City>();
		routes_ = new HashMap<String, ArrayList<String>>();
		loadImage();
		loadCities();
		loadRoutes();
		
		
		surface = new JPanel(){
            @Override
            protected void paintComponent(Graphics g) {
                super.paintComponent(g);
                g.drawImage(europeMap, 0, 0, null);
                drawCities(g);
            }
        };
	 
		setSize(1280, 1024);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setLocation(100, 100);
		add(surface);
		setVisible(true);
	}
	
	//ruby script created an easily parseable file of every route generated
	//line: Start-End==Start ... End
	private void loadRoutes() {
		try {
			List<String> lines = Files.readAllLines(FileSystems.getDefault().getPath("code_out"), Charset.forName("US-ASCII"));
			for(String line : lines){
				String[] contents = line.split("==");
				String[] route = contents[1].split(" ");
				routes_.put(contents[0], new ArrayList<String>(Arrays.asList(route)));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void loadCities() {
		
	}

	private void drawCities(Graphics g){
		
	}
	
	private void loadImage(){
		try {
			europeMap = ImageIO.read(new File("europe.png"));
		} 
		catch (IOException e) {
			System.out.println(e.getMessage());
		}
	}
}
