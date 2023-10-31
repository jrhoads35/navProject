function dict = tablecolumntypes
  dict.epoch = "datetime";
  dict.timestamp = "datetime";
  dict.datetime = "datetime";
  dict.position_m = "double";
  dict.velocity_ms = "double";
  dict.acceleration_mss = "double";
  dict.elapsed_s = "double";
  dict.deltat_s = "double";
  dict.event = "string";
  dict.azimuth_deg = "double";
  dict.elevation_deg = "double";
  dict.azimuth_rdn = "double";
  dict.elevation_rdn = "double";
  dict.range_m = "double";
  dict.latitude_deg = "double";
  dict.longitude_deg = "double";
  dict.altitude_m = "double";
  % 4th column from od returns logical; name?
end
