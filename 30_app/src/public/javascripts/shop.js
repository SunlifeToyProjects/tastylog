/* global L, DISPLAY_NAME, GEOLOCATION_LATITUDE, GEOLOCATION_LONGITUDE */

// Initialize map.
var map = L.map("mapid", {
  center: [GEOLOCATION_LATITUDE, GEOLOCATION_LONGITUDE],
  zoom: 17
});

// Set map design.
L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution: "&copy; <a href='http://osm.org/copyright'>OpenStreetMap</a> contributors, <a href='http://creativecommons.org/licenses/by-sa/2.0/'>CC-BY-SA</a>"
}).addTo(map);

// Add marker on the map.
L.marker([GEOLOCATION_LATITUDE, GEOLOCATION_LONGITUDE])
  .addTo(map)
  .bindPopup(DISPLAY_NAME)
  .openPopup();