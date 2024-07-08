clear all
close all

num_per_line = 32;
num_lines = 4;

% convert values to string
inst_char = dec2hex(num_lines, 2);
% add new line character
inst_char = strcat(inst_char, '\n');
% write inst to file
fid_inst = fopen('inst', 'a');
fprintf(fid_inst, inst_char);
fclose(fid_inst);

parsum = int32(0);
for i = 1 : num_lines
    neu_str = '';
    syn_str = '';

    for j = 1 : num_per_line
        % generate random value for neuron and synapse
        neu = int16(randi([-16, 16]));
        syn = int16(randi([-16, 16]));

        % computation - values of neu and syn are controlled
        parsum = parsum + int32(neu * syn);

        % convert values to string
        neu_str = strcat(neu_str, dec2hex(neu, 4));
        syn_str = strcat(syn_str, dec2hex(syn, 4));
    end

    % add new line character at the end of each line
    neu_str = strcat(neu_str, '\n');
    syn_str = strcat(syn_str, '\n');
    
    % write the line to a file
    fid_neu = fopen('neuron', 'a');
    fid_syn = fopen('weight', 'a');
    fprintf(fid_neu, neu_str);
    fprintf(fid_syn, syn_str);
    fclose(fid_neu);
    fclose(fid_syn);
end

% convert value to string
parsum_str = dec2hex(parsum, 8);
% add new line character
parsum_str = strcat(parsum_str, '\n');
% write result to file
fid_parsum = fopen('result', 'a');
fprintf(fid_parsum, parsum_str);
fclose(fid_parsum);