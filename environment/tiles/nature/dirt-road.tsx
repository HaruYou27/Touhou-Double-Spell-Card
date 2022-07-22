<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.8" tiledversion="1.8.4" name="dirt-road" tilewidth="512" tileheight="552" tilecount="5" columns="0">
 <grid orientation="isometric" width="1" height="1"/>
 <tile id="0">
  <image width="512" height="552" source="grassroad1.png"/>
 </tile>
 <tile id="1">
  <image width="512" height="552" source="grassroad2.png"/>
 </tile>
 <tile id="2">
  <image width="512" height="552" source="grassroad3.png"/>
 </tile>
 <tile id="3">
  <image width="512" height="552" source="grassroad4.png"/>
 </tile>
 <tile id="4">
  <image width="512" height="552" source="grassroad5.png"/>
 </tile>
 <wangsets>
  <wangset name="Unnamed Set" type="edge" tile="-1">
   <wangcolor name="" color="#ff0000" tile="-1" probability="1"/>
   <wangtile tileid="0" wangid="1,0,0,0,1,0,0,0"/>
  </wangset>
  <wangset name="Unnamed Set" type="corner" tile="-1">
   <wangcolor name="" color="#ff0000" tile="-1" probability="1"/>
   <wangtile tileid="1" wangid="0,1,0,0,0,0,0,1"/>
  </wangset>
 </wangsets>
</tileset>
