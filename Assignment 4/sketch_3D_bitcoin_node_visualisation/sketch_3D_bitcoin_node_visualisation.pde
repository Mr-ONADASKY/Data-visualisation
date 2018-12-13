/*  
    Sources: https://www.youtube.com/watch?v=dbs4IYGfAXc
    
    Data sources:
    https://bitnodes.earn.com/api/v1/snapshots/latest/
    https://github.com/mledoze/countries
*/

float worldAngle = 0; // Which angle the world is currently rotated at
float worldRadius = 200; // The radius from the sphere that represents the world

JSONObject jsonBitcoinNodes; // Object for the bitcoinNodesJson
JSONObject jsonNitcoinNodesList; // Object for the sublist with all the nodes within the jsonBitcoinNodes

JSONArray countries; // List with all the countries

PImage earth; // PImage from the earth
PShape globe; // PShape for the sphere that represents the globe

JSONObject nodesMemoryArray; // Memory array for all the nodes

void setup() {
  
  size(600, 600, P3D);
  earth = loadImage("Earth.jpg");
   
   jsonBitcoinNodes = loadJSONObject("BitcoinNodes.json");
   jsonNitcoinNodesList = jsonBitcoinNodes.getJSONObject("nodes");
   
   countries = loadJSONArray("Countries.json");

   Object[] bitcoinNodesKeys = jsonNitcoinNodesList.keys().toArray();
   
   nodesMemoryArray = new JSONObject();
   
   // Find all the coordinates for the countries from the npdes and count the amount of node for each country
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
  // Draw the sphere
    background(51);
    textSize(25);
    textAlign(CENTER,CENTER);
    text("Amount of bitcoin nodes in each country", width * .5, 20);
    
    translate(width * .5, height * .5);
    rotateY(worldAngle);
    worldAngle += 0.02;
    
    lights();
    fill(200);
    noStroke();
    shape(globe);
    
    
    
    // Draw each block that represents the amount of nodes for eacht country
    Object[] bitcoinNodesKeys = nodesMemoryArray.keys().toArray();
    for(int index = 0; index < bitcoinNodesKeys.length; index++) {
     JSONObject currentBitcoinNode = nodesMemoryArray.getJSONObject(bitcoinNodesKeys[index].toString());

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
