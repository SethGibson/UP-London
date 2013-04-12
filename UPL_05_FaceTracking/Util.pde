class FaceP5
{
  public PXCMRectU32 FaceBorder;
  public PVector FaceCenter;
  public int FaceID;
  public ArrayList<PVector> Landmarks;
  
  FaceP5(){}
  FaceP5(PXCMFaceAnalysis.Detection.Data pFaceLoc, ArrayList<PXCMPoint3DF32> pFacePts)
  {
    this.FaceCenter = new PVector(0,0);
    this.Landmarks = new ArrayList<PVector>();
    this.FaceBorder = pFaceLoc.rectangle;
    this.FaceCenter.x = (pFaceLoc.rectangle.x*2+pFaceLoc.rectangle.w)*0.5;
    this.FaceCenter.y = (pFaceLoc.rectangle.y*2+pFaceLoc.rectangle.h)*0.5;
    
    for(int i=0;i<pFacePts.size();++i)
    {
      PVector p = new PVector(0,0);
      PXCMPoint3DF32 fp = (PXCMPoint3DF32)pFacePts.get(i);
      p.set(fp.x, fp.y, 0);
      this.Landmarks.add(p);
    }
  }
 
  void debugDraw()
  {
    pushStyle();
    stroke(255);
    noFill();
    rect(this.FaceBorder.x, this.FaceBorder.y, this.FaceBorder.w, this.FaceBorder.h);
    fill(255);
    for(int i=0;i<this.Landmarks.size();++i)
    {
      PVector p = (PVector)this.Landmarks.get(i);
      ellipse(p.x,p.y,5,5);
    }
    popStyle();
  } 
}
