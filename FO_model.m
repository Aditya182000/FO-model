%% Full FO Model
% VIPR-GS Project 3.3
% Hannah Stewart
% 11/24/2021

clear;
clc;

%% Load Data 

InputConstants = readcell('Virtual Tradespace Model Variables.xlsx','Sheet','Input Constants Definition');
MatrixTitles = readcell('Full Model.xlsx');

DataMatrix = readmatrix('Analysis2 wFunctional Objectives wDataGenerated - FIXED v2.xlsx','Sheet','Variable Output');
Data = array2table(DataMatrix,'VariableNames',MatrixTitles);

n = height(Data);
w = width(Data);


%% Preallocate Empty Arrays

UnderbodyAxleMountHeight = zeros(n,1);
BackDeckOverhang = zeros(n,1);
SMETGroundClearance = zeros(n,1);
InnerTurningRadius = zeros(n,1);
LowerCargoStorageVolume = zeros(n,1);
LowerCargoWidth = zeros(n,1);
AxleSeparation = zeros(n,1);
RunningGearWheelContactPatchArc = zeros(n,1);
RunningGearMattrackGroundContactLength=zeros(n,1);
RunningGearContactPatchArea = zeros(n,1);
RunningGearWidth = zeros(n,1);
FrontDeckOverhang = zeros(n,1);
SMETFCCLength = zeros(n,1);
TotalFCCLoadVolume = zeros(n,1);
RunningGearInsetMountHeight = zeros(n,1);
RunningGearHeight = zeros(n,1);
RunningGearFrontMountInset = zeros(n,1);
RunningGearBackMountInset = zeros(n,1);
RunningGearRoadWheelRadius = zeros(n,1);
RunningGearDriveGearRadius = zeros(n,1);
SMETFCCWeight = zeros(n,1);
FrameWeight = zeros(n,1);
RunningGearWeight = zeros(n,1);
UnderbodyandDeckMaterial = zeros(n,1);
UpperCargoStorageHeight = zeros(n,1);
UpperCargoStorageWidth = zeros(n,1);       
TotalFCCLoadWeight = zeros(n,1);
UpperCargoStorageLength = zeros(n,1);
MaxAckermanAngle = zeros(n,1);  
SMETPlatformWidth = zeros(n,1);
SMETPlatformWeight = zeros(n,1);
AckermanWeight = zeros(n,1);
SMETFCCHeight = zeros(n,1); 
OffloadGeneratorVolume = zeros(n,1);
RoadWheelSpace = zeros(n,1);
RunningGearNumberofRoadWheels = zeros(n,1);
SMETFCCWidth = zeros(n,1);
ExtraMuttStorageWidth = zeros(n,1);
FrameMaterialUsed = zeros(n,1);
BaseMUTTMaterial = zeros(n,1);
SMETFCCCtoCTurningDiameter = zeros(n,1);
RunningGearTrackLength = zeros(n,1);
OverbodyProtectableSurfaceArea = zeros(n,1);
SMETClimbHeight = zeros(n,1);
RunningGearWeightLimit=zeros(n,1);
UpperCargoStorageLength = zeros(n,1);
SMETPlatformSprungWeight = zeros(n,1);
RunningGearSprungWeight = zeros(n,1);
UnderbodyProtectableSurfaceArea = zeros(n,1);
UpperCargoStorageWidth = zeros(n,1);
SMETPlatformLength = zeros(n,1);
WidthScore = zeros(n,1);
HeightScore = zeros(n,1);
GroundClearanceScore = zeros(n,1);
Agility = zeros(n,1);
CurbtoCurbTurningDiameterScore = zeros(n,1);
ClimbHeightScore = zeros(n,1);
Maneuverability = zeros(n,1);
TotalPlatformWeightCapacity = zeros(n,1);
UpperCargoPracticalHeight = zeros(n,1);
UpperCargoPracticalStorageVolume = zeros(n,1);
TotalPlatformVolumeCapacity = zeros(n,1);
LoadCapacitybyWeight = zeros(n,1);
LoadCapacitybyVolume = zeros(n,1);
LoadCapacity = zeros(n,1);
CH47SlingScore = zeros(n,1);
UH60SlingScore = zeros(n,1);
CH47InteriorFit = zeros(n,1);
CH47InteriorFitwithSquad = zeros(n,1);
NATOPalletResidualLength = zeros(n,1);
NATOPalletResidualWidth = zeros(n,1);
NATOPalletWidthFit = zeros(n,1);
NATOPalletLengthFit = zeros(n,1);
NATOPalletMaxFit = zeros(n,1);
Transportability = zeros(n,1);
q = zeros(n,1);
r = zeros(n,1);

%% Calculate Derived Attributes

for i = 1:n
    
% Underbody Axle Mount Height    
   
    UnderbodyAxleMountHeight(i,1) = 0.5*Data.FrameUnderbodyHeight(i,1)-Data.FrameMaterialThickness(i,1)-Data.RunningGearInsetMountHeight(i,1)+Data.FrameMaterialThickness(i,1);
 
% SMET Ground Clearance
    
    SMETGroundClearance(i,1) = Data.RunningGearHeight(i,1)-UnderbodyAxleMountHeight(i,1)-Data.RunningGearInsetMountHeight(i,1);

% Back Deck Overhang

    BackDeckOverhang(i,1) = max(0,(Data.RunningGearBackMountInset(i,1)-Data.FrameAxleMountInset(i,1)));    
    
% Axle Separation

    AxleSeparation(i,1) = Data.FrameUnderbodyLength(i)-2*Data.FrameAxleMountInset(i);    

% Running Gear Wheel Contact Patch Arc

if Data.RunningGearWheelTypeNone(i) == 1
    RunningGearWheelContactPatchArc(i) = 0;
else
    RunningGearWheelContactPatchArc(i) = 69.99;
