model test

package Medium = IBPSA.Media.Water;

Medium.ThermodynamicState state;

Modelica.SIunits.DynamicViscosity eta;

equation

state = Medium.setState_pTX(p=101315, T=273.15+20);

eta = Medium.dynamicViscosity(state);

end test;
