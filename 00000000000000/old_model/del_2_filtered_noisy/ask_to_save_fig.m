function save_decision = ask_to_save_fig()
    % Function to ask the user if they want to save the figure
    save_choice = input('Do you want to save this figure? (y/n): ', 's');
    if strcmpi(save_choice, 'y')
        save_decision = true;
    else
        save_decision = false;
    end
end