end

% Running Gear Mattrack Ground Contact Length

if Data.RunningGearMattrackTypeEZUTV(i)==1
    RunningGearMattrackGroundContactLength(i)=48;
elseif Data.RunningGearMattrackTypeEZATV(i)==1
    RunningGearMattrackGroundContactLength(i)=45;
else
end

% Running Gear Contact Patch Area
    
if Data.RunningGearTypeFourWheeled(i,1) == 1 % Four-Wheeled    
    RunningGearContactPatchArea(i,1) = 4*2*pi*Data.RunningGearWheelRadius(i,1)*RunningGearWheelContactPatchArc(i,1)/360*Data.RunningGearWheelWidth(i,1);    

elseif Data.RunningGearTypeSixWheeled(i,1) == 1 % Six-Wheeled    
    RunningGearContactPatchArea(i,1) = 6*2*pi*Data.RunningGearWheelRadius(i,1)*RunningGearWheelContactPatchArc(i,1)/360*Data.RunningGearWheelWidth(i,1);

elseif Data.RunningGearTypeEightWheeled(i,1) == 1 % Eight-Wheeled    
    RunningGearContactPatchArea(i,1) = 8*2*pi*Data.RunningGearWheelRadius(i,1)*RunningGearWheelContactPatchArc(i,1)/360*Data.RunningGearWheelWidth(i,1);

elseif Data.RunningGearTypeMattrack(i,1) == 1 % Mattracks        
    RunningGearContactPatchArea(i,1) = 4*RunningGearMattrackGroundContactLength(i,1)*Data.RunningGearMattrackTrackThickness(i,1);    

elseif Data.RunningGearTypeOvalTrack(i,1) == 1 % Oval Track        
    RunningGearContactPatchArea(i,1) = 2*(Data.FrameUnderbodyLength(i,1)-2*Data.FrameAxleMountInset(i,1))*Data.RunningGearTrackWidth(i,1);

elseif Data.RunningGearTypeTrapezoidalTrack(i,1) == 1 % Trapezoid Track        
    if RunningGearDriveGearRadius(i,1)>=RunningGearRoadWheelRadius(i,1)            
        RunningGearContactPatchArea(i,1) = 2*(Data.FrameUnderbodyLength(i,1)-2*Data.FrameAxleMountInset(i,1)-3.414*RunningGearRoadWheelRadius(i,1)-0.586*RunningGearDriveGearRadius(i,1))*Data.RunningGearTrackWidth(i,1);            
    else            
        RunningGearContactPatchArea(i,1) = 2*(Data.FrameUnderbodyLength(i,1)-2*Data.FrameAxleMountInset(i,1)-5.414*RunningGearRoadWheelRadius(i,1)+1.414*RunningGearDriveGearRadius(i,1))*Data.RunningGearTrackWidth(i,1);            
    end

elseif Data.RunningGearTypeParallelogramTrack(i,1) == 1 % Parallelogram Track
    RunningGearContactPatchArea(i,1) = 2*(Data.FrameUnderbodyLength(i,1)-2*Data.FrameAxleMountInset(i,1)-1.414*RunningGearRoadWheelRadius(i)+1.414*RunningGearDriveGearRadius(i))*Data.RunningGearTrackWidth(i);
else
end

% Running Gear Width

if Data.RunningGearTypeFourWheeled(i)==1 || Data.RunningGearTypeSixWheeled(i)==1 || Data.RunningGearTypeEightWheeled(i)==1
    if Data.SteeringTypeNameSingleAckerman(i)==1 || Data.SteeringTypeNameDualAckerman(i)==1
        RunningGearWidth(i) = Data.RunningGearWheelWidth(i)*cos(InputConstants{47,3})+2*Data.RunningGearWheelRadius(i)*sin(InputConstants{47,3});
    else
        RunningGearWidth(i) = Data.RunningGearWheelWidth(i);
    end
elseif Data.RunningGearTypeOvalTrack(i,1) == 1 || Data.RunningGearTypeTrapezoidalTrack(i,1) == 1 || Data.RunningGearTypeParallelogramTrack(i,1) == 1
    m=max(Data.RunningGearTrackWidth(i),Data.RunningGearDriveGearWidth(i));
    RunningGearWidth(i) = max(m,Data.RunningGearRoadWheelWidth(i));
elseif Data.RunningGearTypeMattrack(i,1) == 1
    if Data.SteeringTypeNameSingleAckerman(i)==1 || Data.SteeringTypeNameDualAckerman(i)==1
        RunningGearWidth(i) = Data.RunningGearMattrackWidth(i)*cos(InputConstants{46,3})+Data.RunningGearMattrackLength(i)*sin(InputConstants{46,3});
    else
        RunningGearWidth(i) = Data.RunningGearMattrackWidth(i);
    end
else
end
        
% Front Deck Overhang

a = max(0,(Data.RunningGearFrontMountInset(i)-Data.FrameAxleMountInset(i)));
b = max(0,Data.WinchStowedWidth(i));
FrontDeckOverhang(i,1) = max(a,b);  
    
% SMET FCC Length    

SMETFCCLength(i,1) = Data.FrameUnderbodyLength(i)+FrontDeckOverhang(i,1)+BackDeckOverhang(i,1);

% Total FCC Load Volume

TotalFCCLoadVolume(i,1) = (9*InputConstants{51,3}*InputConstants{48,3}*InputConstants{49,3}+InputConstants{57,3}*153+InputConstants{54,3}*InputConstants{76,3}+InputConstants{55,3}*InputConstants{77,3}+InputConstants{56,3}*231.001)/InputConstants{60,3};

% Offload Generator Volume

OffloadGeneratorVolume(i,1) = Data.OffloadGeneratorLength(i)*Data.OffloadGeneratorHeight(i)*Data.OffloadGeneratorWidth(i);    
    
