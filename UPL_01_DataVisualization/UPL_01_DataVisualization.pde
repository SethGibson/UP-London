import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

JSONObject jsonObject;
JSONArray jsonArray;
int[] timestepMinMax = new int[2];
int[] windspdMinMax = new  int[2];
HashMap windTable;

void setup()
{
  setupHashMaps();  
  try
  {
    String[] jsonString = loadStrings("wind_1day.txt");
    jsonObject = new JSONObject(join(jsonString,""));
    jsonArray = jsonObject.getJSONArray("Weather");
    println(jsonArray.length());
    timestepMinMax = getMinMax("Time Step", jsonArray);
    
    windspdMinMax = getMinMax("Wind Speed", jsonArray);
    
    println(timestepMinMax[0]+" - "+timestepMinMax[1]);
  }
  catch(JSONException e)
  {
    println(e.getMessage());
  }
  
  size(500,500);
  background(0);
  noFill();
  strokeWeight(1);  
}

void draw()
{
  background(0);
  for(int i=0;i<jsonArray.length();++i)
 {
   try
   {
     JSONObject current = jsonArray.getJSONObject(i);
     String day = current.getString("Day");
     int tstep = current.getInt("Time Step");
     int rad = (int)map(tstep,timestepMinMax[0],timestepMinMax[1],50,480);
     stroke(255,(int)map(tstep,timestepMinMax[0],timestepMinMax[1],255,16));
     ellipse(width/2,height/2,rad,rad);
     
     if(day.equals("Monday"))
     {
      String windDir = current.getString("Wind Direction");
      int windSpeed = current.getInt("Wind Speed");
      PVector windVector = (PVector)windTable.get(windDir);
      
      pushMatrix();
      translate(width/2,height/2);
      windVector.normalize();
      windVector.mult(rad);
      pushStyle();
      noStroke();
      fill(255);
      int ellipseRad = (int)map(windSpeed,windspdMinMax[0],windspdMinMax[1],10,40);
      ellipse(windVector.x*0.5,windVector.y*0.5,ellipseRad,ellipseRad);
      popStyle();
      popMatrix();
     }
   }
   catch(JSONException e)
   {
     println(e.getMessage());
   }
 } 
}


