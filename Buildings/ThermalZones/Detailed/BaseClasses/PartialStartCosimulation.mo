within Buildings.ThermalZones.Detailed.BaseClasses;
partial function PartialStartCosimulation
  "Partial model for Starting the coupled simulation with CFD"
  input String cfdFilNam "CFD input file name";
  input String[nSur] name "Surface names";
  input Modelica.SIunits.Area[nSur] A "Surface areas";
  input Modelica.SIunits.Angle[nSur] til "Surface tilt";
  input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions[nSur] bouCon
    "Type of boundary condition";
  input Integer nPorts(min=0)
    "Number of fluid ports for the HVAC inlet and outlets";
  input String portName[nPorts]
    "Names of fluid ports as declared in the CFD input file";
  input Boolean haveSensor "Flag, true if the model has at least one sensor";
  input String sensorName[nSen]
    "Names of sensors as declared in the CFD input file";
  input Boolean haveShade "Flag, true if the windows have a shade";
  input Integer nSur "Number of surfaces";
  input Integer nSen(min=0)
    "Number of sensors that are connected to CFD output";
  input Integer nConExtWin(min=0) "number of exterior construction with window";
  input Integer nXi(min=0) "Number of independent species";
  input Integer nC(min=0) "Number of trace substances";
  input Boolean haveSource
    "Flag, true if the model has at least one source";
  input Integer nSou(min=0)
    "Number of sources that are connected to CFD output";
  input String sourceName[nSou]
    "Names of sources as declared in the CFD input file";
  input Modelica.SIunits.Density rho_start "Density at initial state";
  output Integer retVal
    "Return value of the function (0 indicates CFD successfully started.)";

  annotation (Documentation(info="<html>
<p>Partial model for the function that calls a C function to start the coupled simulation with CFD or ISAT.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end PartialStartCosimulation;
