%% スプレッドシートからデータをインポート
% 次のスプレッドシートからデータをインポートするスクリプト:
%
%    ワークブック: C:\Users\minoue\github\BarChartRaceAnimation\example\OldAgeDependency_OECD\WPP2019_POP_F13_A_OLD_AGE_DEPENDENCY_RATIO_1564.xlsx
%    ワークシート: ESTIMATES
%
% MATLAB からの自動生成日: 2020/02/04 15:47:21

%% インポート オプションの設定およびデータのインポート
opts = spreadsheetImportOptions("NumVariables", 20);

% シートと範囲の指定
opts.Sheet = "ESTIMATES";
opts.DataRange = "C17:V272";

% 列名と型の指定
opts.VariableNames = ["Regionsubregioncountryorarea", "Notes", "Countrycode", "Type", "Parentcode", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% 変数プロパティを指定
opts = setvaropts(opts, ["Regionsubregioncountryorarea", "Notes", "Countrycode", "Type", "Parentcode", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Regionsubregioncountryorarea", "Notes", "Countrycode", "Type", "Parentcode", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22"], "EmptyFieldRule", "auto");

% データのインポート
data = readtable("C:\Users\minoue\github\BarChartRaceAnimation\example\OldAgeDependency_OECD\WPP2019_POP_F13_A_OLD_AGE_DEPENDENCY_RATIO_1564.xlsx", opts, "UseExcel", false);

%% 出力型への変換
data = table2cell(data);
numIdx = cellfun(@(x) ~isnan(str2double(x)), data);
data(numIdx) = cellfun(@(x) {str2double(x)}, data(numIdx));

%% 一時変数のクリア
clear opts