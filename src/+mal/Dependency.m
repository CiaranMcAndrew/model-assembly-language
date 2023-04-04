classdef Dependency < mal.SerialisableObject & matlab.mixin.Heterogeneous
    %DEPENDENCY Summary of this class goes here
    %   Detailed explanation goes here

    properties (Abstract)
        Name
    end

    properties
        Type {mustBeMember(Type, ["git", "none"])} = "none"
        Instructions mal.ModelAssemblyInstructions
    end

    

    methods
        function this = Dependency()
            % Blank constructor
        end
    end

    methods (Abstract)
        fetch(this)
        fetchInstructions(this)
    end

    methods (Static)
        function obj = FromStruct(s)
            arguments
                s {mustBeA(s, ["cell", "struct"])}
            end

            import mal.*

            switch class(s)
                case "cell"
                    % Return an array of Dependencies
                    obj = cellfun(@(x) Dependency.FromStruct(x), s);

                case "struct"
                    switch s.type
                        case "git"
                            obj = GitDependency();
                       
                        otherwise
                            error("Unrecognised dependency type: " + s.type);
                    end

                    obj.assignProperties(s)
            end

        end
    end
end

