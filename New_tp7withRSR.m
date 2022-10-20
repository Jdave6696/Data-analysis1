clear
clc
file=1;
p=500000; % numbers of simulation on one Atm profile...
FINAL=zeros(1,32);
%% interpolation
bla1=xlsread('F:\Jalpesh\SSTM_RSR\SSTM_RSR_Bands.xlsx','band1'); %for band1
bla2=xlsread('F:\Jalpesh\SSTM_RSR\SSTM_RSR_Bands.xlsx','band2'); %for band2
band1=round(bla1(:,1)); %values of band1
band2=round(bla2(:,1)); %values of band2
RSR1=bla1(:,2); %values of RSR1
RSR2=bla2(:,2); %values of RSR2
%%
file2='G:\jd\New_World_Selected_996\Tiles\10_old\run\'; % path of tap7 files

for srno=1:10
    disp(srno)
                for  t=1:p
                    if exist([file2,num2str(srno),'_',num2str(file),'_','Lambertian.tp7'],'file') %
                                            % band1
                                            filename = [file2,num2str(srno),'_',num2str(file),'_','Lambertian.tp7']; %
                                            startRow = 12;
                                            endRow = 735;
                                            formatSpec = '%8f%11f%11f%11f%11f%11f%11f%11f%11f%11f%9f%9f%8f%7f%11f%f%[^\n\r]';
                                            fileID = fopen(filename,'r');
                                            dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
                                            fclose(fileID);
                                            Lambertian1 = table(dataArray{1:end-1}, 'VariableNames', {'FREQ','TOT_TRANS','PTH_THRML','THRML_SCT','SURF_EMIS','SOL_SCAT','SING_SCAT','GRND_RFLT','DRCT_RFLT','TOTAL_RAD','REF_SOL','SOLOBS','DEPTH','DIR_EM','TOA_SUN','BBODY_TK'});
                                            clearvars filename startRow endRow formatSpec fileID dataArray ans;                                            %band2
                                            %band2
                                            filename = [file2,num2str(srno),'_',num2str(file),'_','Lambertian.tp7']; %
                                            startRow = 14;
                                            endRow = 735;
                                            formatSpec = '%8f%11f%11f%11f%11f%11f%11f%11f%11f%11f%9f%9f%8f%7f%11f%f%[^\n\r]';
                                            fileID = fopen(filename,'r');
                                            dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
                                            fclose(fileID);
                                            Lambertian2 = table(dataArray{1:end-1}, 'VariableNames', {'FREQ','TOT_TRANS','PTH_THRML','THRML_SCT','SURF_EMIS','SOL_SCAT','SING_SCAT','GRND_RFLT','DRCT_RFLT','TOTAL_RAD','REF_SOL','SOLOBS','DEPTH','DIR_EM','TOA_SUN','BBODY_TK'});
                                            clearvars filename startRow endRow formatSpec fileID dataArray ans;             
                                            
                                            x1=table2array(Lambertian1(:,1)); % values of band1 (which are going to be interpolate)
                                            x2=table2array(Lambertian2(:,1)); % values of band2 (which are going to be interpolate)
                                            y1=table2array(Lambertian1(:,[2:16])); % simulated values of band1 (which are going to be interpolate)
                                            y2=table2array(Lambertian2(:,[2:16])); % simulated values of band1 (which are going to be interpolate)
                                            %interpolation 
                                            yi1=interp1(x1,y1,band1,'spline');
                                            yi2=interp1(x2,y2,band2,'spline');
                                            %interpolation has been done
                                            f1=[band1,yi1]; 
                                            f2=[band2,yi2];
                                            %applying RSR values on interpolation
                                            bkld1=f1.*RSR1;
                                            bkld2=f2.*RSR2;
                                            JANK1=sum(bkld1)/sum(RSR1); %final product for band1
                                            JANK2=sum(bkld2)/sum(RSR2); %final product for band2
                                            FINAL(file,:)=[JANK1,JANK2];
                                            
                                            
                                            file=file+1;
                    else
                            break
                    end    
                end                    
end          
xlswrite('F:\Jalpesh\SSTM_RSR\SSTM_RSR_Bands.xlsx',FINAL,'interpolationTrans_full');

