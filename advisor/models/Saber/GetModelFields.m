function Fields=GetModelFields(ModelName)

% function GetFields(ModelName)
%   This function gets a list of fields for the specified Model

switch ModelName
    
case 'EnergyStorage14V'
    Fields={'NomAmpHourCap';...
            'NomCurrent';...
            'NomInternResist';...
            'SpecGravFullChrg';...
            'SpecGravFullDisChrg';...
            'HiTempCapFactor';...
            'FracCapNearPlate';...
            'MaxCapAtSlowDisChrg';...
            'CapLostSelfDisChrg'};
    
case 'Regulator14V'
    Fields={'VoltRegAdj';...
            'TempReg';...
            'VoltSetMax';...
            'LowTemp';...
            'HighTemp';...
            'LowVolt';...
            'HighVolt'};
    
case 'Generator14V'
    Fields={'MaxCurrentAtHighTemp';...
            'MaxCurrentAtLowTemp';...
            'CutInRpmAtHighTemp';...
            'CutInRpmAtLowTemp';...
            'GeneratorEff';...
            'AltInAirTemp';...
            'CalibrationTempHigh';...
            'CalibrationTempLow'};
    
case 'EnergyStorage42V'
    Fields={'NomAmpHourCap';...
            'NomCurrent';...
            'NomInternResist';...
            'SpecGravFullChrg';...
            'SpecGravFullDisChrg';...
            'HiTempCapFactor';...
            'FracCapNearPlate';...
            'MaxCapAtSlowDisChrg';...
            'CapLostSelfDisChrg'};
    
case 'Regulator42V'
    Fields={'VoltRegAdj';...
            'TempReg';...
            'VoltSetMax';...
            'LowTemp';...
            'HighTemp';...
            'LowVolt';...
            'HighVolt'};
    
case 'DCDCConverter42V'
    Fields={'Efficiency';...
            'MinVoltsOut';...
            'MaxVoltsOut';...
            'MaxCurrentOut';...
            'MinVoltsIn'};
    
    
end



