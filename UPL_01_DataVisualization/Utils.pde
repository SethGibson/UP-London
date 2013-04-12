//This code is available at:
// https://github.com/SethGibson/UPLondon
void setupHashMaps()
{
  windTable = new HashMap();  
  windTable.put("N", new PVector(0,-1));
  windTable.put("S", new PVector(0,1));
  windTable.put("E", new PVector(1,0));
  windTable.put("W", new PVector(-1,0));
  windTable.put("NW", new PVector(-1,-1));
  windTable.put("NE", new PVector(1,-1));
  windTable.put("SW", new PVector(-1,1));
  windTable.put("SE", new PVector(1,1));
  windTable.put("NNW", new PVector(-.5,-1));
  windTable.put("NNE", new PVector(.5,-1));
  windTable.put("ENE", new PVector(1,-.5));
  windTable.put("WNW", new PVector(-1,-.5));
  windTable.put("SSE", new PVector(.5,1));
  windTable.put("SSW", new PVector(-.5,1));
  windTable.put("ESE", new PVector(1,.5));
  windTable.put("WSW", new PVector(-1,.5));
}

int[] getMinMax(String jsonKey, JSONArray jsonArr)
{
  int[] returned = new int[2];
  for(int i=0;i<jsonArr.length();++i)
 {
   try
   {
     JSONObject current = jsonArr.getJSONObject(i);
     int keyValue = current.getInt(jsonKey);
     if(i==0)
       returned[0]=returned[1]=keyValue;
      else
      {
        if(keyValue<returned[0])
          returned[0]=keyValue;
        if(keyValue>returned[1])
          returned[1]=keyValue;
      }
   }
   catch(JSONException e)
   {
     println(e.getMessage());
   }
 }
 return returned;
}

