function fetchInstructionSet(filename)

arguments
    filename string = "mal.yaml"
end

import mal.*

instructions = ModelAssemblyInstructions.FromYaml(filename);
instructions.fetch();

end