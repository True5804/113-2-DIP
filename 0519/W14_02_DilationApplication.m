%% 利用上述的各種不同 SE 套用在需要被修復的物體上
% 2.套用在案例上
% 2.1 套用在

figure('Name', '膨脹操作示範');
subplot(3,3,1);
broken = false(200, 200);
broken(90:110, 30:85) = true;   % 左段水平線
broken(90:110, 115:170) = true; % 右段水平線

imshow(broken);
title('斷開的線條');

% fix the broken line
subplot(3,3,2);
se_repair1 = strel('disk', 5);
repaired1 = imdilate(broken,se_repair1);
imshow(repaired1);
title('dilation with disk r=5');

% fix the broken line
subplot(3,3,3);
se_repair2 = strel('disk', 15);
repaired2 = imdilate(broken,se_repair2);
imshow(repaired2);
title('dilation with disk r=15');