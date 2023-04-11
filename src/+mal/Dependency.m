classdef (Abstract) Dependency < mal.SerialisableObject & matlab.mixin.Heterogeneous
    %DEPENDENCY Abstract defintion of a Dependency.
    %   The Dependency is the superclass for all types of dependency classes. 
    %
    %   Dependency is an abstract class, you cannot create instances of it.
    %   It does provide a static constructor FromStruct which will assign
    %   the appropriate subclass.
    % 
    %   A Dependency can reference a set of Instructions contained within
    %   the dependency, which will be compiled into the master set of
    %   instructions to which the object belongs.

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
        directory = fetch(this)
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