% SMET Platform Length

SMETPlatformLength(i,1) = Data.FrameUnderbodyLength(i)+FrontDeckOverhang(i,1)+BackDeckOverhang(i,1);
    
% SMET Platform Width    

SMETPlatformWidth(i,1) = Data.FrameUnderbodyWidth(i)+2*RunningGearWidth(i);   
    
% Lower Cargo Storage Volume
    
if Data.FrameShapeBox(i) == 1 % Box        
    LowerCargoStorageVolume(i,1) = 0;        
elseif Data.FrameShapeMUTT(i) == 1 % MUTT        
    LowerCargoStorageVolume(i,1) = SMETPlatformLength(i,1)*Data.FrameUnderbodyWidth(i)*Data.FrameOverbodyHeight(i);    
elseif Data.FrameFCCLoadingStyle(i) == 0 % Flush with Frame        
    LowerCargoWidth(i,1) = SMETPlatformWidth(i,1);
elseif Data.FrameFCCLoadingStyle(i) == 1 % Hanging over Frame        
    LowerCargoWidth(i,1) = SMETPlatformWidth(i,1)+2*InputConstants{49,3};    
elseif Data.FrameShapeProtector(i) == 1 % Protector        
    LowerCargoStorageVolume(i,1) = SMETPlatformLength(i,1)-0.65*Data.FrameUnderbodyLength(i)-FrontDeckOverhang(i,1)*LowerCargoWidth(i,1)*Data.FrameOverbodyHeight(i);    
elseif Data.FrameShapeSMSS(i) == 1 % SMSS    
    LowerCargoStorageVolume(i,1) = SMETPlatformLength(i,1)-0.35*Data.FrameUnderbodyLength(i)-FrontDeckOverhang(i,1)*LowerCargoWidth(i,1)*Data.FrameOverbodyHeight(i)+2*0.35*Data.FrameUnderbodyLength(i)*(LowerCargoWidth(i,1)-Data.FrameUnderbodyWidth(i))*Data.FrameOverbodyHeight(i);
else
end
        
% SMET FCC Width

if Data.FrameShapeMUTT(i) == 1 % MUTT        
    if LowerCargoStorageVolume(i,1) >= TotalFCCLoadVolume(i,1)+OffloadGeneratorVolume(i,1)
        SMETFCCWidth(i,1) = SMETPlatformWidth(i,1);            
    else
    end            
elseif Data.FrameFCCLoadingStyle(i) == 0 % Flush with Frame        
    SMETFCCWidth(i,1) = SMETPlatformWidth(i,1);        
elseif Data.FrameFCCLoadingStyle(i) == 1 % Hanging over Frame        
    SMETFCCWidth(i,1) = SMETPlatformWidth(i,1)+2*InputConstants{49,3};        
else
end

% Max Ackerman Angle    
  
if Data.RunningGearTypeFourWheeled(i,1) == 1 % Four-Wheeled
        MaxAckermanAngle(i,1) = InputConstants{47,3};    
    elseif Data.RunningGearTypeSixWheeled(i,1) == 1 % Six-Wheeled 
        MaxAckermanAngle(i,1) = InputConstants{47,3};            
    elseif Data.RunningGearTypeEightWheeled(i,1) == 1 % Eight-Wheeled
        MaxAckermanAngle(i,1) = InputConstants{47,3};            
    elseif Data.RunningGearTypeOvalTrack(i,1) == 1 % Oval Track
        MaxAckermanAngle(i,1) = InputConstants{46,3};            
    elseif Data.RunningGearTypeTrapezoidalTrack(i,1) == 1 % Trapezoid Track
        MaxAckermanAngle(i,1) = InputConstants{46,3};            
    elseif Data.RunningGearTypeParallelogramTrack(i,1) == 1 % Parallelogram Track
        MaxAckermanAngle(i,1) = InputConstants{46,3};        
    elseif Data.RunningGearTypeMattrack(i,1) == 1 % Mattracks 
        MaxAckermanAngle(i,1) = InputConstants{46,3}; 
else
end

% SMET FCC Curb-to-Curb Turning Diameter

if Data.SteeringTypeNamePivot(i) == 1 % Pivot        
    SMETFCCCtoCTurningDiameter(i,1) = sqrt((SMETFCCLength(i,1))^2+(SMETFCCWidth(i,1))^2);
elseif Data.SteeringTypeNameSkid(i) == 1 % Skid        
    SMETFCCCtoCTurningDiameter(i,1) = 2*sqrt((SMETFCCLength(i,1)/2)^2+((SMETFCCWidth(i,1)+SMETPlatformWidth(i,1)-RunningGearWidth(i))/2)^2);
else
    if Data.SteeringTypeNameSingleAckerman(i) == 1 % Single Ackerman            
        InnerTurningRadius(i,1) = AxleSeparation(i,1)/tan(MaxAckermanAngle(i,1));            
    elseif Data.SteeringTypeNameDualAckerman(i) == 1 % Dual Ackerman            
        InnerTurningRadius(i,1) = 0.5*AxleSeparation(i,1)/tan(MaxAckermanAngle(i,1));            
    else
    end
end

SMETFCCCtoCTurningDiameter(i,1) = SMETFCCWidth(i,1)+SMETPlatformWidth(i,1)-RunningGearWidth(i)+2*InnerTurningRadius(i,1);

% Upper Cargo Storage Length

if Data.FrameShapeBox(i)==1 || Data.FrameShapeMUTT(i)==1
    UpperCargoStorageLength(i) = SMETPlatformLength(i);
else
    UpperCargoStorageLength(i) = SMETPlatformLength(i)-FrontDeckOverhang(i);
end
    
% Upper Cargo Storage Width

if Data.FrameFCCLoadingStyle(i)==0 %flush
    UpperCargoStorageWidth(i)=SMETPlatformWidth(i);
