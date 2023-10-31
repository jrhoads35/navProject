% epochstruct  Convert a timetable to a structure array
function st = epochstruct(timetable)
  st = table2struct(timetable2table(timetable));
end
