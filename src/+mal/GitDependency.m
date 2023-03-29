classdef GitDependency < mal.Dependency
    %GITDEPENDENCY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Url
        Branch
        Tag
        Commit = "latest"
        
    end
    
    methods
        function this = GitDependency()
            this.Type = "git";
        end

        function fetch(this, stagingDirectory)
            arguments
                this
                stagingDirectory (1,1) string = ""
            end
            
            disp("Adding git submodule: " + this.Name + " - " + this.Url);
            directory = fullfile(stagingDirectory, this.Name);
            
            % Remove existing submodule
            try
                cmd = "git rm " + directory;
                [status, cmdout] = system(cmd);
            end
           
            % Delete directory
            status = rmdir(directory);

            % Add submodule
            cmd = "git submodule add " + this.Url + " " + directory;
            [status, cmdout] = system(cmd);
            if status ~= 0
                error("Error adding git submodule " + this.Url);
            end

            % Init submodule
            cd(directory);
            cd(pwd);
        end
    end

    methods % get;set
        function set.Url(this, value)
            this.Url = value;
            if isempty(this.Name)
                urlParts = strsplit(this.Url, "/");
                this.Name = urlParts(end);
            end
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

