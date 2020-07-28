within Buildings.Controls.OBC.FDE.PackagedRTUs;
block TSupSet
  "Calculates supply air temperature set point for packaged RTU factory controller serving terminal units"
  parameter Real minSATset(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+14
   "Minimum supply air temperature reset value";
  parameter Real maxSATset(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+19
   "Maximum supply air temperature reset value";
  parameter Real HeatSet(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+35
  "Setback heating supply air temperature set point";
  parameter Real TUpcntT(
  min=0.1,
  max=0.9)=0.15
  "Minimum decimal percentage of terminal unit requests required for cool request reset";

  // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealInput highSpaceT(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Highest space temperature reported from all terminal units"
    annotation (Placement(transformation(extent={{-140,-88},{-100,-48}}),
        iconTransformation(extent={{-140,-88},{-100,-48}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput sbc
    "True when setback cooling mode active"
    annotation (Placement(
        transformation(extent={{-140,-16},{-100,24}}), iconTransformation(
          extent={{-140,-16},{-100,24}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput sbh
    "True when setback heating mode active"
    annotation (Placement(
        transformation(extent={{-140,-52},{-100,-12}}), iconTransformation(
          extent={{-140,-52},{-100,-12}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TotalTU
    "Total number of terminal units"
    annotation (Placement(transformation(extent={{-140,56},{-100,96}}),
        iconTransformation(extent={{-140,56},{-100,96}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totCoolReqs
    "Total terminal unit cooling requests"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  // ---output---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySATset(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Calculated supply air temperature set point"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=3,
    Ti=300,
    yMax=1,
    yMin=0,
    wp=1.5,
    reverseAction=true,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
    "Cooling requests PI calculation"
    annotation (Placement(transformation(extent={{-42,22},{-22,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Line Treset(
    limitBelow=true,
    limitAbove=true)
    "Linear supply temperature set point reset"
    annotation (Placement(transformation(extent={{22,22},{42,42}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(
    final k=0)
    "linear conversion constant"
    annotation (Placement(transformation(extent={{-16,74},{4,94}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(
    final k=1)
    "linear conversion constant"
    annotation (Placement(transformation(extent={{-16,2},{4,22}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{58,-52},{78,-32}})));
  Buildings.Controls.OBC.CDL.Continuous.Add subtract(k1=-1, k2=+1)
    "subtract offset from input"
    annotation (Placement(transformation(extent={{-32,-110},{-12,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fixedOffset(
    final k=10)
    "fixed 10 degree offset from highest space temperature"
    annotation (Placement(transformation(extent={{-72,-104},{-52,-84}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{90,-172},{110,-152}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minPAR(
    k=minSATset)
    "Minimum supply air temperature set point"
    annotation (Placement(transformation(extent={{-16,-32},{4,-12}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heatPAR(
    final k=HeatSet)
    "Unoccupied mode supply air temperature heating set point"
    annotation (Placement(transformation(extent={{42,-190},{62,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxPAR(
    final k=maxSATset)
    "Maximum supply air temperature set point"
    annotation (Placement(transformation(extent={{-16,42},{4,62}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-98,22},{-78,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    k=TUpcntT)
    annotation (Placement(transformation(extent={{-72,22},{-52,42}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-72,-14},{-52,6}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-46,-52},{-26,-32}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{0,-172},{20,-152}})));
equation
  connect(conPI.y, Treset.u)
    annotation (Line(points={{-20,32},{20,32}},  color={0,0,127}));
  connect(X1.y, Treset.x1) annotation (Line(points={{6,84},{14,84},{14,40},{20,40}},
                    color={0,0,127}));
  connect(X2.y, Treset.x2) annotation (Line(points={{6,12},{10,12},{10,28},{20,28}},
                color={0,0,127}));
  connect(Treset.y, swi.u1)
    annotation (Line(points={{44,32},{52,32},{52,-34},{56,-34}},
                                                            color={0,0,127}));
  connect(fixedOffset.y, subtract.u1)
    annotation (Line(points={{-50,-94},{-34,-94}}, color={0,0,127}));
  connect(subtract.u2, highSpaceT) annotation (Line(points={{-34,-106},{-46,-106},
          {-46,-68},{-120,-68}},        color={0,0,127}));
  connect(swi.u3, subtract.y) annotation (Line(points={{56,-50},{0,-50},{0,-100},
          {-10,-100}},         color={0,0,127}));
  connect(swi1.y, ySATset)
    annotation (Line(points={{112,-162},{116,-162},{116,0},{120,0}},
                                                     color={0,0,127}));
  connect(Treset.f2, minPAR.y) annotation (Line(points={{20,24},{14,24},{14,-22},
          {6,-22}},   color={0,0,127}));
  connect(swi1.u3, heatPAR.y) annotation (Line(points={{88,-170},{82,-170},{82,
          -180},{64,-180}},
                       color={0,0,127}));
  connect(maxPAR.y, Treset.f1) annotation (Line(points={{6,52},{10,52},{10,36},{
          20,36}},   color={0,0,127}));
  connect(TotalTU, intToRea.u)
    annotation (Line(points={{-120,76},{-110,76},{-110,32},{-100,32}},
                                                  color={255,127,0}));
  connect(intToRea.y,gai. u)
    annotation (Line(points={{-76,32},{-74,32}}, color={0,0,127}));
  connect(conPI.u_s, gai.y)
    annotation (Line(points={{-44,32},{-50,32}}, color={0,0,127}));
  connect(intToRea1.u, totCoolReqs)
    annotation (Line(points={{-74,-4},{-98,-4},{-98,40},{-120,40}},
                                                  color={255,127,0}));
  connect(conPI.u_m, intToRea1.y) annotation (Line(points={{-32,20},{-32,-4},
          {-50,-4}}, color={0,0,127}));
  connect(sbc, not1.u)
    annotation (Line(points={{-120,4},{-78,4},{-78,-42},{-48,-42}},
                                                    color={255,0,255}));
  connect(swi.u2, not1.y) annotation (Line(points={{56,-42},{-24,-42}},
                    color={255,0,255}));
  connect(sbh, not2.u)
    annotation (Line(points={{-120,-32},{-88,-32},{-88,-162},{-2,-162}},
                                                      color={255,0,255}));
  connect(swi1.u2, not2.y) annotation (Line(points={{88,-162},{22,-162}},
                           color={255,0,255}));
  connect(swi.y, swi1.u1) annotation (Line(points={{80,-42},{84,-42},{84,-154},
          {88,-154}}, color={0,0,127}));
  annotation (defaultComponentName="TSupSet",
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
            graphics={
        Rectangle(extent={{-100,100},{100,-100}},
          lineColor={179,151,128},
          radius=30),
        Text(
          extent={{-38,138},{46,94}},
          lineColor={28,108,200},
          fillColor={179,151,128},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Rectangle(
          extent={{-34,2},{32,-2}},
          lineColor={179,151,128},
          fillColor={179,151,128},
          fillPattern=FillPattern.HorizontalCylinder),
        Line(points={{32,2},{0,14},{0,2}},        color={179,151,128},
          thickness=0.5),
        Text(
          extent={{-92,84},{-46,66}},
          lineColor={244,125,35},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="TotalTU"),
        Text(
          extent={{-96,52},{-32,28}},
          lineColor={244,125,35},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="totCoolReqs"),
        Text(
          extent={{-106,14},{-50,-6}},
          lineColor={217,67,180},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="SBC"),
        Text(
          extent={{-106,-24},{-50,-44}},
          lineColor={217,67,180},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="SBH"),
        Text(
          extent={{-94,-56},{-34,-82}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="highSpaceT"),
        Text(
          extent={{48,16},{94,-14}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={179,151,128},
          textString="ySATsetpoint")}),
      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-382,126},{-182,-16}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{38,90},{104,64}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Reset the normal supply air
temperature set point
between min and max values
based on the total number
of terminal unit cooling requests.",
          horizontalAlignment=TextAlignment.Left),
        Rectangle(
          extent={{-390,-58},{-190,-110}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{6,-86},{62,-106}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="When setback cooling mode
is active the supply air temperature
set point is set to the highest
terminal unit space temperature
minus a constant 10 degrees.",
          horizontalAlignment=TextAlignment.Left),
        Rectangle(
          extent={{-366,-142},{-166,-210}},
          lineColor={179,151,128},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,-170},{-30,-190}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="When setback heating mode
is active the supply air temperature
set point is set to the fixed
heating set point.")}),
    Documentation(revisions="<html>
<ul>
<li>June 11, 2020, by Henry Nickels:<br>Reversed logic to logical switches.</li>
<li>May 29, 2020, by Henry Nickels:<br>Internalize min, max, and heat setpoints as parameters.</li>
<li>May 28, 2020, by Henry Nickels:<br>Removed CDN and WUP inputs as they were
redundant to SBC and SBH. Changed cooling reset set point to percentage of total terminal units. </li>
<li>May 22, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>",
      info="<html>
      <p>Calculation of the supply air temperature set point performed by the BAS and 
      transmitted to the factory controller. </p>
<h4>Cooling Requests Reset</h4>
<p>During normal occupied mode operation, the supply air temperature set point is reset between minimum (<span style=\"font-family: Courier New;\">minSATsp</span>) and maximum (<span style=\"font-family: Courier New;\">maxSATsp</span>) values based on terminal unit cooling requests. </p>
<p>The total number of terminal unit cooling requests (<span style=\"font-family: Courier New;\">totCoolReqs</span>) is a network input that totalizes all requests from terminal units. The cooling request set point is calculated as a percentage of the total number of terminal units 
(<span style=\"font-family: Courier New;\">TotalTU</span>) served by the RTU (e.g. 15% of 80 terminal units = 12 cool request set point). The set point and requests are evaluated by a PI loop which outputs a value that increases from 0-1 as cooling requests increase.</p>
<p>The PI loop output is input to a linear converter that outputs the reset set point (<span style=\"font-family: Courier New;\">ySATsetpoint</span>).</p>
<h4>Setback Cooling</h4>
<p>During setback cooling mode (<span style=\"font-family: Courier New;\">SBC</span>) the supply air temperature set point is calculated from the highest space temperature (<span style=\"font-family: Courier New;\">highSpaceT</span>) less a fixed offset of ten degrees. (e.g. highest reported space temperature of (25 degC + 273.15K) &ndash; 10 = (15 degC + 273.15K) supply temperature set point). The fixed value offset should be based on the unit cooling capacity per hour. </p>
<h4>Setback Heating</h4>
<p>During setback heating mode (<span style=\"font-family: Courier New;\">SBH</span>) the supply air temperature set point is commanded to a fixed value (<span style=\"font-family: Courier New;\">UnOcHtSetpt</span>), usually around (35 degC + 273.15K) depending on the unit heating capacity. </p>
</html>"),
    experiment(
      StopTime=1200,
      Interval=1200,
      __Dymola_Algorithm="Dassl"));
end TSupSet;
