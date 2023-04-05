function examples_to_markdown()

disp("Converting examples to markdown")
searchDirectory("examples")

end

function searchDirectory(folder)

disp("Searching folder: " + folder)
convertMlxFiles(folder);

files = dir(folder);
for f = files'
    if ismember(f.name,  {'..', '.'}); continue; end
    if f.isdir
        searchDirectory(fullfile(folder, f.name));
    end

end


end

function convertMlxFiles(folder)

files = dir(folder + "\*.mlx");

for f = files'
    filename = fullfile(f.folder, f.name);
    [~,fname] = fileparts(filename);
    md = fullfile(f.folder, [fname '.md']);
    
    disp("Converting file: " + filename)
    livescript2markdown(filename, md)
end

end