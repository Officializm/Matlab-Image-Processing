%===============================================
%@author Recep Çetinkaya
%Object Recognition According to Size and Color.
%===============================================
ard = arduino('COM6', 'Uno', 'Libraries', 'Servo');%create ard str to connect arduino
s = servo(ard, 'D9', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6)%create s str to calibrate servo motors
s2 = servo(ard, 'D8', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6)%create s2 str to calibrate servo motors
cam = webcam(2);%open webcam from USB camera
writePosition(s,1);% write position of servo1.
counter=0;
counter2=0;
 while(1)
    I = snapshot(cam);%take a snapshot from USB webcam
  if readDigitalPin(ard,'D13')==0 %take a photo when MZ80 see object.
   
   bin=rgb2gray(I);%convert to grayscale photo
   bw = imbinarize(bin,0.05);%imbinarize photo
   bw=imcomplement(bw);%take complement of photo.
   bw=bwareaopen(bw,500); %delete areas under 500 pixels
   bw=imclose(bw,strel('disk',5));%apply morphological operation
   cc = bwconncomp(bw, 4)%detect 4-way neighborliness of pixels
   g1 = regionprops(cc, 'basic')%create g1 structure
   
   
   bw2=imbinarize(bin,0.25);%imbinarize photo
   bw2=imcomplement(bw2);%take complement of photo.
   bw2=bwareaopen(bw2,500);%delete areas under 500 pixels
   bw2=imclose(bw2,strel('disk',5));;%apply morphological operation
   cc2=bwconncomp(bw2, 4)%detect 4-way neighborliness of pixels
   g2 = regionprops(cc2, 'basic')%create g1 structure
   g2Area = [g2.Area];
   imshow(I),title('SONUC');%show image
  hold on
  if   cc.NumObjects<=1 
   for i=1:cc.NumObjects% There is as many loop as the number of objects.
            aa = g1(i).BoundingBox;%take BoundingBox data from g1
            ab =g1(i).Centroid;%take Centroid data from g1
            rectangle('Position',aa,'EdgeColor','g','LineWidth',2)%create a rectangle
            plot(ab(1),ab(2), '-m+')%put center axis.
            a=text(ab(1)+15,ab(2), strcat(num2str(round(ab(1))),',',num2str(round(ab(2)))));%write center axis of objects
            set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');%
            counter=counter+1;
      
   end
  end
  
  
   if cc2.NumObjects<=1% There is as many loop as the number of objects.
   for i=1:cc2.NumObjects 
    if g2Area(i)<20000 || g2Area(i)>40000%detect object when size of object is bigger than 40000 or smaller than 20000
            bb = g2(i).BoundingBox;%take BoundingBox data from g1
            bc = g2(i).Centroid;%take Centroid data from g1
            rectangle('Position',bb,'EdgeColor','g','LineWidth',2)%create a rectangle           
            a=text(bc(1)+15,bc(2), strcat(num2str(round(bc(1))),',',num2str(round(bc(2)))));%write center axis of objects
            counter2=counter2+1;
    end 
   end
   end

  if counter~=0  %change position of servo motors when counter is not equal 0
      writePosition(s,0.35);%change poisition of servo motor
      writePosition(s2,1);%change poisition of servo motor
      pause(2);%wait for 2 seconds
      writePosition(s,1);%change poisition of servo motor
      writePosition(s2,0.40); %change poisition of servo motor   
  end
  
  if counter2~=0  %change position of servo motors when counter is not equal 0
      writePosition(s,0.35);%change poisition of servo motor
      writePosition(s2,1);%change poisition of servo motor
      pause(2);%wait for 2 seconds
      writePosition(s,1);%change poisition of servo motor
      writePosition(s2,0.40);  %change poisition of servo motor    
  end
 hold off
  end
 counter=0;%reset the variable
 counter2=0;%reset the variable
 end

close all
clear all



