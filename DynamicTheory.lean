-- Root of the Dynamic Theory Lean library.
-- Imports every layer module so `lake build` compiles the whole corpus.
-- (AxiomCheck is run separately: `lake env lean AxiomCheck.lean`.)
import Basic
import Layer1.Lean.T1_1_IntegratingFactor
import Layer1.Lean.T1_1_Universality
import Layer1.Lean.T1_2_AbsoluteVelocity
import Layer1.Lean.T1_3_Entropy
import Layer1.Lean.T1_4_MaxwellRelations
import Layer1.Lean.T1_5_Sylvester
import Layer1.Lean.T1_6_StabilityMetric
import Layer1.Lean.T1_6_SignatureNecessity
import Layer1.Lean.T1_6_SignatureInertia
import Layer1.Lean.T1_7_8_Connection
import Layer1.Lean.T1_10_Equilibrium
import Layer2.Lean.T2_1_Minkowski5D
import Layer2.Lean.T2_3_EnergyMomentum
import Layer2.Lean.T2_4_ForceDensity
import Layer2.Lean.T2_7_DiracFactorisation
import Layer2.Lean.T2_7_PositivityRoute
import Layer2.Lean.T2_8_DiracWithFields
import Layer3.Lean.T2_9_SpinStates
import Layer3.Lean.T2_10_London
import Layer3.Lean.NSM_SU3_Circulant