else
    UpperCargoStorageWidth(i)=SMETPlatformWidth(i)+2*InputConstants{49,3};
end

% Upper Cargo Storage Height

UpperCargoStorageHeight(i) = max(0,(TotalFCCLoadVolume(i)+OffloadGeneratorVolume(i)-LowerCargoStorageVolume(i)))/(UpperCargoStorageLength(i)*UpperCargoStorageWidth(i));
    
% SMET FCC Height
   
j = [Data.CamerasHeight(i),Data.LIDARHeight(i),Data.RADARHeight(i),Data.FrameOverbodyHeight(i),UpperCargoStorageHeight(i)];
if Data.AntennaBendableYN == 1 % yes
    k = Data.AntennaStowedLength(i);
else
    k = Data.AntennaExtendedLength(i);
end
SMETFCCHeight(i,1) = SMETGroundClearance(i)+Data.FrameUnderbodyHeight(i)+Data.FrameMaterialThickness(i)+max(max(j),k);
    
% Underbody Protectable Surface Area

UnderbodyProtectableSurfaceArea(i) = 2*Data.FrameUnderbodyLength(i)*Data.FrameUnderbodyHeight(i)+2*Data.FrameUnderbodyWidth(i)*Data.FrameUnderbodyHeight(i);

% Overbody Protectable Surface Area    

if Data.FrameShapeBox(i) == 1
    OverbodyProtectableSurfaceArea(i) = 0;
elseif Data.FrameShapeMUTT(i) == 1
    OverbodyProtectableSurfaceArea(i) = 2*SMETPlatformLength(i)*Data.FrameOverbodyHeight(i)+4*RunningGearWidth(i)*Data.FrameOverbodyHeight(i);
elseif Data.FrameShapeProtector == 1
    OverbodyProtectableSurfaceArea(i) = 2*0.65*Data.FrameUnderbodyLength(i)*Data.FrameOverbodyHeight(i)+2*SMETPlatformWidth(i)*Data.FrameOverbodyHeight(i);
elseif Data.FrameShapeSMSS == 1
    OverbodyProtectableSurfaceArea(i) = 2*0.35*Data.FrameUnderbodyLength(i)*Data.FrameOverbodyHeight(i)+2*Data.FrameUnderbodyWidth(i)*Data.FrameOverbodyHeight(i);
else
end

% Underbody and Deck Material

UnderbodyandDeckMaterial(i) = materialused(Data.FrameUnderbodyLength(i),Data.FrameUnderbodyWidth(i),Data.FrameUnderbodyHeight(i),Data.FrameMaterialThickness(i))+SMETPlatformLength(i)*SMETPlatformWidth(i)*Data.FrameMaterialThickness(i);

% Base MUTT Material

BaseMUTTMaterial(i) = UnderbodyandDeckMaterial(i)+2*materialused(SMETPlatformLength(i),RunningGearWidth(i),Data.FrameOverbodyHeight(i),Data.FrameMaterialThickness(i));
    
% Frame Material Used

if Data.FrameShapeBox == 1
    FrameMaterialUsed(i) = UnderbodyandDeckMaterial(i);
elseif Data.FrameShapeProtector == 1
    FrameMaterialUsed(i) = UnderbodyandDeckMaterial(i)+materialused(0.65*Data.FrameUnderbodyLength(i),SMETPlatformWidth(i),Data.FrameOverbodyHeight(i),Data.FrameMaterialThickness(i));
elseif Data.FrameShapeSMSS == 1
    FrameMaterialUsed(i) = UnderbodyandDeckMaterial(i)+materialused(0.35*Data.FrameUnderbodyLength(i),FrameUnderbodyWidth(i),Data.FrameOverbodyHeight(i),Data.FrameMaterialThickness(i));
elseif Data.FrameShapeMUTT == 1
    if Data.RunningGearTypeFourWheeled == 1
        ExtraMuttStorageWidth(i) = Data.FrameUnderbodyLength(i)-2*(Data.FrameAxleMountInset(i)+Data.RunningGearInsetMountHeight(i));
        if ExtraMuttStorageWidth(i)-2*Data.FrameMaterialThickness(i) > 0
            FrameMaterialUsed(i) = 2*materialused(Data.FrameUnderbodyHeight(i),ExtraMuttStorageWidth(i),Data.RunningGearWidth(i),Data.FrameMaterialThickness(i));
        else
            FrameMaterialUsed(i) = 0;
        end
    elseif Data.RunningGearTypeMattracks == 1
        ExtraMuttStorageWidth(i) = 0.8*(Data.FrameUnderbodyLength(i)-2*(Data.FrameAxleMountInset(i)+Data.RunningGearInsetMountHeight(i)));
        if ExtraMuttStorageWidth(i)-2*Data.FrameMaterialThickness(i) > 0
            FrameMaterialUsed(i) = 2*materialused(Data.FrameUnderbodyHeight(i),ExtraMuttStorageWidth(i),Data.RunningGearWidth(i),Data.FrameMaterialThickness(i));
        else
            FrameMaterialUsed(i) = 0;
        end
    else
        FrameMaterialUsed(i) = BaseMUTTMaterial(i);
    end
else
end

% Ackerman Weight

if Data.SteeringTypeNameSingleAckerman == 1
    AckermanWeight(i) = InputConstants{63,3};
elseif Data.SteeringTypeNameDualAckerman == 1
    AckermanWeight(i) = 2*InputConstants{63,3};
else
    AckermanWeight(i) = 0;
end    
    
% Running Gear Weight

if Data.RunningGearTypeFourWheeled(i) == 1
    RunningGearWeight(i) = 4*Data.RunningGearWheelWeight(i)+4*Data.RunningGearSuspensionWeight(i)+AckermanWeight(i);
