%% �X�v���b�h�V�[�g����f�[�^���C���|�[�g
% ���̃X�v���b�h�V�[�g����f�[�^���C���|�[�g����X�N���v�g:
%
%    ���[�N�u�b�N: C:\Users\minoue\github\BarChartRaceAnimation\example\OldAgeDependency_OECD\WPP2019_POP_F13_A_OLD_AGE_DEPENDENCY_RATIO_1564.xlsx
%    ���[�N�V�[�g: ESTIMATES
%
% MATLAB ����̎���������: 2020/02/04 15:47:21

%% �C���|�[�g �I�v�V�����̐ݒ肨��уf�[�^�̃C���|�[�g
opts = spreadsheetImportOptions("NumVariables", 20);

% �V�[�g�Ɣ͈͂̎w��
opts.Sheet = "ESTIMATES";
opts.DataRange = "C17:V272";

% �񖼂ƌ^�̎w��
opts.VariableNames = ["Regionsubregioncountryorarea", "Notes", "Countrycode", "Type", "Parentcode", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% �ϐ��v���p�e�B���w��
opts = setvaropts(opts, ["Regionsubregioncountryorarea", "Notes", "Countrycode", "Type", "Parentcode", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Regionsubregioncountryorarea", "Notes", "Countrycode", "Type", "Parentcode", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22"], "EmptyFieldRule", "auto");

% �f�[�^�̃C���|�[�g
data = readtable("C:\Users\minoue\github\BarChartRaceAnimation\example\OldAgeDependency_OECD\WPP2019_POP_F13_A_OLD_AGE_DEPENDENCY_RATIO_1564.xlsx", opts, "UseExcel", false);

%% �o�͌^�ւ̕ϊ�
data = table2cell(data);
numIdx = cellfun(@(x) ~isnan(str2double(x)), data);
data(numIdx) = cellfun(@(x) {str2double(x)}, data(numIdx));

%% �ꎞ�ϐ��̃N���A
clear opts