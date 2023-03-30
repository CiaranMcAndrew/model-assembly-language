function examples_to_markdown()

files = dir("examples\*.mlx");

for f = files
    filename = fullfile(f.folder, f.name);
    [~,fname] = fileparts(filename);
    md = fullfile(f.folder, [fname '.md']);
    livescript2markdown(filename, md)
end


end