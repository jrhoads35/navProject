% extrema Find the extremal points for the column in the
%         table, and the midpoints between them. Includes
%         the first and last points in the table.
function culled = extrema(table, column)
  len = size(table,1);
  keep = false(len,1);
  keep(1) = true;
  keep(len) = true;
  %% Find the extrema
  for i = 2:len-1
    pr1 = table{i,column} - table{i-1,column};
    pr2 = table{i+1,column} - table{i,column};
    keep(i) = pr1 * pr2 < 0;
  end
  %% Add the midpoints
  last = 0;
  for i = 2:len-1
    if keep(i)
      if last > 0
	midpt = fix((i + last)/2);
	keep(midpt) = true;
      end
      last = i;
    end
    culled = keep;
  end
