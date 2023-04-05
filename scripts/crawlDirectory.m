function crawlDirectory(d, level)

arguments
    d
    level = 0
end

for f = dir(d)'
    if ismember(f.name, {'.','..','.git','resources'})
        continue; 
    end

    
    disp("" + repmat('-', 1,level) + f.name + repmat(filesep, 1, f.isdir))

    if f.isdir
        crawlDirectory(fullfile(d,f.name), level+1)
    end
end
end