function pos = getPosition(fig)

figure(fig);

pos = ginput(1);
pos(1) = floor(pos(1));
pos(2) = floor(6-pos(2));