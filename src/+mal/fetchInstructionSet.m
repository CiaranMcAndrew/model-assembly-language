function [instructions, dependencies, directories] = fetchInstructionSet(filename)

arguments
    filename string = "mal.yaml"
end

import mal.*

instructions = ModelAssemblyInstructions.FromYaml(filename);
[dependencies, directories] = instructions.fetch();

end