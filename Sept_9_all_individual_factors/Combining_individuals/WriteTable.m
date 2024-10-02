function WriteTable(fid, A, FORMATtable, H, Caption, fs)
    % Function that writes a cell matrix as a LaTeX table.
    % Inputs:
    % fid - file identifier
    % A - Cell array with table data
    % FORMATtable - String specifying the table format
    % H - Header of the table
    % Caption - Table caption
    % fs - Font size string for LaTeX table

    if ~iscell(A) || size(A, 1) < 1
        error('Input matrix should be a cell array with at least one row');
    end

    % Ensure FORMATtable is generated if not provided
    if isempty(FORMATtable)
        numCols = size(A{1}, 2);
        FORMATtable = ['|', repmat('c|', 1, numCols)];
    end

    % % Ensure FORMATtable is provided
    % if isempty(FORMATtable)
    %     error('FORMATtable must be provided');
    % end

    % Write the table start
    fprintf(fid, '\\begin{table}[htb]\n');

    if ~isempty(fs)
        fprintf(fid, '%s\n', fs); % Font size
    end

    fprintf(fid, '\\centering\n');
    fprintf(fid, '\\begin{tabular}{%s} \\hline\n', FORMATtable);

    % Write the header
    if ~isempty(H)
        fprintf(fid, '%s \\\\ \\hline\n', strjoin(H, ' & '));
    end

    % Write each row of the table
    for ir = 1:length(A)
        % Convert all elements in A{ir} to character vectors
        row = cellfun(@char, A{ir}, 'UniformOutput', false);
        fprintf(fid, '%s \\\\ \\hline\n', strjoin(row, ' & '));
    end

    fprintf(fid, '\\end{tabular}\n');

    % Add a caption if it exists
    if ~isempty(Caption)
        fprintf(fid, '\\caption{%s}\n', Caption);
    end

    fprintf(fid, '\\end{table}\n\n');
end
