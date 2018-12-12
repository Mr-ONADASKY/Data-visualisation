/*  
    Sources: https://www.youtube.com/watch?v=dbs4IYGfAXc
    
    Data sources:
    https://bitnodes.earn.com/api/v1/snapshots/latest/
    https://github.com/mledoze/countries
*/

float longitude = 144.9631;
float latitude = -37.8136;

float worldAngle = 0;
float worldRadius = 200;

Table table;

JSONObject jsonBitcoinNodes;
JSONObject jsonNitcoinNodesList;

JSONArray countries;

PImage earth;
PShape globe;

bitcoinNode[] bitcoinNodes;

JSONObject nodesMemoryArray;

void setup() {
  
  size(800, 800, P3D);
  earth = loadImage("Earth.jpg");
   //table = loadTable("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_day.csv", "header");
   //table = loadTable("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv", "header");
   
   jsonBitcoinNodes = loadJSONObject("BitcoinNodes.json");
   jsonNitcoinNodesList = jsonBitcoinNodes.getJSONObject("nodes");
   
   //bitcoinNodes = new bitcoinNode[jsonNitcoinNodesList.keys().size()];
   
   countries = loadJSONArray("Countries.json");
   
  // println(jsonNitcoinNodesList, jsonNitcoinNodesList.keys());
   Object[] bitcoinNodesKeys = jsonNitcoinNodesList.keys().toArray();
   
   nodesMemoryArray = new JSONObject();
   
   for(int index = 0; index < bitcoinNodesKeys.length; index++) {
     JSONArray currentBitcoinNode = jsonNitcoinNodesList.getJSONArray(bitcoinNodesKeys[index].toString());
     if(currentBitcoinNode.get(7) instanceof String) {
       if(nodesMemoryArray.getJSONObject(currentBitcoinNode.getString(7))  != null) {
         JSONObject currentObject = nodesMemoryArray.getJSONObject(currentBitcoinNode.getString(7));
         currentObject.setInt("nodes", currentObject.getInt("nodes") + 1);
       } else {
         JSONObject tempObject = new JSONObject();
         for(int i = 0; i < countries.size(); i++) {
           if(countries.getJSONObject(i).getString("cca2").toString().equals(currentBitcoinNode.getString(7).toString())){
             JSONObject currentCountry = countries.getJSONObject(i);
             JSONArray latLng = currentCountry.getJSONArray("latlng");
             tempObject.setFloat("lon", latLng.getFloat(0));
             tempObject.setFloat("lat", latLng.getFloat(1));
             tempObject.setInt("nodes", 1);
             tempObject.setString("cca2", currentBitcoinNode.getString(7));
           }
       }       
         nodesMemoryArray.setJSONObject(currentBitcoinNode.getString(7), tempObject);
       }
     }
   }
   noStroke();
   globe = createShape(SPHERE, worldRadius);
   globe.setTexture(earth);
}

void draw(){
    background(51);
    translate(width * .5, height * .5);
    rotateY(worldAngle);
    worldAngle += 0.02;
    
    lights();
    fill(200);
    noStroke();
    shape(globe);
    //Object[] bitcoinNodesKeys = jsonNitcoinNodesList.keys().toArray();
    Object[] bitcoinNodesKeys = nodesMemoryArray.keys().toArray();
    for(int index = 0; index < bitcoinNodesKeys.length; index++) {
     JSONObject currentBitcoinNode = nodesMemoryArray.getJSONObject(bitcoinNodesKeys[index].toString());
     // bitcoinNodesKeys[index]
       //println(currentBitcoinNode.get(7));

      float latitude = currentBitcoinNode.getFloat("lon");
      float longitude = currentBitcoinNode.getFloat("lat");
      int nodes = currentBitcoinNode.getInt("nodes");
      float theta = radians(latitude) + PI/2;
      float phi = radians(-longitude) + PI;  
      float cityX = worldRadius * sin(theta) * cos(phi);
      float cityY = worldRadius * cos(theta);
      float cityZ = worldRadius * sin(theta) * sin(phi);
      PVector position = new PVector(cityX, cityY, cityZ);
      
      float height = log(nodes) * 10;
      PVector xAxis = new PVector(1, 0, 0);
      float angleXPosition = PVector.angleBetween(xAxis, position);
      PVector radiusAxis = xAxis.cross(position);
      
      
      pushMatrix();
      translate(cityX, cityY, cityZ);
      rotate(angleXPosition, radiusAxis.x, radiusAxis.y, radiusAxis.z);
      fill(255);
      box(height, 5, 5);
      popMatrix();
    }
    
    
    
    
}
