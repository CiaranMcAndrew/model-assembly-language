classdef GitDependency < mal.Dependency
    %GITDEPENDENCY A dependency hosted in a Git repository.
    %   A GitDependency enables a dependency to reference a Git repository
    %   as well as a configuration state based on Tag, Commit or Branch.
    % 
    %   This class requires a local installation of the Git application and 
    %   the Git CLI to be accessible.
    % 
    %   This class is lightly opinionated about Git operations, deferring
    %   tasks such as validation and authentication to the underlying Git
    %   libraries.

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

        function fetch(this, stagingDirectory, pathspec, scope)
            arguments
                this
                stagingDirectory (1,1) string = ""
                pathspec (1,1) string = ""
                scope (1,1) string {mustBeMember(scope, ["local", "all"])} = "all"
            end

            disp("Adding local git repo: " + this.Name + " - " + this.Url);
            directory = join([stagingDirectory, this.Name], '/');

            % Delete directory
            status = rmdir(directory, 's');
            assert(~isfolder(directory));

            % Create new directory and cd
            mkdir(directory);
            workingDirectory = pwd;
            cd(directory);

            % Add git repo
            try
                % Clone repository
                cmd = "git clone -n " + this.Url + " .";
                this.ExecCmd(cmd)

                % Fetch
                cmd = "git fetch --all";
                this.ExecCmd(cmd)

                % Pull
                cmd = "git pull origin";
                this.ExecCmd(cmd)

                % Checkout Tag, Commit, or Branch
                cmd = "git checkout ";
                if isempty(this.Tag)
                    cmd = cmd + this.Branch;
                elseif this.Commit ~= "latest"
                    cmd = cmd + this.Commit;
                else
                    cmd = cmd + "tags/" + this.Tag;
                end

                if ~isempty(pathspec)
                    cmd = cmd + " -- " + pathspec;
                else
                    disp("Executing git cmd: " + cmd)
                end

                this.ExecCmd(cmd);

                % Update Instructions
                if ~isempty(this.Instructions)
                    this.Instructions = mal.ModelAssemblyInstructions.FromYaml(this.Instructions.Filename);

                    % Cascade instruction sets
                    switch scope
                        case "all"
                            this.Instructions.fetchDependencies();
                    end
                end

            catch ex
                cd(workingDirectory)
                throw(ex);
            end

            cd(workingDirectory);
        end

        function fetchInstructions(this, stagingDirectory)
            arguments
                this
                stagingDirectory (1,1) string = ""
            end

            if isempty(this.Instructions); return; end

            this.fetch(stagingDirectory, this.Instructions.Filename, "local")
            this.Instructions.fetchInstructions();
        end

        function applyValues(this, s)
            if any(strcmpi(fieldnames(this), s.name))
                this.assignProperties(struct(s.name, s.value));
                return
            end

            obj = findobj(this.Instructions.Dependencies, "Name", s.name);
            obj.applyValues(cell2mat(s.value));

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
                        onError()
                    end
                end
            end

        end
    end
end

