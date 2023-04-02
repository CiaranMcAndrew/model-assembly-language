classdef GitDependency < mal.Dependency
    %GITDEPENDENCY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Url
        Tag
        Branch = "main"
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
            
            disp("Adding local git repo: " + this.Name + " - " + this.Url);
            directory = join([stagingDirectory, this.Name], '/');
            
            % Delete directory
            status = rmdir(directory, 's');
            assert(~isdir(directory));
            
            % Create new directory and cd
            mkdir(directory);
            workingDirectory = pwd;
            cd(directory);

            % Add git repo
            try
                % Clone repository
                cmd = "git clone " + this.Url + " .";
                this.ExecCmd(cmd)

                % Fetch
                cmd = "git fetch --all";
                this.ExecCmd(cmd)

                % Pull
                cmd = "git pull origin";
                this.ExecCmd(cmd)
                
                % Checkout branch
                cmd = "git checkout --detach";
                if isempty(this.Tag)
                    cmd = cmd + " " + this.Branch;
                else
                    cmd = cmd + " tags/" + this.Tag;
                end
                this.ExecCmd(cmd);
                
                % Cascade instruction sets
                if ~isempty(this.Instructions)
                    this.Instructions = mal.ModelAssemblyInstructions.FromYaml(this.Instructions.Filename);
                    this.Instructions.fetchDependencies();
                end

            catch ex
                cd(workingDirectory)
                throw(ex);
            end

            cd(workingDirectory);
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

    methods (Static, Access=private)
        function ExecCmd(cmd, raiseError, raiseWarn, onError)
            arguments
                cmd string
                raiseError logical = true
                raiseWarn logical = true
                onError function_handle = @nan
            end

            [status, cmdout] = system(cmd);
            if status ~= 0
                if raiseWarn
                    warning(cmdout); 
                end
                
                if raiseError
                    error("Error executing system command: " + cmd);
                    if onError ~= @nan
                        feval(onError)
                    end
                end
            end

        end
    end
end