elseif Data.RunningGearTypeSixWheeled(i) == 1
    RunningGearWeight(i) = 6*Data.RunningGearWheelWeight(i)+6*Data.RunningGearSuspensionWeight(i)+AckermanWeight(i);
elseif Data.RunningGearTypeEightWheeled(i) == 1
    RunningGearWeight(i) = 8*Data.RunningGearWheelWeight(i)+8*Data.RunningGearSuspensionWeight(i)+AckermanWeight(i);
elseif Data.RunningGearTypeOvalTrack(i) == 1
    RunningGearWeight(i) = 2*Data.RunningGearDriveGearWeight(i)+2*Data.RunningGearRoadWheelWeight(i)*RunningGearNumberofRoadWheels(i)+2*Data.RunningGearSuspensionWeight(i)*(RunningGearNumberofRoadWheels(i)+1)+2*Data.RunningGearTrackWeightperInch(i)*RunningGearTrackLength(i);
elseif Data.RunningGearTypeParallelogramTrack(i) == 1 || Data.RunningGearTypeTrapezoidalTrack(i) == 1
    RunningGearWeight(i) = 2*Data.RunningGearDriveGearWeight(i)+2*Data.RunningGearRoadWheelWeight(i)*RunningGearNumberofRoadWheels(i)+2*Data.RunningGearSuspensionWeight(i)*(RunningGearNumberofRoadWheels(i)+1)+2*Data.RunningGearTrackWeightperInch(i)*RunningGearTrackLength(i);
elseif Data.RunningGearTypeMattrack(i) == 1
    RunningGearWeight(i) = Data.RunningGearMattrackWeightperMattrack(i)+AckermanWeight(i);
else
end       
    
% Frame Weight

FrameWeight(i) = Data.FrameMaterialWeightperin3(i)*FrameMaterialUsed(i);
    
% SMET Platform Weight

SMETPlatformWeight(i) = Data.ChemicalFuelStorageTankEmptyWeight(i)+Data.InternalCombustionEngineWeight(i)+Data.ElectricMotorandControllerWeight(i)+Data.FuelCellWeight(i)+Data.LowVoltageBatteryWeight(i)+Data.TractionBatteryWeight(i)+Data.BurstCapacitorWeight(i)+Data.GeneratorWeight(i)+Data.GeneratorInverterWeight(i)+Data.InverterWeight(i)+Data.TransmissionWeight(i)+Data.AutomotiveCoolingSystemWeight(i)+Data.ElectronicsCoolingSystemWeight(i)+Data.WinchWeight(i)+(UnderbodyProtectableSurfaceArea(i)+OverbodyProtectableSurfaceArea(i))*Data.ArmorCoverage(i)*Data.ArmorWeightperin2(i)+Data.ComputersWeight(i)+Data.ComputerBackupPowerWeight(i)+Data.TetherSystemWeight(i)+Data.RemoteControlRadioWeight(i)+Data.AntennaWeight(i)+Data.GPSWeight(i)+Data.AccelerometersWeight(i)+Data.MagnetometersWeight(i)+Data.GyroscopicSensorsWeight(i)+Data.PositionFeedbackSensorsWeight(i)+Data.LIDARWeight(i)+Data.RADARWeight(i)+Data.CamerasWeight(i)+FrameWeight(i)+RunningGearWeight(i)+InputConstants{6,3}+InputConstants{39,3}+InputConstants{66,3}+InputConstants{71,3}+InputConstants{31,3}+InputConstants{44,3}+InputConstants{17,3};

% Total FCC Load Weight

TotalFCCLoadWeight(i) = 9*InputConstants{50,3}+InputConstants{57,3}*5/3+InputConstants{54,3}*InputConstants{79,3}+InputConstants{55,3}*InputConstants{80,3}+InputConstants{56,3}*InputConstants{78,3};
    
% SMET FCC Weight

if Data.OffloadGeneratorFuelTypeDiesel == 1
    q(i) = Data.OffloadGeneratorCapacity(i)*InputConstants{22,3};
elseif Data.OffloadGeneratorFuelTypeJP8 == 1
    q(i) = Data.OffloadGeneratorCapacity(i)*InputConstants{36,3};
else
end

if Data.InternalCombustionEngineFuelTypeDiesel(i) == 1 || Data.FuelCellFuelTypeDiesel(i) == 1
    r(i) = Data.ChemicalFuelStorageTankCapacity(i)*InputConstants{22,3};
elseif Data.InternalCombustionEngineFuelTypeJP8(i) == 1 || Data.FuelCellFuelTypeJP8(i) == 1
    r(i) = Data.ChemicalFuelStorageTankCapacity(i)*InputConstants{36,3};
else
end

SMETFCCWeight(i) = SMETPlatformWeight(i)+TotalFCCLoadWeight(i)+Data.OffloadGeneratorEmptyWeight(i)+q(i)+r(i);

% Running Gear Drive Gear Radius

if Data.RunningGearDriveGearRadius5(i) == 1
    RunningGearDriveGearRadius(i) = 5;
elseif Data.RunningGearDriveGearRadius6(i) == 1
    RunningGearDriveGearRadius(i) = 6;
elseif Data.RunningGearDriveGearRadius7(i) == 1
    RunningGearDriveGearRadius(i) = 7;
else
end
    
% Running Gear Road Wheel Radius

if Data.RunningGearRoadWheelRadius35(i) == 1
    RunningGearRoadWheelRadius(i) = 3.5;
elseif Data.RunningGearRoadWheelRadius4(i) == 1
    RunningGearRoadWheelRadius(i) = 4;
elseif Data.RunningGearRoadWheelRadius5(i) == 1
    RunningGearRoadWheelRadius(i) = 5;
elseif Data.RunningGearRoadWheelRadius6(i) == 1
    RunningGearRoadWheelRadius(i) = 6;
