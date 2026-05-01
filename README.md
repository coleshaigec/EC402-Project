# EC402-Project — Continuous Casting Control and Simulation

## Overview

Simulation and analysis framework for a simplified continuous casting steelmaking process. Models molten steel flow through a ladle → tundish → mold system, workpiece withdrawal and solidification, and evaluates state feedback, LQR, and observer-based control designs under nonlinear and linearized dynamics. Supports batched parameter sweeps, disturbance experiments, and automated reporting.

**Contributors:** Cole H. Shaigec (project lead), Dani Schwartz, Richie Kim

---

## Process Summary

Molten steel transfers from ladle to tundish to mold, is withdrawn and spray-cooled, and solidifies into a slab. The primary control objective is to regulate mold height `hM` to avoid overflow and air entrainment.

| Quantity | Symbol | Description |
|---|---|---|
| State 1 | `hM` | Mold steel height |
| State 2 | `hT` | Tundish steel height |
| Input 1 | `uM` | Tundish→mold flow regulation |
| Input 2 | `vW` | Withdrawal speed |
| Disturbance 1 | `d_l` | Ladle→tundish upstream flow disturbance |
| Disturbance 2 | `d_n` | Tundish→mold nozzle degradation |
| Disturbance 3 | `d_w` | Withdrawal actuator disturbance |

Withdrawal speed is subject to a safety constraint derived from the solidification front model of Thomas (2002).

---

## Repository Layout

```
EC402-Project/
├── startup.m                        # Adds src/ to MATLAB path
├── README.md
├── outputs/                         # Generated MAT files and figures
├── quarantine/                      # Deprecated files
└── src/
    ├── main.m                       # Top-level workflow orchestrator
    ├── config/                      # buildSimulationConfig, operating points,
    │                                #   disturbance scenarios, tolerances
    ├── models/                      # buildLinearPlant, buildNonlinearPlant,
    │                                #   buildMeasurementModel
    ├── orchestration/               # buildSimulationPlans, buildClosedLoopAnalysisPlan,
    │                                #   buildSimulationParameterGrids
    ├── simulation/                  # runAllSimulations, runSingleSimulation,
    │                                #   simulateLinearClosedLoopFullState,
    │                                #   simulateNonlinearClosedLoopFullState,
    │                                #   evaluateNonlinearDynamics
    ├── controllers/                 # buildStateFeedbackController, buildLQRController,
    │                                #   buildLinearFullStateClosedLoopEvaluator,
    │                                #   buildNonlinearFullStateClosedLoopEvaluator
    ├── observers/                   # Observer design and evaluator builders
    ├── reporting/                   # runFullReportingWorkflow, plotting, export,
    │                                #   buildExperimentSummaryTable
    └── utilities/                   # Shared helpers (getObservabilityCases,
                                     #   getMoldHeightDeviationTolerances, etc.)
```

---

## Quick Start

```matlab
% 1. Set project root as working directory
cd 'path/to/EC402-Project'

% 2. Initialize path
startup

% 3. Run full simulation and reporting workflow
main
```

---

## Configuration

All experiment parameters are set in `buildSimulationConfig.m`:

```matlab
% K-values for sensitivity sweep (metallurgical solidification constant)
simulationConfig.kValues = [0.0290; 0.0300; 0.0310];

% Controllers to run: 'stateFeedback' and/or 'lqr'
simulationConfig.controllers = {"stateFeedback", "lqr"};

% State feedback pole placement
simulationConfig.controllerParameters.stateFeedback = struct(
    'desiredPoles', {[-0.2; -0.4]}
);

% Disturbance scenarios (see buildDisturbanceScenarios.m for available names)
simulationConfig.chosenDisturbanceScenarios = {"nozzleConstant", "withdrawalPulse"};

% Observability cases: 'full' or 'moldOnly'
simulationConfig.observabilityCases = {"full"};
```

Simulation plans are generated as the Cartesian product of:
`kValues × controllers × disturbanceScenarios × observabilityCases`

---

## Example Usage

**Run a single plan and inspect results:**
```matlab
startup
cfg = buildSimulationConfig();
params = buildSimulationParameterGrids(cfg);
plans = buildSimulationPlans(params);
result = runSingleSimulation(plans(1));
```

**Run all plans and generate reports:**
```matlab
startup
cfg = buildSimulationConfig();
params = buildSimulationParameterGrids(cfg);
plans = buildSimulationPlans(params);
results = runAllSimulations(plans);
runFullReportingWorkflow(results);
```

**Regenerate reports from saved outputs:**
```matlab
reportSimulationResults
```

---

## Controllers

| Controller | Function | Notes |
|---|---|---|
| State feedback | `buildStateFeedbackController` | Pole placement via MATLAB `place` |
| LQR | `buildLQRController` | Q/R weighted by physical deviation tolerances |

Both controllers operate in deviation coordinates relative to the operating point equilibrium `(xe, ue)`.

---

## Disturbance Scenarios

Defined in `buildDisturbanceScenarios.m`. Each scenario specifies which disturbance channels (`d_l`, `d_n`, `d_w`) are active, their functional form, and parameters. Available scenarios include `baseline`, `nozzleConstant`, `nozzlePulse`, `withdrawalPulse`, `withdrawalStep`, and `ladlePulse`.

---

## Output Metrics

The summary table produced by `buildExperimentSummaryTable` includes the following metrics for both linear and nonlinear plants:

- Max absolute mold level deviation
- Settling time and settled flag
- Fraction of time outside primary and severe violation bands
- Steady-state error
- Control energy
- Oscillation severity
- Safety violation flags (overflow, negative level, withdrawal speed limit)
- Estimation error norm (observer cases)

---

## Dependencies

- MATLAB R2020a or newer
- Control System Toolbox (required — `place`, `lqr`)
- Optimization Toolbox (optional)
- Parallel Computing Toolbox (optional)

---

## Best Practices

- Run `startup` at the start of every MATLAB session
- Timestamp outputs in `outputs/` to avoid overwriting previous results
- Keep `buildSimulationConfig.m` as the single source of truth for experiment parameters
- Do not hardcode scenario-specific numerical values inside model or controller functions

---

## References

Thomas, B. G. (2002). Modeling of the continuous casting of steel — past, present, and future. *Metallurgical and Materials Transactions B*, 33(6), 795–812.
