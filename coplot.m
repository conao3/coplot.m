%% coplot is briliant plot tool.
% coplot is require 'filepath'
% return fitting constant

function coplot(filepaths)
    % openfile
    copar = arrayfun(@(x) Copar(x), filepaths, 'UniformOutput', false);
    
    % delete openfailed copar
    nullinx = cellfun(@(x) x.fileid == -1, copar);
    warning('failed openfile at: %s', join(filepaths(nullinx),' :'));
    copar(nullinx) = [];
    
    % parse
    % cellfun(@(x) x.parse, copar);
    
    % plotdata
    cellfun(@plotdata, copar);
end

function plotdata(copar, vargin)
    p = inputParser;
    defaultFignum = 80;
    addOptional(p,'fignum',defaultFignum,@isnumeric);
    parse(p, vargin{:});
    
    % init figure window
    fig = figure(p.Results.fignum);
    clf(p.Results.fignum);
    
    % init filename
    filename = regexp(filepath, '[^/]*$', 'match');
    filename = regexp(filename, '^[^.]+', 'match');
    
    % parse data
    copar.parse;
    copar.closefile;
    
    data = copar.data;
    coodinator = copar.argcoodinator;
    
    % plot data
    box on;
    hold on;
    
    x = data(:,1);
    rcol = [];
    if coodinator.isexist('right')
        %% right axis
        %{
        yyaxis right;
        
        rcol = coodinator.getarg('right').values;
        for k = 1:length(rcol)
            line = plot(x, data(:,rcol(k)));
        end
        %}
    end
    %% left axis
    yyaxis left;
    
    if isempty(rcol)
        lcol = 2:length(data(1,:));
    else
        % arrayfun(@(x) x==ycol, rcol, 'UniformOutput', false)
    end
    
    for k = 1:length(lcol)
        % plot data
        line = plot(x, data(:,lcol(k)));
        line_settings(line, 'none', line_symbol(k-1));
        
        % fitting
        p = polyfit(x);
        py = polyval(p,x);
        line = plot(x, py);
        disp(p);
        line_settings(line, '--', 'none');
    end
    
    if coodinator.isexist('ylabel')
        ylabel(coodinator.getarg('ylabel').values);
    end
    
    %% misc
    hold off;
    
    axis = fig.CurrentAxes;
    axis.XMinorTick = 'On';
    axis.YMinorTick = 'On';
    
    if coodinator.isexist('xlim')
        xlim(coodinator.getarg('xlim').values);
    end
    
    if coodinator.isexist('xlabel')
        xlabel(coodinator.getarg('xlabel').values);
    end
    
    if coodinator.isexist('label')
        labels = coodinator.getarg('label').values;
        for k = 1:length(labels)
            targetlabel(1+(k-1)*2) = label(k);
            targetlabel(2+(k-1)*2) = strcat(label(k), '�ߎ�');
        end
        legend(targetlabel);
    end
    
    fig.PaperUnits = 'points';
    fig.PaperPosition = [0 0 1200, 800];
    saveas(fig, strcat(filename,'.png'));
end

function line_settings(line, line_style, marker)
    line.LineStyle = line_style;
    line.Marker = marker;
    line.Color = 'k';
end