elseif Data.RunningGearRoadWheelRadius7(i) == 1
    RunningGearRoadWheelRadius(i) = 7;
else
end
    
% Running Gear Back Mount Inset

if Data.RunningGearTypeFourWheeled(i) == 1 || Data.RunningGearTypeSixWheeled(i) == 1 || Data.RunningGearTypeEightWheeled(i) == 1
    RunningGearBackMountInset(i) = Data.RunningGearWheelRadius(i);
elseif Data.RunningGearTypeOvalTrack(i) == 1 || Data.RunningGearTypeTrapezoidalTrack(i) == 1
    RunningGearBackMountInset(i) = Data.RunningGearTrackThickness(i)+RunningGearRoadWheelRadius(i);
elseif Data.RunningGearTypeParallelogramTrack == 1
    RunningGearBackMountInset(i) = Data.RunningGearTrackThickness(i)+3*RunningGearRoadWheelRadius(i);
elseif Data.RunningGearTypeMattrack == 1
    RunningGearBackMountInset(i) = Data.RunningGearMattrackInsetLength(i);
else
end    
    
% Running Gear Front Mount Inset

if Data.RunningGearTypeFourWheeled(i) == 1 || Data.RunningGearTypeSixWheeled(i) == 1 || Data.RunningGearTypeEightWheeled(i) == 1
    RunningGearFrontMountInset(i) = Data.RunningGearWheelRadius(i);
elseif Data.RunningGearTypeOvalTrack(i) == 1 || Data.RunningGearTypeTrapezoidalTrack(i) == 1 || Data.RunningGearTypeParallelogramTrack(i) == 1
    if Data.RunningGearDriveGearRadius5(i) == 1
        RunningGearFrontMountInset(i) = Data.RunningGearTrackThickness(i)+5;
    elseif Data.RunningGearDriveGearRadius6(i) == 1
        RunningGearFrontMountInset(i) = Data.RunningGearTrackThickness(i)+6;
    elseif Data.RunningGearDriveGearRadius7(i) == 1
        RunningGearFrontMountInset(i) = Data.RunningGearTrackThickness(i)+7;
    else
    end
elseif Data.RunningGearTypeMattrack == 1
    RunningGearFrontMountInset(i) = Data.RunningGearMattrackInsetLength(i);
else
end
    
% Running Gear Height

if Data.RunningGearTypeFourWheeled(i) == 1 || Data.RunningGearTypeSixWheeled(i) == 1 || Data.RunningGearTypeEightWheeled(i) == 1
    RunningGearHeight(i) = 2*Data.RunningGearWheelRadius(i);
elseif Data.RunningGearTypeOvalTrack(i) == 1
    RunningGearHeight(i) = 2*Data.RunningGearTrackThickness(i)+2*RunningGearRoadWheelRadius(i);
elseif Data.RunningGearTypeParallelogramTrack(i) == 1 || Data.RunningGearTypeTrapezoidalTrack(i) == 1
    RunningGearHeight(i) = 2*(Data.RunningGearTrackThickness(i)+2*RunningGearRoadWheelRadius(i))+2*max(RunningGearRoadWheelRadius(i),RunningGearDriveGearRadius(i));
elseif Data.RunningGearTypeMattrack(i) == 1
    RunningGearHeight(i) = Data.RunningGearMattrackHeight(i);
else
end

% Running Gear Inset Mount Height

if Data.RunningGearTypeFourWheeled(i) == 1 || Data.RunningGearTypeSixWheeled(i) == 1 || Data.RunningGearTypeEightWheeled(i) == 1
    RunningGearInsetMountHeight(i) = 2*Data.RunningGearWheelRadius(i);
elseif Data.RunningGearTypeOvalTrack(i) == 1
    RunningGearInsetMountHeight(i) = 2*Data.RunningGearTrackThickness(i)+2*RunningGearRoadWheelRadius(i);
elseif Data.RunningGearTypeParallelogramTrack(i) == 1 || Data.RunningGearTypeTrapezoidalTrack(i) == 1
    RunningGearInsetMountHeight(i) = Data.RunningGearTrackThickness(i)+max(RunningGearRoadWheelRadius(i),RunningGearDriveGearRadius(i));
elseif Data.RunningGearTypeMattrack == 1
    RunningGearInsetMountHeight(i) = Data.RunningGearMattrackThickness(i)+Data.RunningGearMattrackDriveGearRadius(i);
else
end    
    


% Running Gear Number of Road Wheels

if Data.RunningGearTypeFourWheeled(i) == 1
    RunningGearNumberofRoadWheels(i) = 0;
elseif Data.RunningGearTypeSixWheeled(i) == 1
    RunningGearNumberofRoadWheels(i) = 0;
elseif Data.RunningGearTypeEightWheeled(i) == 1
    RunningGearNumberofRoadWheels(i) = 0;
else
    if Data.RunningGearTypeOvalTrack(i) == 1
        RoadWheelSpace(i) = Data.FrameUnderbodyLength(i)-2*Data.FrameAxleMountInset(i)+2*RunningGearDriveGearRadius(i)-RunningGearRoadWheelRadius(i);
        RunningGearNumberofRoadWheels(i) = min(1+floor(RoadWheelSpace(i)/2/RunningGearRoadWheelRadius(i)),4);
    elseif Data.RunningGearTypeTrapezoidalTrack(i) == 1
        if RunningGearDriveGearRadius(i)>=RunningGearRoadWheelRadius
            RoadWheelSpace(i) = Data.FrameUnderbodyLength(i)-2*Data.FrameAxleMountInset(i)-3.414*RunningGearRoadWheelRadius(i)-0.586*RunningGearDriveGearRadius(i)-2*RunningGearRoadWheelRadius(i);
        else
            RoadWheelSpace(i) = Data.FrameUnderbodyLength(i)-2*Data.FrameAxleMountInset(i)-5.414*RunningGearRoadWheelRadius(i)+1.414*RunningGearDriveGearRadius(i)-2*RunningGearRoadWheelRadius(i);
        end
    elseif Data.RunningGearTypeParallelogramTrack == 1
        RoadWheelSpace(i) = Data.FrameUnderbodyLength(i)-2*Data.FrameAxleMountInset(i)-1.414*RunningGearRoadWheelRadius(i)+1.414*RunningGearDriveGearRadius(i)-2*RunningGearRoadWheelRadius(i);
    elseif Data.RunningGearTypeMattrack == 1
        RunningGearNumberofRoadWheels(i) = Data.RunningGearMattrackWeightperMattrack(i)+AckermanWeight(i);
    else
    end
