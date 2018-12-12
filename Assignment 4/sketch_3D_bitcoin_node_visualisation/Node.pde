class bitcoinNode {
 float longitude, latitude;
 int nodes;
 String cca2;
 
 bitcoinNode(float lon, float lat, int nod, String cca2) {
  
   longitude = lon;
   latitude = lat;
   nodes = nod;
   this.cca2 = cca2;
 }
 
 bitcoinNode(String cca2) {
    longitude = 0;
    latitude = 0;
    nodes = 0;
    this.cca2 = cca2;
 }
  
  int addNode() {
     return(++nodes); 
  }
}
