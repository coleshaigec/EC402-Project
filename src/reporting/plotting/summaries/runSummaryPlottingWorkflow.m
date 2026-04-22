function runSummaryPlottingWorkflow(allRunsMetrics, outputPlan, plottingPlan)
    % RUNSUMMARYPLOTTINGWORKFLOW Builds summary plots for experiment results.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  simulationResults struct array
    %  allRunsMetrics struct array
    %  outputPlan struct
    %  plottingPlan struct
    %
    % SIDE EFFECTS
    %  Writes enabled summary plots as PNGs to summary plots directory.

    if ~plottingPlan.summary.enabled
        return;
    end

    summaryTargetDirectory = outputPlan.summary.plotsDirectory;
    numRuns = numel(allRunsMetrics);

    runLabels = strings(numRuns, 1);
    linearFractionOutsidePrimaryBand = zeros(numRuns, 1);
    nonlinearFractionOutsidePrimaryBand = zeros(numRuns, 1);

    linearFractionOutsideSevereBand = zeros(numRuns, 1);
    nonlinearFractionOutsideSevereBand = zeros(numRuns, 1);

    linearPeakMoldDeviation = zeros(numRuns, 1);
    nonlinearPeakMoldDeviation = zeros(numRuns, 1);

    linearControlEnergy = zeros(numRuns, 1);
    nonlinearControlEnergy = zeros(numRuns, 1);

    for i = 1:numRuns
        runLabels(i) = outputPlan.runs(i).runFolderName;

        linearFractionOutsidePrimaryBand(i) = allRunsMetrics(i).linear.fractionOutsidePrimaryBand;
        nonlinearFractionOutsidePrimaryBand(i) = allRunsMetrics(i).nonlinear.fractionOutsidePrimaryBand;

        linearFractionOutsideSevereBand(i) = allRunsMetrics(i).linear.fractionInSevereBandViolation;
        nonlinearFractionOutsideSevereBand(i) = allRunsMetrics(i).nonlinear.fractionInSevereBandViolation;

        linearPeakMoldDeviation(i) = allRunsMetrics(i).linear.maxAbsoluteMoldLevelDeviation;
        nonlinearPeakMoldDeviation(i) = allRunsMetrics(i).nonlinear.maxAbsoluteMoldLevelDeviation;

        linearControlEnergy(i) = allRunsMetrics(i).linear.controlEnergy;
        nonlinearControlEnergy(i) = allRunsMetrics(i).nonlinear.controlEnergy;
    end

    if plottingPlan.summary.fractionOutsidePrimaryBand
        primaryBandSummaryData = struct();
        primaryBandSummaryData.runLabels = runLabels;
        primaryBandSummaryData.linearValues = linearFractionOutsidePrimaryBand;
        primaryBandSummaryData.nonlinearValues = nonlinearFractionOutsidePrimaryBand;

        primaryBandSummaryDisplaySpec = struct();
        primaryBandSummaryDisplaySpec.title = "Fraction outside primary band by run";
        primaryBandSummaryDisplaySpec.xLabel = "Run";
        primaryBandSummaryDisplaySpec.yLabel = "Fraction outside primary band";
        primaryBandSummaryDisplaySpec.legendEntries = {"Linear plant", "Nonlinear plant"};

        primaryBandSummaryPlot = plotFractionOutsidePrimaryBandSummary( ...
            primaryBandSummaryData, primaryBandSummaryDisplaySpec);

        writeFigureToOutput(primaryBandSummaryPlot, summaryTargetDirectory, ...
            "fractionOutsidePrimaryBandSummary");
    end

    if plottingPlan.summary.fractionOutsideSevereBand
        severeBandSummaryData = struct();
        severeBandSummaryData.runLabels = runLabels;
        severeBandSummaryData.linearValues = linearFractionOutsideSevereBand;
        severeBandSummaryData.nonlinearValues = nonlinearFractionOutsideSevereBand;

        severeBandSummaryDisplaySpec = struct();
        severeBandSummaryDisplaySpec.title = "Fraction outside severe band by run";
        severeBandSummaryDisplaySpec.xLabel = "Run";
        severeBandSummaryDisplaySpec.yLabel = "Fraction outside severe band";
        severeBandSummaryDisplaySpec.legendEntries = {"Linear plant", "Nonlinear plant"};

        severeBandSummaryPlot = plotFractionOutsideSevereBandSummary( ...
            severeBandSummaryData, severeBandSummaryDisplaySpec);

        writeFigureToOutput(severeBandSummaryPlot, summaryTargetDirectory, ...
            "fractionOutsideSevereBandSummary");
    end

    if plottingPlan.summary.peakMoldDeviation
        peakMoldDeviationSummaryData = struct();
        peakMoldDeviationSummaryData.runLabels = runLabels;
        peakMoldDeviationSummaryData.linearValues = linearPeakMoldDeviation;
        peakMoldDeviationSummaryData.nonlinearValues = nonlinearPeakMoldDeviation;

        peakMoldDeviationSummaryDisplaySpec = struct();
        peakMoldDeviationSummaryDisplaySpec.title = "Peak mold deviation by run";
        peakMoldDeviationSummaryDisplaySpec.xLabel = "Run";
        peakMoldDeviationSummaryDisplaySpec.yLabel = "Peak mold deviation (m)";
        peakMoldDeviationSummaryDisplaySpec.legendEntries = {"Linear plant", "Nonlinear plant"};

        peakMoldDeviationSummaryPlot = plotPeakMoldDeviationSummary( ...
            peakMoldDeviationSummaryData, peakMoldDeviationSummaryDisplaySpec);

        writeFigureToOutput(peakMoldDeviationSummaryPlot, summaryTargetDirectory, ...
            "peakMoldDeviationSummary");
    end

    if plottingPlan.summary.controlEnergy
        controlEnergySummaryData = struct();
        controlEnergySummaryData.runLabels = runLabels;
        controlEnergySummaryData.linearValues = linearControlEnergy;
        controlEnergySummaryData.nonlinearValues = nonlinearControlEnergy;

        controlEnergySummaryDisplaySpec = struct();
        controlEnergySummaryDisplaySpec.title = "Control energy by run";
        controlEnergySummaryDisplaySpec.xLabel = "Run";
        controlEnergySummaryDisplaySpec.yLabel = "Control energy";
        controlEnergySummaryDisplaySpec.legendEntries = {"Linear plant", "Nonlinear plant"};

        controlEnergySummaryPlot = plotControlEnergySummary( ...
            controlEnergySummaryData, controlEnergySummaryDisplaySpec);

        writeFigureToOutput(controlEnergySummaryPlot, summaryTargetDirectory, ...
            "controlEnergySummary");
    end

    if plottingPlan.summary.peakDeviationControlEnergyScatter
        peakDeviationControlEnergyScatterData = struct();
        peakDeviationControlEnergyScatterData.linearControlEnergy = linearControlEnergy;
        peakDeviationControlEnergyScatterData.nonlinearControlEnergy = nonlinearControlEnergy;
        peakDeviationControlEnergyScatterData.linearPeakMoldDeviation = linearPeakMoldDeviation;
        peakDeviationControlEnergyScatterData.nonlinearPeakMoldDeviation = nonlinearPeakMoldDeviation;

        peakDeviationControlEnergyScatterDisplaySpec = struct();
        peakDeviationControlEnergyScatterDisplaySpec.title = ...
            "Peak mold deviation versus control energy";
        peakDeviationControlEnergyScatterDisplaySpec.xLabel = "Control energy";
        peakDeviationControlEnergyScatterDisplaySpec.yLabel = "Peak mold deviation (m)";
        peakDeviationControlEnergyScatterDisplaySpec.legendEntries = {"Linear plant", "Nonlinear plant"};

        peakDeviationControlEnergyScatterPlot = plotPeakDeviationControlEnergyScatter( ...
            peakDeviationControlEnergyScatterData, ...
            peakDeviationControlEnergyScatterDisplaySpec);

        writeFigureToOutput(peakDeviationControlEnergyScatterPlot, summaryTargetDirectory, ...
            "peakDeviationControlEnergyScatter");
    end
end