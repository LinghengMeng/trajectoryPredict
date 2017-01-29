function [ Data ] = angle_Velocity( Data, start_point)
%compute angle and velocity
initial = zeros(size(Data,1),length(start_point));
for i = 1:length(start_point)
    initial(:,i) = Data(:,start_point(i)+1) - Data(:,start_point(i));
end
angle = initial(2,:) ./ initial(3,:);
velocity = initial(2:3,:);
start_point(:,length(start_point)+1) = size(Data,2)+1;
for j = 1:length(start_point)
    if j ==  length(start_point)
       break 
    end
    angle_all(:,start_point(j):start_point(j+1)-1) = repmat(angle(j),1,start_point(j+1)-start_point(j));
    velocity_all(:,start_point(j):start_point(j+1)-1) = repmat(velocity(:,j),1,start_point(j+1)-start_point(j));
    sections_all(:,start_point(j):start_point(j+1)-1) = repmat(start_point(j+1)-start_point(j),1,start_point(j+1)-start_point(j));
end

% adding angle, velocity and sections to data
% Data = [Data; angle_all; velocity_all; sections_all];
Data = [Data; angle_all; velocity_all;];

end

