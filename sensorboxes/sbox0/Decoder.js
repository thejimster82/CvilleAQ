function Decoder(bytes, port) {
  var decoded = {};

  var co2 = bytes[0] + (bytes[1] << 8) + (bytes[2] << 16) + (bytes[3] << 24);

  var temp = (bytes[4] << 8) | bytes[5];
  var hum = (bytes[6] << 8) | bytes[7];
  var pm25 = (bytes[8] << 8) | bytes[9];
  var pm10 = (bytes[10] << 8) | bytes[11];

  // Decode integer to float
  decoded.co2 = (co2 / 100).toFixed(2);

  if (temp > 6000) {
    decoded.temp = ((temp - 65536) / 100).toFixed(2);
  } else {
    decoded.temp = (temp / 100).toFixed(2);
  }
  decoded.humidity = (hum / 100).toFixed(2);
  decoded.pm25 = pm25;
  decoded.pm10 = pm10;

  return decoded;
}
