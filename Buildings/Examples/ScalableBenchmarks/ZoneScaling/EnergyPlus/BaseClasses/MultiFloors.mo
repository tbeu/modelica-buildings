within Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus.BaseClasses;
model MultiFloors
  extends Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses.PartialMultiFloors(
    redeclare LargeOfficeFloor floors[floCou](floId=0:(floCou - 1)));

  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of the weather file";

protected
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/" +
    "ScalableLargeOffice/ScaledLargeOfficeNew2004_Chicago_" + String(floCou) + "floors.idf")
    "Name of the IDF file";

  inner Buildings.ThermalZones.EnergyPlus.Building building(
    idfName=idfName,
    weaName=weaName,
    computeWetBulbTemperature=false)
    "Building-level declarations"
    annotation (Placement(transformation(extent={{140,458},{160,478}})));

  annotation (
    Icon(graphics={Bitmap(extent={{192,-58},{342,-18}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/spawn_icon_darkbluetxmedres.png",
          visible=not usePrecompiledFMU)}));


end MultiFloors;
