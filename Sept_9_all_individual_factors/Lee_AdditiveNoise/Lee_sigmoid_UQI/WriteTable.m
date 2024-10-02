function WriteTable(fid,A,FORMATtable,H,Caption,fs)
    if nargin < 1, help WriteTable; return; end
    if nargin < 3, FORMATtable=[];  end
    if nargin < 4, H = []; end
    if nargin < 5, Caption = []; end
    if nargin < 6, fs = []; end

    if ~iscell(A) || size(A,1)~=1, error('Input matrix should be a 1x? cell array'); end

    % Make cmds for column heading and matrix

    % Heading:
    fprintfunH = ['fprintf(fid,''  '];
    for ii=1:length(H)-1
        fprintfunH=[fprintfunH, ' %s & '];
    end
    fprintfunH=[fprintfunH,' %s \\\\ \\hline \n'',string(H{1})'];

    for ii=2:length(H)
        fprintfunH=[fprintfunH, ',string(H{',int2str(ii),'})'];
    end
    fprintfunH=[fprintfunH, ');'];

    % Body
    rnum = size(A,2);
    fprintfunA = [];
    for ir = 1:rnum
        fprintfunA = [fprintfunA, 'fprintf(fid,''     '];
        for ia = 1:length(A{ir})-1
            fprintfunA=[fprintfunA,' %s & '];
        end
        fprintfunA=[fprintfunA,' %s  \\\\ \\hline \n'',string(A{',int2str(ir),'})'');'];
    end

    % Define Table format if needed
    if isempty(FORMATtable)
        % Find max columns
        cnum = max(length(H),length(A{1}));
        for i=2:rnum
            cnum = max(cnum,length(A{i}));
        end
        FORMATtable = blanks(cnum+3);
        FORMATtable(:) = 'c';
        FORMATtable(2) = 'r';
        FORMATtable([1 3 end]) = '|';
    end

    % Printing
    fprintf(fid,'%s\n','   % Start of table');
    fprintf(fid,'%s\n','    \begin{table}[htb]');

    % Add font information if given
    if ~isempty(fs)
        fprintf(fid,'%s\n','     % Font size of table');
        fprintf(fid,'       %s\n\n',fs);
    end

    fprintf(fid,'%s\n','    \centering ');
    fprintf(fid,'%s\n',['    \begin{tabular}{',FORMATtable,'}\hline']);

    % Write column headings
    if ~isempty(H), eval(fprintfunH); end
    % Write matrix
    eval(fprintfunA);
    % Write end of tabular:
    fprintf(fid,'%s\n','    \end{tabular}');

    % Write caption
    if ~isempty(Caption)
        fprintf(fid,'%s\n',['    \caption{',Caption,'}']);
    end

    % Write end of table:
    fprintf(fid,'%s\n','    \end{table}');
    fprintf(fid,'\n\n');
end
