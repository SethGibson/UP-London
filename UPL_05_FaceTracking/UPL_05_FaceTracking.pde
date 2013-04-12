import intel.pcsdk.*;

PXCUPipeline session;
PImage rgbTex;

int[] faceLabels = {PXCMFaceAnalysis.Landmark.LABEL_LEFT_EYE_OUTER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_LEFT_EYE_INNER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_RIGHT_EYE_OUTER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_RIGHT_EYE_INNER_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_MOUTH_LEFT_CORNER,
                  PXCMFaceAnalysis.Landmark.LABEL_MOUTH_RIGHT_CORNER};

ArrayList<FaceP5> faces = new ArrayList<FaceP5>();
ArrayList<PXCMPoint3DF32> lmarks = new ArrayList<PXCMPoint3DF32>();
PXCMFaceAnalysis.Detection.Data fdata = new PXCMFaceAnalysis.Detection.Data();
PXCMFaceAnalysis.Landmark.LandmarkData lmark = new PXCMFaceAnalysis.Landmark.LandmarkData();

void setup()
{
  size(640,480);
  rgbTex = createImage(640,480,RGB);
  session = new PXCUPipeline(this);
  session.Init(PXCUPipeline.COLOR_VGA|PXCUPipeline.FACE_LOCATION|PXCUPipeline.FACE_LANDMARK);
}

void draw()
{
  if(session.AcquireFrame(false))
  {
    session.QueryRGB(rgbTex);
    faces.clear();
    lmarks.clear();
    
    for(int i=0;;++i)
    {
      long[] ft = new long[2];
      if(!session.QueryFaceID(i,ft))
        break;

      if(session.QueryFaceLocationData((int)ft[0], fdata))
      {
        for(int f=0;f<faceLabels.length;++f)
        { 
          if(session.QueryFaceLandmarkData((int)ft[0],faceLabels[f], 0, lmark))
          {
            lmarks.add(lmark.position);
          }
        }
        faces.add(new FaceP5(fdata, lmarks));
      }
    }
    session.ReleaseFrame();
  }
  image(rgbTex,0,0);
  for(int i=0;i<faces.size();++i)
  {
    faces.get(i).debugDraw();
  }
}
