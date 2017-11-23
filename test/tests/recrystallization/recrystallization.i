# This file is for generating deformed grains, i.e, the original matrix grains
# 该文件使用了PolycrystalVoronoiVoidIC来生成变形晶粒

[Mesh]
  # Mesh block.  Meshes can be read in or automatically generated
  type = GeneratedMesh
  dim = 2 # Problem dimension
  nx = 11 # Number of elements in the x-direction
  ny = 11 # Number of elements in the y-direction
  xmin = 0 # minimum x-coordinate of the mesh
  xmax = 1000 # maximum x-coordinate of the mesh
  ymin = 0 # minimum y-coordinate of the mesh
  ymax = 1000 # maximum y-coordinate of the mesh
  elem_type = QUAD4 # Type of elements used in the mesh
  uniform_refine = 3 # Initial uniform refinement of the mesh
[]

[GlobalParams]
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
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
      var_name_base = gr
      grain_num = 3
      numbub = 10 
      op_num = 3
      bubspac = 100
      outvalue = 0
      radius = 40
      invalue = 1
    [../]
  []
  [./gr12_IC]
    variable = gr12
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    var_name_base = gr
    grain_num = 3
    numbub = 10 
    op_num = 3 
    bubspac = 100
    outvalue = 0
    radius = 40 
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
    type = DeformedGrainMaterial
    grain_tracker = grain_tracker
    outputs = exodus
    var_name_base = gr
    op_num = 13
  [../]
[]

[Postprocessors]
  # Scalar postprocessors
  [./dt]
    # Outputs the current time step
    type = TimestepSize
  [../]
[]

[Executioner]
  # Preconditioned JFNK (default)
  # Uses newton iteration to solve the problem.
  type = Transient # Type of executioner, here it is transient with an adaptive time step
  scheme = bdf2 # Type of time integration (2nd order backward euler), defaults to 1st order backward euler
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -mat_mffd_type'
  petsc_options_value = 'hypre boomeramg 101 ds'
  l_max_its = 30 # Max number of linear iterations
  l_tol = 1e-4 # Relative tolerance for linear solves
  nl_max_its = 40 # Max number of nonlinear iterations
  nl_rel_tol = 1e-10 # Absolute tolerance for nonlienar solves
  start_time = 0.0
  end_time = 400
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.2 # Initial time step.  In this simulation it changes.
    optimal_iterations = 6 # Time step will adapt to maintain this number of nonlinear iterations
  [../]
  [./Adaptivity]
    # Block that turns on mesh adaptivity. Note that mesh will never coarsen beyond initial mesh (before uniform refinement)
    initial_adaptivity = 2 # Number of times mesh is adapted to initial condition
    refine_fraction = 0.7 # Fraction of high error that will be refined
    coarsen_fraction = 0.1 # Fraction of low error that will coarsened
    max_h_level = 4 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  [../]
[]

[Outputs]
  exodus = true # Exodus file will be outputted
  csv = true
  [./console]
    type = Console
    max_rows = 20 # Will print the 20 most recent postprocessor values to the screen
  [../]
[]

