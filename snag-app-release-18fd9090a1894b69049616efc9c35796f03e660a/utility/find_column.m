% Column number for the named column
function col = find_column(table, name)
  if size(name, 2) == 1
    col = find(strcmpi(table.Properties.VariableNames,name));
  else
    col = arrayfun(@(x) find_column(table,x), name);
  end
end
