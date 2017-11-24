# This file is for generating deformed grains, i.e, the original matrix grains
# 该文件使用了PolycrystalVoronoiVoidIC来生成变形晶粒

[Mesh]
  # Mesh block.  Meshes can be read in or automatically generated
  type = GeneratedMesh
  dim = 2 # Problem dimension
  nx = 64 # Number of elements in the x-direction
  ny = 64 # Number of elements in the y-direction
  xmin = 0 # minimum x-coordinate of the mesh
  xmax = 64 # maximum x-coordinate of the mesh
  ymin = 0 # minimum y-coordinate of the mesh
  ymax = 64 # maximum y-coordinate of the mesh
  elem_type = QUAD4 # Type of elements used in the mesh
[]

[GlobalParams]
  int_width = 1.0
  time_scale = 1e-2
  length_scale = 1e-8
  deformed_grain_num = 3
[]

[Variables]
  # Variable block, where all variables in the simulation are declared
  [./PolycrystalVariables]
    var_name_base = gr
    op_num = 13
  [../]
[]

[UserObjects]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
    op_num = 13
    var_name_base = gr
    compute_var_to_feature_map = true
    flood_entity_type = elemental
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
      var_name_base = gr
      grain_num = 3
      numbub = 2 
      op_num = 3
      bubspac = 15 
      outvalue = 0
      radius = 5
      invalue = 1
    [../]
  []
  [./gr12_IC]
    variable = gr12
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    var_name_base = gr
    grain_num = 3
    numbub = 2 
    op_num = 3 
    bubspac = 15
    outvalue = 0
    radius = 5 
    invalue = 1
  [../]
[]

[AuxVariables]
  # Dependent variables
  [./bnds]
    # Variable used to visualize the grain boundaries in the simulation
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  # Kernel block, where the kernels defining the residual equations are set up.
  [./PolycrystalKernel]
    # Custom action creating all necessary kernels for grain growth.  All input parameters are up in GlobalParams
    var_name_base = gr
    op_num = 13
  [../]
  [./PolycrystalStoredEnergy]
    var_name_base = gr
    op_num = 13
    grain_tracker = grain_tracker
  [../]
[]

[AuxKernels]
  # AuxKernel block, defining the equations used to calculate the auxvars
  [./bnds_aux]
    # AuxKernel that calculates the GB term
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
    var_name_base = gr
    op_num = 13
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
    execute_on = 'initial timestep_end'
  [../]
[]

[BCs]
  # Boundary Condition block
  [./Periodic]
    [./top_bottom]
      auto_direction = 'x y' # Makes problem periodic in the x and y directions
    [../]
  [../]
[]

[Materials]
  [./deformed]
    type = MyDeformedGrainMaterial
    grain_tracker = grain_tracker
    outputs = exodus
    var_name_base = gr
    op_num = 13
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 15
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = -pc_type
  petsc_options_value = asm
  l_max_its = 15
  l_tol = 1.0e-6
  nl_rel_tol = 1.0e-8
  start_time = 0.0
  num_steps = 200
  nl_abs_tol = 1e-8
  dt = 0.20
[]

[Outputs]
  exodus = true
  csv = true
  interval = 1
  print_perf_log = true
[]

