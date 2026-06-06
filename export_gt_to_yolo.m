inputFolder = 'D:\IITBHU Internship\other datasets\Drone-detection-dataset-v1.0.0\DroneDetectionThesis-Drone-detection-dataset-e7a6eaf\Data\Video_IR';
outputFolder = fullfile(inputFolder, 'YOLO_GT');

if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

matFiles = dir(fullfile(inputFolder, '*_LABELS.mat'));

for k = 1:length(matFiles)

    matPath = fullfile(inputFolder, matFiles(k).name);

    % ---- LOAD FILE ----
    S = load(matPath);
    vars = fieldnames(S);

    gt = [];
    for i = 1:length(vars)
        if isa(S.(vars{i}), 'groundTruth')
            gt = S.(vars{i});
            break;
        end
    end

    if isempty(gt)
        fprintf('[SKIP] No groundTruth in %s\n', matFiles(k).name);
        continue;
    end

    % ---- FIX BROKEN VIDEO PATHS ----
    try
        gt = changeFilePaths(gt, inputFolder, inputFolder);
    catch
        % ignore if not required
    end

    % ---- EXTRACT LABEL DATA ----
    tbl = gt.LabelData;

    if ~ismember('DRONE', tbl.Properties.VariableNames)
        fprintf('[SKIP] No DRONE label in %s\n', matFiles(k).name);
        continue;
    end

    droneTbl = tbl(:, 'DRONE');
    droneTbl = droneTbl(~cellfun(@isempty, droneTbl.DRONE), :);

    if height(droneTbl) == 0
        fprintf('[SKIP] Empty DRONE labels in %s\n', matFiles(k).name);
        continue;
    end

    % ---- WRITE CSV (TIMETABLE) ----
    outName = strrep(matFiles(k).name, '_LABELS.mat', '_DRONE.csv');
    outPath = fullfile(outputFolder, outName);

    writetimetable(droneTbl, outPath);
    fprintf('[OK] Exported %s\n', outName);

end

disp('DONE: DRONE labels exported successfully');
