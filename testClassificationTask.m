function testClassificationTask()
% ������� ������������ ������������ ��� �� ���� ������  �� ��������
% preparedDataSets �� ������� ����� �������������. ���������� ������ 
% ��������� � ��������������� ���� �������� testClassificationTask

clc;
clear all;

global flogid;
flogid = 1;

% ������ ���� ������, ���������� �������� ������ ��� ������� �������� ���
filenames = {...   
        'cancer1',...
        'cancer2',...
        'cancer3',...
        'card1',...
        'card2',...
        'card3',...
        'diabetes1',...
        'diabetes2',...
        'diabetes3',...
        'gene1',...
        'gene2',...
        'gene3',...
        'glass1',...
        'glass2',...
        'glass3',...
        'horse1',...  
        'horse2',...  
        'horse3',...  
        'mushroom1',...
        'mushroom2',...
        'mushroom3',...        
        'soybean1',...
        'soybean2',...
        'soybean3',...        
        'thyroid1',...
        'thyroid2',...
        'thyroid3', ...
        'textureCR', ...
        'vowels', ...
        'nXOR'
    };

tic;
fprintf('\n������ ��������� ���� �������� �����...');

for k = 1:length(filenames)  
    
    path = strcat('./learnedTasks/', filenames(k), '_text__log.dat');
    flogid = fopen(char(path), 'w');
    if(flogid == -1)
        error('Test: �� ���� ������� ���� %s', filenames(k));
    end
    
    fprintf('\n\t�������������� %s', char(filenames(k)));        
    
    % �������� ���������������� ������ ������
    ds = loadDataSets(char(filenames(k)));
    
    % �������� ��� �������� �����������
    net = mlpCreate([ds.numInputs, 10, 8, ds.numOutputs], ...
                    {'tansig'; 'tansig'; 'tansig'});

    % �������� ����
    [net, errors] = mlpTrain(net, ds);  
    
    % ���������� ��������� ���� � ����
    path = strcat('./learnedTasks/', filenames(k), '_mlp');
    mlpSave(net, char(path));
    
    % ���������� ������� �������� � ����
    path = strcat('./learnedTasks/', filenames(k), '_log');
    mlpPlot(char(path), errors, false);
    
    % ���������� ���� �������� � ����
    path = strcat('./learnedTasks/', filenames(k), '_errors');
    save(char(path), 'errors');
    
    % ������������ ����
    printMessage('\n\t������������ ��� �� ��������� ���������');
    printMLPEvalLog(net, ds.training);
    if(ds.hasTest)
        printMessage('\n\t������������ ��� �� �������� ���������');
        printMLPEvalLog(net, ds.test);
    end
    if(ds.hasValidation)
        printMessage('\n\t������������ ��� �� ����������� ���������');
        printMLPEvalLog(net, ds.validation);
    end

    % ���������� ���� �������� � ����
    path = strcat('./learnedTasks/', filenames(k), '_errors_matlab_mlp');

    % �������� � �������� ��� Matlab
    mlpMatlabTest(ds, path, ds.numInputs, 10, 8);
    
    fclose(flogid);
    pause(1);
end

fprintf('\n��������� ���� ���������. %d ����� �� %8.3f �\n', ...
            length(filenames), toc);
end % of function    