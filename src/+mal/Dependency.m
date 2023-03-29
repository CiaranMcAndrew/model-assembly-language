classdef Dependency < mal.SerialisableObject & matlab.mixin.Heterogeneous
    %DEPENDENCY Summary of this class goes here
    %   Detailed explanation goes here

    properties
        type {mustBeMember(type, ["git", "none"])} = "none"
    end

    methods
        function this = Dependency()
            % Blank constructor
        end


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

                    end

                    obj.assignProperties(s)
            end

        end
    end
end

