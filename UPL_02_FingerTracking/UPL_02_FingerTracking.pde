import intel.pcsdk.*;

PXCUPipeline session;
PImage rgbTexture, blobTexture;
ArrayList<PVector> fingerTips = new ArrayList<PVector>();

int[] handLabels = {PXCMGesture.GeoNode.LABEL_BODY_HAND_PRIMARY,
                    PXCMGesture.GeoNode.LABEL_BODY_HAND_SECONDARY};

int[] fingerLabels = {PXCMGesture.GeoNode.LABEL_FINGER_THUMB,
                      PXCMGesture.GeoNode.LABEL_FINGER_INDEX,
                      PXCMGesture.GeoNode.LABEL_FINGER_MIDDLE,
                      PXCMGesture.GeoNode.LABEL_FINGER_RING,
                      PXCMGesture.GeoNode.LABEL_FINGER_PINKY};

void setup()
{
  size(640,240,P2D);
  session = new PXCUPipeline(this);
  session.Init(PXCUPipeline.COLOR_VGA|PXCUPipeline.GESTURE);
  
  rgbTexture = createImage(640,480,RGB);
  blobTexture = createImage(320,240,RGB);
}

void draw()
{
  if(session.AcquireFrame(false))
  {
    fingerTips.clear();
    session.QueryRGB(rgbTexture);
    session.QueryLabelMapAsImage(blobTexture);
    
    for(int hand=0;hand<handLabels.length;++hand)
    {
      for(int finger=0;finger<fingerLabels.length;++finger)
      {
        PXCMGesture.GeoNode node = new PXCMGesture.GeoNode();
        if(session.QueryGeoNode(handLabels[hand]|fingerLabels[finger], node))
        {
          fingerTips.add(new PVector(node.positionImage.x, node.positionImage.y));
        }        
      }
    }    
    session.ReleaseFrame();   
  }
  image(blobTexture,0,0);
  image(rgbTexture,320,0,320,240);
 
  for(int p=0;p<fingerTips.size();++p)
  {
    PVector fingerTip = (PVector)fingerTips.get(p);
    ellipse(fingerTip.x,fingerTip.y,5,5);
  }
  //ellipse(handPosition1.x,handPosition1.y,20,20);  
}


