[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 85
  ny = 85
  nz = 0
  xmax = 250
  ymax = 250
  zmax = 0
  elem_type = QUAD4
[]

[GlobalParams]
  op_num = 12
  grain_num = 25
  var_name_base = gr
  numbub = 15
  bubspac = 22
  radius = 8
  int_width = 10
  invalue = 1
  outvalue = 0.1
[]

[Variables]
  [./c]
  [../]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./bnds]
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
  [../]
[]

[UserObjects]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
  [../]
[]
[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
    [../]
  [../]
  [./c_IC]
    variable = c
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Problem]
  type = FEProblem
  solve = false
[]

[Executioner]
  type = Transient
  num_steps = 0
[]

[Outputs]
  exodus = true
[]
