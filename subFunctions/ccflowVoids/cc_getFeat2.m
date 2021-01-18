
function [m, b, fv10K] = cc_getFeat2(statsMat)

%% binarization and plots

% % set(0,'DefaultFigureVisible','off')
% 
% % c1 = rgb('LimeGreen');
% c1 = rgb('DarkGreen');
% fSize = 40;
% fSize2 = 32;
% lSize = 4;
% 
% % ********UNCOMMENT FOR HISTOGRAM PLOT********
% % BinLimits bins only the values in X that fall between bmin and bmax
% % inclusive; that is, X(X>=bmin & X<=bmax);
% % x is assigned so that the '100' labeled bin includes the 0-100 range,
% % and so on...
% [N,~] = histcounts(statsMat, 'BinWidth', 100, 'BinLimits', [0, 1000]);
% x = 100:100:1000;
% y = N;
% f1 = figure;
% % ax1 = subplot(2,1,1);
% chorBar = bar(x,y);
% xtickangle(90)
% ax = chorBar.Parent;
% set(ax, 'XTick', 500:500:1000,'FontSize',fSize)
% set(ax, 'YTick', 500:500:1500,'FontSize',fSize)
% % title({'Distribution of the number of flow voids','versus linearly binned sizes'},'FontSize',16)
% xlim([0 1100])
% ylim([0 2000])
% ylabel('Number','fontweight','bold','FontSize',fSize)
% xlabel('Area (\mum^2)','fontweight','bold','FontSize',fSize)
% a1 = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a1,'fontsize',fSize)
% set(gca,'linewidth',lSize)
% chorBar.EdgeColor = 'none';
% chorBar.FaceColor = c1;
% % get(f1,'Position')
% % move right | move up | expand right | expand up
% set(gcf, 'Position',  [450, 1000, 1350, 900])

% BinLimits bins only the values in X that fall between bmin and bmax
% inclusive; that is, X(X>=bmin & X<=bmax)
% x is assigned so that the '100' labeled bin includes the 0-100 range,
% and so on...
[N2,~] = histcounts(statsMat, 'BinWidth', 100, 'BinLimits', [0, 15100]);
x1 = 100:100:15100;
y1 = N2;

% empty bins and bins with less than 5 observations are removed
lowInd = find(y1<5);
x1(lowInd) = [];
y1(lowInd) = [];

% LOG BASE 10 PLOT WITH BEST FIT
% x2 = log10(x1);
% y2 = log10(y1);
% % figure;
% ax2 = subplot(2,1,2);
% chorLine = plot(x2, y2, 'o','MarkerSize',8, 'MarkerEdgeColor','none','MarkerFaceColor',c1);
% % title('Number versus size log-log plot','FontSize',16)
% ylabel('Log number','FontSize',16)
% xlabel('Log area (\mum^2)','FontSize',16)
% ylim([0 4])
% xlim([1.5 4.5])
% hold on;
% [coef_fit, S] = polyfit(x2,y2,1);
% R_squared = 1 - (S.normr/norm(y2 - mean(y2)))^2;
% y_fit = polyval(coef_fit,xlim);
% plot(xlim,y_fit,'w','LineWidth',2);
% theString = sprintf('y = %.3f x + %.3f', coef_fit(1), coef_fit(2));
% % text(x2(2)+0.5, y2(3), theString, 'FontSize', 16);
% theString2 = sprintf('R^2 = %.3f', R_squared);
% % text(x2(5)+0.5, y2(6), theString2, 'FontSize', 16);
% hold off;
% ax_0 = chorLine.Parent;
% set(ax_0, 'XTick', 1.5:1.5:4.5,'FontSize',14)
% set(ax_0, 'YTick', 0:2:4,'FontSize',14)
% a1 = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a1,'fontsize',20)
% set(gca,'linewidth',2)
% darkBackground(f1,[0 0 0],[1 1 1])
% % set(gcf, 'Position',  [-1700, 100, 550, 900])
% % y = m*x + b where
% coef_fit = polyfit(x2,y2,1);
% m = coef_fit(1);
% b = coef_fit(2);
% % modify %.3f for desired number of decimals
% lgdStr = sprintf('y=%.3f*x+%.3f',m,b);
% text(3,2.5,lgdStr,'FontSize',14,'Color','w')


% % LOGLOG PLOT WITH NATURAL LOGARITHM BEST FIT
% f2 = figure;
% % ax2 = subplot(2,1,2);
% % chorLine = plot(x2, y2, 'o','MarkerSize',8, 'MarkerEdgeColor','none','MarkerFaceColor',c1);
% chorLine = loglog(x1,y1, 'o','MarkerSize',25, 'MarkerEdgeColor','none','MarkerFaceColor',c1);
% % title('Number versus size log-log plot','FontSize',16)
% ylabel('Number','fontweight','bold','FontSize',fSize)
% xlabel('Area (\mum^2)','fontweight','bold','FontSize',fSize)
% ylim([10^0 10^4])
% xlim([10^1 10^4.5])
% % grid on
% hold on;
[Const, S] = polyfit(log(x1),log(y1), 1); % natural logarithm
R_squared = 1 - (S.normr/norm(log(y1) - mean(log(y1))))^2;
m = Const(1);
b = Const(2);
% YBL = x1.^m.*exp(b);
% loglog(x1,YBL,'k','LineWidth',lSize)
% 
% theString = sprintf('y = %.3f x + %.3f', Const(1), Const(2));
% text(x1(2)+100, y1(3)+400, theString, 'FontSize', fSize2);
% theString2 = sprintf('R^2 = %.3f', R_squared);
% text(x1(5)+100, y1(6)+150, theString2, 'FontSize', fSize2);
% 
% hold off
% 
% % ax_0 = chorLine.Parent;
% % set(ax_0, 'XTick', (10^2):(10^2):(10^4),'FontSize',14)
% % set(ax_0, 'YTick', (10^2):(10^1):(10^4),'FontSize',14)
% set(gca,'XTick',[10^2 10^4]); %This are going to be the only values affected.
% set(gca,'XTickLabel',{'10^2','10^4'}); %This is what it's going to appear in those places.
% set(gca,'YTick',[10^2 10^4]); %This are going to be the only values affected.
% set(gca,'YTickLabel',{'10^2','10^4'}); %This is what it's going to appear in those places.
% 
% a1 = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a1,'fontsize',fSize)
% set(gca,'linewidth',lSize)
% % darkBackground(f1,[0 0 0],[1 1 1])
% % set(gcf, 'Position',  [-1700, 100, 550, 900])
% 
% % get(f1,'Position')
% % move right | move up | expand right | expand up
% set(gcf, 'Position',  [450, 1000, 1350, 900])
% 
% % ax = gca;
% % ax.FontSize = 14;
% % title('number versus size','FontSize',16)
% % find FV10000 which is the ratio of flow voids area covered by flow voids
% % which have an area greater than 10000 um^2, i.e.,
% % (flow voids area > 10000 um^2)/(total flow voids area)
fv10Kind = statsMat > 10000;
fv10Ksum = sum(statsMat(fv10Kind));
fvTOTsum = sum(statsMat);
fv10K = fv10Ksum/fvTOTsum;

% set(0,'DefaultFigureVisible','on');


end