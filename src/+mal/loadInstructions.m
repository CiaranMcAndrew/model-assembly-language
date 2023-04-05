function instructions = loadInstructions(filename)
%LOADINSTRUCTIONS Summary of this function goes here
%   Detailed explanation goes here

arguments
    filename string = "mal.yaml"
end

import mal.*

instructions = ModelAssemblyInstructions.FromYaml(filename);

end

