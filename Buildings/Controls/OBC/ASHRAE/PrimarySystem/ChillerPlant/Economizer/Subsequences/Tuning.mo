within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences;
block Tuning
  "Defines a tuning parameter for the temperature prediction downstream of WSE"

  parameter Real step=0.02
  "Tuning step";

  parameter Modelica.SIunits.Time wseOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time wseOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "WSE enable disable status"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpe
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final max=0.5,
    final min=-0.2,
    final start=initTunPar)
    "Tuning parameter for the waterside economizer outlet temperature prediction "
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

//protected
  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu "Greater or equal than"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim(
    final k=wseOnTimDec)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tunStep(
    final k=step) "Tuning step"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam(y_start=0)
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1, k2=+1)
                                                              "Add"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 "And"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu "Less equal than"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim1(
    final k=wseOnTimInc)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1(
    final y_start=initTunPar) "Sampler"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  CDL.Continuous.GreaterEqualThreshold       greEquThr1(threshold=1)
                                                     "Less equal"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant MaxTowFanSpe(
    final k=1) "Maximal tower fan speed"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{-30,-140},{-10,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Zero(
    final k=0)
    "Minimal tower fan speed"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=0.5)
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  CDL.Discrete.TriggeredSampler triSam3
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  CDL.Continuous.Sources.Constant test(final k=1)
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  CDL.Discrete.ZeroOrderHold zerOrdHol(samplePeriod=1)
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  CDL.Continuous.Add                        add1(final k1=1)  "Add"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  CDL.Continuous.Add                        add3(final k1=-1) "Add"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-200,60},{-160,60},{-160,90},{-122,90}},
                                                     color={255,0,255}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          20},{-122,20}},color={255,0,255}));
  connect(greEqu.u2, wseOnTim.y) annotation (Line(points={{-82,82},{-90,82},{-90,
          60},{-99,60}}, color={0,0,127}));
  connect(tim.y, greEqu.u1)
    annotation (Line(points={{-99,90},{-82,90}},   color={0,0,127}));
  connect(add2.y, y)
    annotation (Line(points={{121,0},{190,0}}, color={0,0,127}));
  connect(and2.y, triSam.trigger)
    annotation (Line(points={{21,90},{70,90},{70,98.2}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-99,20},{-20,20},{-20,82},
          {-2,82}}, color={255,0,255}));
  connect(greEqu.y, pre.u)
    annotation (Line(points={{-59,90},{-52,90}}, color={255,0,255}));
  connect(and2.u1, pre.y)
    annotation (Line(points={{-2,90},{-29,90}}, color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-200,60},{-160,60},{-160,-40},
          {-122,-40}}, color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          -110},{-122,-110}},
                        color={255,0,255}));
  connect(lesEqu.u2, wseOnTim1.y) annotation (Line(points={{-82,-48},{-90,-48},{
          -90,-70},{-99,-70}}, color={0,0,127}));
  connect(tim1.y, lesEqu.u1)
    annotation (Line(points={{-99,-40},{-82,-40}}, color={0,0,127}));
  connect(and1.y, triSam1.trigger) annotation (Line(points={{41,-40},{70,-40},{
          70,-31.8}},
                   color={255,0,255}));
  connect(falEdg1.y, and1.u2) annotation (Line(points={{-99,-110},{0,-110},{0,-40},
          {18,-40}},      color={255,0,255}));
  connect(lesEqu.y, pre1.u)
    annotation (Line(points={{-59,-40},{-42,-40}}, color={255,0,255}));
  connect(and1.u1, pre1.y) annotation (Line(points={{18,-32},{-12,-32},{-12,-40},
          {-19,-40}}, color={255,0,255}));
  connect(tunStep.y, triSam1.u) annotation (Line(points={{21,130},{40,130},{40,
          -20},{58,-20}},
                     color={0,0,127}));
  connect(lesEqu.y, swi.u2) annotation (Line(points={{-59,-40},{-50,-40},{-50,-80},
          {-90,-80},{-90,-190},{-82,-190}},
                                  color={255,0,255}));
  connect(MaxTowFanSpe.y, swi.u1) annotation (Line(points={{-139,-180},{-88,
          -180},{-88,-182},{-82,-182}},
                                  color={0,0,127}));
  connect(swi.y, triSam2.u) annotation (Line(points={{-59,-190},{-40,-190},{-40,
          -130},{-32,-130}}, color={0,0,127}));
  connect(triSam2.y, greEquThr.u)
    annotation (Line(points={{-9,-130},{-2,-130}},  color={0,0,127}));
  connect(greEquThr.y, and1.u3) annotation (Line(points={{21,-130},{30,-130},{30,
          -72},{10,-72},{10,-48},{18,-48}}, color={255,0,255}));
  connect(triSam1.y, add2.u2) annotation (Line(points={{81,-20},{90,-20},{90,-6},
          {98,-6}}, color={0,0,127}));
  connect(Zero.y, swi.u3) annotation (Line(points={{-99,-200},{-90,-200},{-90,
          -198},{-82,-198}}, color={0,0,127}));
  connect(uTowFanSpe, greEquThr1.u)
    annotation (Line(points={{-200,-150},{-122,-150}}, color={0,0,127}));
  connect(greEquThr1.y, triSam2.trigger) annotation (Line(points={{-99,-150},{
          -20,-150},{-20,-141.8}}, color={255,0,255}));
  connect(falEdg1.y, triSam3.trigger) annotation (Line(points={{-99,-110},{-60,-110},
          {-60,-94},{90,-94},{90,-81.8}},       color={255,0,255}));
  connect(triSam3.u, test.y)
    annotation (Line(points={{78,-70},{61,-70}}, color={0,0,127}));
  connect(triSam.y, add1.u2) annotation (Line(points={{81,110},{90,110},{90,104},
          {98,104}}, color={0,0,127}));
  connect(tunStep.y, add1.u1) annotation (Line(points={{21,130},{90,130},{90,116},
          {98,116}}, color={0,0,127}));
  connect(add1.y, zerOrdHol.u)
    annotation (Line(points={{121,110},{138,110}}, color={0,0,127}));
  connect(zerOrdHol.y, triSam.u) annotation (Line(points={{161,110},{170,110},{170,
          140},{50,140},{50,110},{58,110}}, color={0,0,127}));
  connect(tunStep.y, add3.u1) annotation (Line(points={{21,130},{40,130},{40,56},
          {98,56}}, color={0,0,127}));
  connect(add1.y, add3.u2) annotation (Line(points={{121,110},{130,110},{130,80},
          {90,80},{90,44},{98,44}}, color={0,0,127}));
  connect(add3.y, add2.u1) annotation (Line(points={{121,50},{130,50},{130,20},
          {88,20},{88,6},{98,6}}, color={0,0,127}));
  annotation (defaultComponentName = "wseTun",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-220},{180,180}})),
Documentation(info="<html>
<p>
Waterside economizer outlet temperature prediction tuning parameter subsequence 
per OBC Chilled Water Plant Sequence of Operation, section 3.2.3.3. The parameter
is increased or decreased in a <code>step</code> depending on how long the
the economizer remained enabled and the values of the cooling tower fan speed signal 
<code>uTowFanSpe</code> during that period.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tuning;