RunningGearNumberofRoadWeels(i) = min(3+floor(RoadWheelSpace(i)/2/RunningGearRoadWheelRadius(i)),6);
end  

% Running Gear Track Length

if Data.RunningGearTypeFourWheeled(i) == 1 || Data.RunningGearTypeSixWheeled(i) == 1 || Data.RunningGearTypeEightWheeled(i) == 1 || Data.RunningGearTypeMattrack(i) == 1
    RunningGearTrackLength(i) = 0;
elseif Data.RunningGearTypeOvalTrack(i) == 1
    RunningGearTrackLength(i) = 2*(AxleSeparation(i)+2*pi*RunningGearRoadWheelRadius(i));
elseif Data.RunningGearTypeTrapezoidalTrack(i) == 1
    if RunningGearDriveGearRadius(i)>=RunningGearRoadWheelRadius(i)
        RunningGearTrackLength(i) = sqrt(2*(0.293*RunningGearDriveGearRadius(i)+1.707*RunningGearRoadWheelRadius(i))^2)+sqrt((RunningGearDriveGearRadius(i)-RunningGearRoadWheelRadius(i))^2+(AxleSeparation(i))^2)+sqrt(2*(RunningGearDriveGearRadius(i)+RunningGearRoadWheelRadius(i))^2)+AxleSeparation(i)-3.414*RunningGearRoadWheelRadius(i)-0.586*RunningGearDriveGearRadius(i)+0.375*2*pi*RunningGearDriveGearRadius(i)+0.625*2*pi*RunningGearRoadWheelRadius(i);
    elseif RunningGearDriveGearRadius(i)<RunningGearRoadWheelRadius(i)
        RunningGearTrackLength(i) = sqrt(2*(2.707*RunningGearDriveGearRadius(i)-0.707*RunningGearRoadWheelRadius(i))^2)+sqrt((-RunningGearDriveGearRadius(i)+RunningGearRoadWheelRadius(i))^2+(AxleSeparation(i))^2)+sqrt(8*(RunningGearRoadWheelRadius(i))^2)+AxleSeparation(i)-5.414*RunningGearRoadWheelRadius(i)+1.414*RunningGearDriveGearRadius(i)+0.375*2*pi*RunningGearDriveGearRadius(i)+0.625*2*pi*RunningGearRoadWheelRadius(i);
    else
    end
elseif Data.RunningGearTypeParallelogramTrack == 1
    if RunningGearDriveGearRadius(i)>=RunningGearRoadWheelRadius(i)
        RunningGearTrackLength(i) = sqrt(2*(0.293*RunningGearDriveGearRadius(i)+1.707*RunningGearRoadWheelRadius(i))^2)+sqrt((RunningGearDriveGearRadius(i)-RunningGearRoadWheelRadius(i))^2+(AxleSeparation(i))^2)+sqrt(2*(RunningGearDriveGearRadius(i)+RunningGearRoadWheelRadius(i))^2)+AxleSeparation(i)-3.414*RunningGearRoadWheelRadius(i)-0.586*RunningGearDriveGearRadius(i)+0.375*2*pi*RunningGearDriveGearRadius(i)+0.625*2*pi*RunningGearRoadWheelRadius(i);
    else
        RunningGearTrackLength(i) = sqrt(2*(2.707*RunningGearDriveGearRadius(i)-0.707*RunningGearRoadWheelRadius(i))^2)+sqrt((-RunningGearDriveGearRadius(i)+RunningGearRoadWheelRadius(i))^2+(AxleSeparation(i))^2)+sqrt(8*(RunningGearRoadWheelRadius(i))^2)+AxleSeparation(i)-5.414*RunningGearRoadWheelRadius(i)+1.414*RunningGearDriveGearRadius(i)+0.375*2*pi*RunningGearDriveGearRadius(i)+0.625*2*pi*RunningGearRoadWheelRadius(i);
    end
end  

% Running Gear Sprung Weight

if Data.RunningGearTypeFourWheeled(i) == 1 || Data.RunningGearTypeSixWheeled(i) == 1 || Data.RunningGearTypeEightWheeled(i) == 1 || Data.RunningGearTypeOvalTrack(i) == 1 || Data.RunningGearTypeMattrack(i) == 1
    RunningGearSprungWeight(i) = AckermanWeight(i);
else
    RunningGearSprungWeight(i) = 2*Data.RunningGearDriveGearWeight(i)+2*Data.RunningGearRoadWheelWeight(i);
end  

% SMET Platform Sprung Weight

SMETPlatformSprungWeight(i) = SMETPlatformWeight(i)-RunningGearWeight(i)+RunningGearSprungWeight(i);

% Running Gear Weight Limit

if Data.RunningGearTypeFourWheeled(i)==1
    RunningGearWeightLimit(i)=4*Data.RunningGearWheelWeightLimit(i);
elseif Data.RunningGearTypeSixWheeled(i)==1
    RunningGearWeightLimit(i)=6*Data.RunningGearWheelWeightLimit(i);
