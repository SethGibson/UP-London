import intel.pcsdk.*;

PXCUPipeline session;
PImage rgbTex;

int[] faceLabels = {PXCMFaceAnalysis.Landmark.LABEL_LEFT_EYE_OUTER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_LEFT_EYE_INNER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_RIGHT_EYE_OUTER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_RIGHT_EYE_INNER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_MOUTH_LEFT_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_MOUTH_RIGHT_CORNER};

ArrayList<PXCMPoint3DF32> facePts = new ArrayList<PXCMPoint3DF32>();
ArrayList<PXCMRectU32> faceBoxes = new ArrayList<PXCMRectU32>();

void setup()
{
  size(640,480);
  rgbTex = createImage(640,480,RGB);
  session = new PXCUPipeline(this);
  session.Init(PXCUPipeline.COLOR_VGA|PXCUPipeline.FACE_LOCATION|PXCUPipeline.FACE_LANDMARK);
}

void draw()
{
  if(session.AcquireFrame(true))
  {
    session.QueryRGB(rgbTex);
    facePts.clear();
    faceBoxes.clear();
    
    for(int i=0;;++i)
    {
      long[] ft = new long[2];
      if(!session.QueryFaceID(i,ft))
        break;
      PXCMFaceAnalysis.Detection.Data fdata = new PXCMFaceAnalysis.Detection.Data();
      if(session.QueryFaceLocationData((int)ft[0], fdata))
      {
        faceBoxes.add(fdata.rectangle);
        
        PXCMFaceAnalysis.Landmark.LandmarkData lmark = new PXCMFaceAnalysis.Landmark.LandmarkData();
        for(int f=0;f<faceLabels.length;++f)
        { 
          if(session.QueryFaceLandmarkData((int)ft[0],faceLabels[f], 0, lmark))
          {
            facePts.add(lmark.position);
          }
        }
      }
    }
    session.ReleaseFrame();
  }
  image(rgbTex,0,0);
  pushStyle();
  stroke(255);
  noFill();
  for(int f=0;f<faceBoxes.size();++f)
  {
    PXCMRectU32 faceLoc = (PXCMRectU32)faceBoxes.get(f);
    rect(faceLoc.x,faceLoc.y,faceLoc.w,faceLoc.h);
  }
  for(int g=0;g<facePts.size();++g)
  {
    PXCMPoint3DF32 facePt = (PXCMPoint3DF32)facePts.get(g);
    ellipse(facePt.x,facePt.y,5,5);
  }  
  popStyle();
}
