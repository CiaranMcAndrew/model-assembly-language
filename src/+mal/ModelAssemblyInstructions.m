classdef ModelAssemblyInstructions < mal.SerialisableObject
    %MODELASSEMBLYINSTRUCTIONS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Filename (1,1) string
        StagingDirectory (1,1) string = "subs"
        Instructions = [];
        Dependencies = mal.Dependency.empty()
    end

    methods
        function this = ModelAssemblyInstructions(filename)
            % Blank constructor
            arguments
                filename (1,1) string
            end

            this.Filename = filename;
        end

        function assignProperties(this, s)
            arguments
                this
                s (1,1) struct
            end
            
            import mal.*

            for f = fieldnames(s)'
                fn = string(f);
                if ismember(upper(fn), upper(fieldnames(this)))
                    switch fn
                        case "dependencies"
                            cellfun(@(x) this.addDependency(Dependency.FromStruct(x)), ...
                                s.dependencies , ...
                                "UniformOutput", false);

                        case "instructions"
                            cellfun(@(x) this.addInstructions(ModelAssemblyInstructions.FromYaml(x.path)), ...
                                s.instructions , ...
                                "UniformOutput", false);

                        otherwise
                            set(this, fn, s.(fn));
                    end
                end
            end
        end

        function instructions = addInstructions(this, ins)

            arguments
                this
                ins mal.ModelAssemblyInstructions
            end

            this.Instructions = [this.Instructions; ins];
            instructions = this.Instructions;
        end

        function dependencies = addDependency(this, dep)
            arguments
                this
                dep mal.Dependency
            end

            this.Dependencies = [this.Dependencies; dep];
            dependencies = this.Dependencies;
        end

        function dependencies = getAllDependencies(this)
            dependencies = this.Dependencies;
            for i = this.Instructions'
                dependencies = [dependencies; i.Dependencies];
            end
        end

        function tbl = getDependencyTable(this, scope)
            arguments
                this
                scope (1,1) string {mustBeMember(scope, ["local", "all"])} = "local"
            end

            switch scope
                case "local"
                    dependencies = this.Dependencies;
                case "all"
                    dependencies = this.getAllDependencies();
            end

            warning('off', 'MATLAB:structOnObject');
            tbl = struct2table(arrayfun(@struct, dependencies));
            warning('on', 'MATLAB:structOnObject');
        end

    end

    methods (Static)
        function obj = FromYaml(filename)
            arguments
                filename (1,1) string = "mal.yaml"
            end

            import mal.*
            obj = ModelAssemblyInstructions(filename);

            s = yaml.loadFile(fullfile(filename));
            obj.assignProperties(s);
        end
    end
end