elseif Data.RunningGearTypeEightWheeled(i)==1
    RunningGearWeightLimit(i)=8*Data.RunningGearWheelWeightLimit(i);
elseif Data.RunningGearTypeMattrack(i)==1
    RunningGearWeightLimit(i)=4*Data.RunningGearMattrackSuspensionWeightLimit(i);
elseif Data.RunningGearTypeOvalTrack(i)==1
    RunningGearWeightLimit(i)=2*Data.RunningGearSuspensionWeightLimit(i)*(RunningGearNumberofRoadWheels(i)+1);
elseif Data.RunningGearTypeTrapezoidalTrack(i)==1 || Data.RunningGearTypeParallelogramTrack(i)==1
    RunningGearWeightLimit(i)=2*Data.RunningGearSuspensionWeightLimit(i)*(RunningGearNumberofRoadWheels(i)-1);
else
end

% SMET Climb Height

if Data.RunningGearTypeMattrack(i)==1
    SMETClimbHeight(i)=Data.RunningGearMattrackClimbHeight(i);
else
    SMETClimbHeight(i) = Data.RunningGearHeight(i) - RunningGearInsetMountHeight(i);
end

%% Transportability Score

if SMETFCCWeight(i)+Data.OCUHardwareWeight(i)+Data.OCUReceiverWeight(i)<=InputConstants{11,3}
    CH47SlingScore(i) = 1;
else
    CH47SlingScore(i) = 0;
end

if SMETFCCWeight(i)+Data.OCUHardwareWeight(i)+Data.OCUReceiverWeight(i)<=InputConstants{75,3}
    UH60SlingScore(i) = 1;
else
    UH60SlingScore(i) = 0;
end

if SMETFCCWidth(i)<=InputConstants{9,3}
    if SMETFCCHeight(i)<=InputConstants{7,3}
        t = 1;
    else
        t = 0;
    end
    CH47InteriorFit(i) = 1*floor(InputConstants{8,3}/SMETFCCLength(i))*t;
else
    CH47InteriorFit(i) = 0;
end

if SMETFCCWidth(i)<=InputConstants{10,3}
    if SMETFCCHeight(i)<=InputConstants{7,3}
        s = 1;
    else
        s = 0;
    end
    CH47InteriorFitwithSquad(i) = 1*floor(InputConstants{8,3}/SMETFCCLength(i))*s;
else
    CH47InteriorFitwithSquad(i) = 0;
end

NATOPalletResidualLength(i) = InputConstants{52,3}-floor(InputConstants{52,3}/SMETFCCLength(i))*SMETFCCLength(i);
NATOPalletResidualWidth(i) = InputConstants{53,3}-floor(InputConstants{53,3}/SMETFCCLength(i))*SMETFCCLength(i);
NATOPalletWidthFit(i) = floor(InputConstants{53,3}/SMETFCCWidth(i))*floor(InputConstants{52,3}/SMETFCCLength(i))+floor(NATOPalletResidualLength(i)/SMETFCCWidth(i))*floor(InputConstants{53,3}/SMETFCCLength(i));
NATOPalletLengthFit(i) = floor(InputConstants{53,3}/SMETFCCLength(i))*floor(InputConstants{52,3}/SMETFCCWidth(i))+floor(NATOPalletResidualLength(i)/SMETFCCWidth(i))*floor(InputConstants{52,3}/SMETFCCLength(i));
NATOPalletMaxFit(i) = max(NATOPalletWidthFit(i),NATOPalletLengthFit(i));

Transportability(i) = CH47SlingScore(i)+UH60SlingScore(i)+min(3,CH47InteriorFit(i))+min(1,CH47InteriorFitwithSquad(i))+min(1,NATOPalletMaxFit(i)/4);

%% Load Capacity Score

TotalPlatformWeightCapacity(i) = max(RunningGearWeightLimit(i)-SMETPlatformSprungWeight(i),0);
UpperCargoPracticalHeight(i) = max(InputConstants{61,3}-Data.FrameOverbodyHeight(i),0);
UpperCargoPracticalStorageVolume(i) = UpperCargoStorageLength(i)*UpperCargoStorageWidth(i)*UpperCargoPracticalHeight(i);
TotalPlatformVolumeCapacity(i) = LowerCargoStorageVolume(i)+UpperCargoPracticalStorageVolume(i);
LoadCapacitybyWeight(i) = TotalPlatformWeightCapacity(i)/TotalFCCLoadWeight(i);
LoadCapacitybyVolume(i) = TotalPlatformVolumeCapacity(i)/TotalFCCLoadVolume(i);

LoadCapacity(i) = min(LoadCapacitybyWeight(i),LoadCapacitybyVolume(i));

%% Maneuverability Score

CurbtoCurbTurningDiameterScore(i) = 1-min(max(SMETFCCCtoCTurningDiameter(i)-InputConstants{4,3},0)/InputConstants{25,3}-InputConstants{4,3},1);
ClimbHeightScore(i) = min(SMETClimbHeight(i)/InputConstants{24,3},1);
Maneuverability(i) = (CurbtoCurbTurningDiameterScore(i)+ClimbHeightScore(i))/2;

%% Agility Score

WidthScore(i) = min(InputConstants{4,3}/SMETFCCWidth(i),1);
HeightScore(i) = min(InputConstants{12,3}/SMETFCCHeight(i),1);
GroundClearanceScore(i) = min(SMETGroundClearance(i)/InputConstants{26,3},1);
Agility(i) = (2*WidthScore(i)+HeightScore(i)+GroundClearanceScore(i))/4;

end
%% Write Results to Data File

DataMatrix(:,w+1)=Transportability;
DataMatrix(:,w+2)=LoadCapacity;
DataMatrix(:,w+3)=Maneuverability;
DataMatrix(:,w+4)=Agility;

xlswrite('Results',DataMatrix);
