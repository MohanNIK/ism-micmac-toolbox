%% Number of Leaves and Trees Optimization
%%数据准备
load dataTrain.mat %导入训练集
Input=data_new; %导入自变量
Output=dataPIC50; %导入因变量
%%寻找最合适的叶子节点和决策树数量
for RFOptimizationNum=1:4
RFLeaf=[5,10,20,50,100,200,500];
col='rgbcmyk';
figure('Name','RF Leaves and Trees');
for i=1:length(RFLeaf)
    RFModel=TreeBagger(2000,Input,Output,'Method','R','OOBPrediction','On','MinLeafSize',RFLeaf(i));
    plot(oobError(RFModel),col(i));
    hold on
end
xlabel('Number of Grown Trees');
ylabel('Mean Squared Error') ;
LeafTreelgd=legend({'5' '10' '20' '50' '100' '200' '500'},'Location','NorthEast');
title(LeafTreelgd,'Number of Leaves');
hold off;
 
disp(RFOptimizationNum);
end

%% Cycle Preparation
for RFCycleRun=1:RFRunNumSet
 
%% Training Set and Test Set Division
RandomNumber=(randperm(length(Output),floor(length(Output)*0.2)))'; %随机选择20%的样本
TrainActivity=Output;
TestActivity=zeros(length(RandomNumber),1);
TrainVARI=Input;
TestVARI=zeros(length(RandomNumber),size(TrainVARI,2));
for i=1:length(RandomNumber) %设置测试集
    m=RandomNumber(i,1);
    TestActivity(i,1)=TrainActivity(m,1); %将训练集写入测试集
    TestVARI(i,:)=TrainVARI(m,:);
    TrainActivity(m,1)=0; %从训练集删除测试集
    TrainVARI(m,:)=0; 
end
TrainActivity(all(TrainActivity==0,2),:)=[]; %按行消除零向量
TrainVARI(all(TrainVARI==0,2),:)=[];
 
%% RF
nTree=200; %根据测试, 设置决策树数
nLeaf=5; %根据测试, 设置叶子节点数
RFModel=TreeBagger(nTree,TrainVARI,TrainActivity,...
    'Method','regression','OOBPredictorImportance','on', 'MinLeafSize',nLeaf);
[RFPredictActivity,RFPredictConfidenceInterval]=predict(RFModel,TestVARI);
 
%% Accuracy of RF
RFRMSE=sqrt(sum(sum((RFPredictActivity-TestActivity).^2))/size(TestActivity,1));
RFrMatrix=corrcoef(RFPredictActivity,TestActivity);
RFr=RFrMatrix(1,2);
RFRMSEMatrix=[RFRMSEMatrix,RFRMSE];
RFrAllMatrix=[RFrAllMatrix,RFr];
if RFRMSE<1000
    disp(RFRMSE);
    break;
end
end
%%%%%%CIRTIC%%%%%
%%输入oob1和gini1, 标准化处理
cirOob=(oob1-min(oob1))./(max(oob1)-min(oob1));
cirGini=(gini1-min(gini1))./(max(gini1)-min(gini1));
cirM=[cirOob,cirGini];
cirR=corr(cirM); %求相关性系数R
cirStd=std(cirM); %求标准差std
cir=zeros(1,2);%%信息量
for i=1:2
    cir(i)=cirStd(i)*sum(1-cirR(:,i));
end
cirW=cir./sum(cir); %归一化得到cirtic权重
vidGiniObb=sum(cirM.*cirW,2); %利用权重得到最终耦合得分
for i=1:20      %有多少个变量就输入多少
    data_q2(:,i)=data(:,sel(i)); %按sel中的顺序导入新训练集
end
