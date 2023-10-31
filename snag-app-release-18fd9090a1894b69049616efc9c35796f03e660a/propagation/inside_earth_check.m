function inside_earth_check(position_m)
  if norm(position_m) < constants.earth_radius_m
    error('state:position_inside_earth', 'Satellite is inside the earth, geocentric distance %d meters', norm(position_m));
  end
end
