classdef GitDependency < mal.Dependency
    %GITDEPENDENCY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        url
        branch
        tag
        commit = "latest"
        
        
    end
    
    methods
        function this = GitDependency()
            this.type = "git";
        end
    end

    methods (Static)
        function obj = FromStruct(s)
            arguments
               s {mustBeA(s, ["cell", "struct"])}
            end

            import mal.*

            obj = GitDependency;
            obj.assignProperties(s);

        end
    end
end

