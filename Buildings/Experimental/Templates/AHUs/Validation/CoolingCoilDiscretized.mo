within Buildings.Experimental.Templates.AHUs.Validation;
model CoolingCoilDiscretized
  extends BaseNoEquipment( redeclare
    UserProject.AHUs.CoolingCoilDiscretized ahu(redeclare record
      RecordCoiCoo=datAhu.RecordCoiCoo));

  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumCoo,
    nPorts=2)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  UserProject.AHUs.Data.CoolingCoilDiscretized datAhu(
    redeclare record RecordCoiCoo =
      Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased (redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
        datHex(UA_nominal=500)))
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
equation
  connect(bou2.ports[1], ahu.port_coiCooSup)
    annotation (Line(points={{-40,-48},{-2,-48},{-2,-20}}, color={0,127,255}));
  connect(bou2.ports[2], ahu.port_coiCooRet)
    annotation (Line(points={{-40,-52},{2,-52},{2,-20}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoolingCoilDiscretized;
