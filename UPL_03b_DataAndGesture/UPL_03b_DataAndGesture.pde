import intel.pcsdk.*;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
import java.util.*;

boolean selected;

int dayId = 0;
int[] windSpeedMinMax = new int[2];
int[] windGustMinMax = new int[2];
int[] timeStepMinMax = new int[2];

float handPosition;

String dispDay = "Monday";
String[] dispDays = {"Monday","Tuesday","Wednesday","Thursday","Friday"};

HashMap windTable;
HashMap<String,Integer> dayColors = new HashMap<String,Integer>();

PFont arial;

JSONObject jsonRoot;
JSONArray windArray;

PXCUPipeline session;

void setup()
{
  session = new PXCUPipeline(this);
  session.Init(PXCUPipeline.GESTURE);
  
  size(800,800);
  ellipseMode(RADIUS);

  arial = loadFont("Arial-BoldMT-24.vlw");
  textFont(arial);

  try
  {  
    jsonRoot = new JSONObject(join(loadStrings("week_of_wind.txt"),""));
    windArray = jsonRoot.getJSONArray("Weather");
    
    windSpeedMinMax = getMinMax("Wind Speed", windArray);
    windGustMinMax = getMinMax("Wind Gust", windArray);
    timeStepMinMax = getMinMax("Time Step", windArray);
  }
  catch(JSONException e)
  {
    println(e.getMessage());
  }

  setupHashMaps();  
}

void draw()
{
  if(session.AcquireFrame(false))
  {
    PXCMGesture.GeoNode node = new PXCMGesture.GeoNode();
    if(session.QueryGeoNode(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY, node))
    {
      handPosition = constrain(map(node.positionImage.y,40,200,0,800),0,800);
    }
    else
      handPosition = -1;
    
    PXCMGesture.Gesture gest = new PXCMGesture.Gesture();
    if(session.QueryGesture(PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY, gest))
    {
      if(gest.active)
      {
        handPosition = -1;
        if(gest.label==PXCMGesture.Gesture.LABEL_NAV_SWIPE_LEFT)
        {
          --dayId;
          if(dayId<0)
            dayId=0;    
        }
        else if(gest.label==PXCMGesture.Gesture.LABEL_NAV_SWIPE_RIGHT)
        {
          ++dayId;
          if(dayId>=dispDays.length)
            dayId=dispDays.length-1;
        }
      }
    }
    session.ReleaseFrame();
  }

  background(0);

  pushMatrix();
  //translate(width/2,height/2);
  translate(0,height);
  for(int i=0;i<windArray.length();++i)
  {
    try
    {
      JSONObject dataPoint = windArray.getJSONObject(i);
      String day = dataPoint.getString("Day");
      int timestep = dataPoint.getInt("Time Step");
      
      //radius = Gusts
      //alpha = speed
      int rad = (int)map(timestep,timeStepMinMax[0],timeStepMinMax[1],100,750);

      //time steps
      pushStyle();
      float d = dist(0,height,0,handPosition);
      if(d<rad+6&&d>rad-6)
      {
        stroke(255,192,0);
        selected = true;
      }
      else
      {
        stroke(255, map(timestep,0,120,255,16));
        selected = false;
      }
      strokeWeight(4);
      noFill();
      if(day.equals("Monday"))
        ellipse(0,0,rad,rad);
      popStyle();
      
      if(day.equals(dispDays[dayId]))
      {
        String windDir = dataPoint.getString("Wind Direction");
        int windSpeed = dataPoint.getInt("Wind Speed");
        int windGust = dataPoint.getInt("Wind Gust");
        float windRadius = map(windGust,windGustMinMax[0],windGustMinMax[1],10,50);
        float windAlpha = map(windSpeed,windSpeedMinMax[0],windSpeedMinMax[1],16,192);
        color windColor = (color)dayColors.get(day);
        
        PVector windVector = (PVector)windTable.get(windDir);
        windVector.normalize();
        windVector.mult(rad);    
 
        pushStyle();
        //gust and speed
        if(selected)
        {
          strokeWeight(2);
          stroke(255,192,0);
          
          pushStyle();
          fill(255,192,0);
          text("Wind Direction: "+windDir,width-245,-height+30);
          text("Wind Speed: "+windSpeed,width-213,-height+60);
          text("Wind Gust: "+windGust,width-196,-height+90);
          popStyle();
        }
        else
        {
          strokeWeight(1);
          stroke(windColor,192-windAlpha);
        }
        fill(windColor, windAlpha);
        ellipse(windVector.x,windVector.y,windRadius,windRadius);
        
        //main
        fill(255);
        ellipse(windVector.x,windVector.y,3,3);
        popStyle();
      }
    }
    catch(JSONException e)
    {
      println(e.getMessage());
    }
  }
  popMatrix();

  pushStyle();
  color textColor = (color)dayColors.get(dispDay);
  fill(textColor);
  text(dispDays[dayId],10,30);
  popStyle();
}

void keyPressed()
{
  if(key=='a')
  {
    --dayId;
    if(dayId<0)
      dayId=0;
  }
  if(key=='s')
  {
    ++dayId;
    if(dayId>=dispDays.length)
      dayId=dispDays.length-1;
  }  
}
