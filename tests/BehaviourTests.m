classdef BehaviourTests < GenericTestCase

    methods 
        function [instructions, dependencies, directories] = fetchBehaviourTestCase(testCase, filename)
            import mal.*
            filepath = fullfile("tests", "behaviour-tests", filename);
            [instructions, dependencies, directories] = mal.fetchInstructionSet(filepath);
        end
    end

    methods (Test)
        % Test methods

        function fetchGitDependency(testCase)


            [instructions, dependencies, directories] = testCase.fetchBehaviourTestCase("tc01.yaml");
            
            % Verify correct remote URL
            n = 1;
            directory = directories(n);
            dependency = dependencies(n);
            cmd = "cd " + directory + " && git remote get-url origin";
            [status, cmdout] = system(cmd);
            testCase.verifyEqual(string(strtrim(cmdout)), dependency.Url);
        end
        
        function fetchGitDependencyByBranch(testCase)
            
            [instructions, dependencies, directories] = testCase.fetchBehaviourTestCase("tc02.yaml");

            % Verify correct branch
            n = 1;
            directory = directories(n);
            dependency = dependencies(n);
            cmd = "cd " + directory + " && git branch --show-current";
            [status, cmdout] = system(cmd);
            testCase.verifyEqual(string(strtrim(cmdout)), dependency.Branch);
            
        end

        function fetchGitDependencyByTag(testCase)
            
            [instructions, dependencies, directories] = testCase.fetchBehaviourTestCase("tc03.yaml");

            % Verify correct tag
            n = 1;
            directory = directories(n);
            dependency = dependencies(n);
            cmd = "cd " + directory + " && git status";
            [status, cmdout] = system(cmd);
            testCase.verifyTrue(contains(cmdout, dependency.Tag));

        end

        function fetchGitDependencyByCommit(testCase)

            [instructions, dependencies, directories] = testCase.fetchBehaviourTestCase("tc04.yaml");

            % Verify correct commit
            n = 1;
            directory = directories(n);
            dependency = dependencies(n);
            cmd = "cd " + directory + " && git rev-parse HEAD";
            [status, cmdout] = system(cmd);
            testCase.verifyTrue(contains(cmdout, dependency.Commit));
        end
    end

end