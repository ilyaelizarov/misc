model pipeValidationTurbulent
  package Medium = IBPSA.Media.Water;
  Medium.ThermodynamicState state;
  Modelica.SIunits.DynamicViscosity eta;
  Modelica.SIunits.KinematicViscosity nu;
  Modelica.SIunits.Density rho;
  
  Real Reynolds;
  // ,redeclare package FlowModel = Modelica.Fluid.Pipes.BaseClasses.FlowModels.TurbulentPipeFlow, flowModel(dp_nominal = 10000),
  constant Real pi = Modelica.Constants.pi;
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium,redeclare package FlowModel = Modelica.Fluid.Pipes.BaseClasses.FlowModels.TurbulentPipeFlow, diameter = 0.022, flowModel(dp_nominal = 10000),  length = 5, modelStructure = Modelica.Fluid.Types.ModelStructure.av_vb, roughness = 1.1e-05) annotation(
    Placement(visible = true, transformation(origin = {2, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T bou_massFlow(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT bou_pressure(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 20, height = 20 / 60) annotation(
    Placement(visible = true, transformation(origin = {-86, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.RelativePressure relativePressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // In m^3/s
  Modelica.Blocks.Sources.RealExpression dotV(y = pipe.port_a.m_flow * 1e-3) annotation(
    Placement(visible = true, transformation(origin = {-90, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression a(y = (-8 / pi) * rho * (1 / d.y ^ 4) * (f.y / d.y)) annotation(
    Placement(visible = true, transformation(origin = {-50, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression d(y = pipe.diameter) annotation(
    Placement(visible = true, transformation(origin = {-30, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression f(y = 0.25 / log10(relRou.y / 3.7 + 5.74 / Reynolds ^ 0.9) ^ 2) annotation(
    Placement(visible = true, transformation(origin = {-70, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression v(y = 1) annotation(
    Placement(visible = true, transformation(origin = {-30, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression nu1(y = nu) annotation(
    Placement(visible = true, transformation(origin = {4, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {4, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression epsilon(y = pipe.roughness) annotation(
    Placement(visible = true, transformation(origin = {-30, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division relRou annotation(
    Placement(visible = true, transformation(origin = {6, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression L(y = pipe.length)  annotation(
    Placement(visible = true, transformation(origin = {-50, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression pressureLossThomas(y = -L.y * a.y * dotV.y ^ 2)  annotation(
    Placement(visible = true, transformation(origin = {-10, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  state = Medium.setState_phX(p = pipe.port_a.p, h = pipe.port_a.h_outflow);
  eta = Medium.dynamicViscosity(state);
  rho = Medium.density(state);
  nu = eta / rho;
  
 Reynolds = v.y*d.y/nu;
  
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
  connect(v.y, product.u1) annotation(
    Line(points = {{-19, 96}, {-11, 96}, {-11, 96}, {-9, 96}}, color = {0, 0, 127}));
  connect(d.y, product.u2) annotation(
    Line(points = {{-19, 84}, {-11, 84}, {-11, 84}, {-9, 84}}, color = {0, 0, 127}));
  connect(epsilon.y, relRou.u1) annotation(
    Line(points = {{-18, 54}, {-8, 54}, {-8, 54}, {-6, 54}}, color = {0, 0, 127}));
  connect(relRou.u2, d.y) annotation(
    Line(points = {{-6, 42}, {-14, 42}, {-14, 84}, {-18, 84}, {-18, 84}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Diagram(graphics = {Text(origin = {-58, 98}, extent = {{-16, 4}, {16, -4}}, textString = "pipe.vs[1]"), Text(origin = {2, 115}, extent = {{-34, 9}, {34, -9}}, textString = "TurbulentFlow Model")}));
end pipeValidationTurbulent;
