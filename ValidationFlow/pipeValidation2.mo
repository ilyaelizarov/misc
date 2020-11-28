model pipeValidation2
  package Medium = IBPSA.Media.Water;
  constant Real pi = Modelica.Constants.pi;

  
Medium.ThermodynamicState state;

Modelica.SIunits.DynamicViscosity eta;
  
//  mu=pipe.FlowModel.Medium.DynamicViscosity[1];
  
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, flowModel(dp_nominal = 10000), redeclare package FlowModel = Modelica.Fluid.Pipes.BaseClasses.FlowModels.TurbulentPipeFlow, diameter = 0.022, length = 5, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, roughness = 1.1e-05) annotation(
    Placement(visible = true, transformation(origin = {2, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T bou_massFlow(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT bou_pressure(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 100, height = 0.3586) annotation(
    Placement(visible = true, transformation(origin = {-86, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.RelativePressure relativePressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // In m^3/s
equation

state = Medium.setState_phX(p=pipe.port_a.p, h=pipe.port_a.h_outflow);

eta = Medium.dynamicViscosity(state);




  connect(bou_massFlow.ports[1], pipe.port_a) annotation(
    Line(points = {{-30, 20}, {-8, 20}}, color = {0, 127, 255}));
  connect(pipe.port_b, bou_pressure.ports[1]) annotation(
    Line(points = {{12, 20}, {40, 20}}, color = {0, 127, 255}));
  connect(ramp.y, bou_massFlow.m_flow_in) annotation(
    Line(points = {{-75, 50}, {-68, 50}, {-68, 28}, {-50, 28}}, color = {0, 0, 127}));
  connect(relativePressure.port_b, pipe.port_b) annotation(
    Line(points = {{10, -12}, {24, -12}, {24, 20}, {12, 20}}, color = {0, 127, 255}));
  connect(relativePressure.port_a, pipe.port_a) annotation(
    Line(points = {{-10, -12}, {-22, -12}, {-22, 20}, {-8, 20}}, color = {0, 127, 255}));
  annotation(
    uses(Modelica(version = "3.2.3")));
end pipeValidation2;
