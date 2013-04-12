import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
import java.util.*;

boolean showindVectoray = true;
int[] windSpeedMinMax;
int[] windGustMinMax;

float[] depths = new float[5];
float[] radii = new float[5];

ArrayList<String> days = new ArrayList(Arrays.asList("Friday","Thursday","Wednesday","Tuesday","Monday"));

HashMap windTable;
HashMap<String,Integer> dayColors = new HashMap<String,Integer>();

JSONObject jsonRoot;
JSONArray weatherArray;

void setup()
{
  size(1300,850,P3D);
  background(0);
  stroke(255);
  strokeWeight(1.5);
  noFill();
  smooth(4);

  setupHashMaps();
  for(int i=0;i<5;++i)
  {
    depths[i] = map(i,0,4,-400,400);
    radii[i] = map(i,0,4,80,350);    
  }  
  
  try
  {
    jsonRoot = new JSONObject(join(loadStrings("daily_wind.txt"),""));
    weatherArray = jsonRoot.getJSONArray("Weather");
    windSpeedMinMax = getMinMax("Wind Speed (Day)", weatherArray);
    windGustMinMax = getMinMax("Wind Gust (Day)", weatherArray);
  }
  catch(JSONException e)
  {
    println(e.getMessage());
  }
}

void draw()
{
  background(0);
  setLights();
  pushMatrix();
  translate(width/2,height/2,0);
  rotateY(radians(90+map(mouseX,0,width,-180,180)));
  
  //draw days and timesteps
  //day = depth
  //timestep = radius
  
  for(int i=0;i<days.size();++i)
  {
    pushMatrix();
    translate(0,0,depths[i]);
    pushStyle();
    fill(255);
    text((String)days.get(i),-150,150,0);
    popStyle();
    for(int j=0;j<5;++j)
    {
      stroke(255,255-map(j,0,4,16,192));
      ellipse(0,0,radii[j],radii[j]);
    }
    popMatrix();    
  }

  //draw wind values
  for(int i=0;i<weatherArray.length();++i)
  {
    try
    {
      JSONObject current = weatherArray.getJSONObject(i);
      
      String day = current.getString("Day");
      String windDir = current.getString("Wind Direction (Day)");
      int windSpeed = current.getInt("Wind Speed (Day)");
      int windGust = current.getInt("Wind Gust (Day)");
      if(!showindVectoray)
      {
        windDir = current.getString("Wind Direction (Night)");
        windSpeed = current.getInt("Wind Speed (Night)");
        windGust = current.getInt("Wind Gust (Night)");        
      }      
      int step = current.getInt("Time Step");
      int iDepth = days.indexOf(day);
      int iTStep = step/24;
      PVector windVector = (PVector)windTable.get(windDir);
      windVector.normalize();
      windVector.mult(radii[iTStep]*0.5);

      pushMatrix();
      translate(windVector.x,windVector.y,depths[iDepth]);
      pushStyle();
      noStroke();
      fill((color)dayColors.get(day));
      sphere(map(windSpeed,windSpeedMinMax[0],windSpeedMinMax[1],2,20));
      popStyle();
      popMatrix();
 
    }
    catch(JSONException e)
    {
      println(e.getMessage());
    }
  }  
  popMatrix();
}
