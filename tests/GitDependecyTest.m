classdef GitDependecyTest < matlab.unittest.TestCase

    properties (SetAccess=private)
        tmpDir = "tests/tmp";
    end

    methods (TestClassSetup)
        % Shared setup for the entire test class
    end

    methods (TestMethodSetup)
        % Setup for each test
        function createTempDirectory(testCase)
            mkdir(testCase.tmpDir);
            testCase.addTeardown(@(x) rmdir(x, 's'), testCase.tmpDir)
        end

    end
    
    methods (Test)
        % Test methods

        function constructorTest(testCase)
            import mal.*
            obj = GitDependency();
            testCase.verifyEqual(obj.Type, "git");
        end

        function fromStructTest(testCase)
            import mal.*
            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            obj = GitDependency.FromStruct(s);
            testCase.verifyEqual(obj.Url, s.url);
            testCase.verifyEqual(obj.Name, "mal-example-a.git");
        end

        function fetchTest(testCase)
            import mal.*
            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            obj = GitDependency.FromStruct(s);
            directory = obj.fetch(testCase.tmpDir);            
            cmd = "cd " + directory + " && git config --local --get remote.origin.url";
            [status, cmdout] = system(cmd);
            testCase.verifyEqual(string(strtrim(cmdout)), s.url);
        end

        function fetchBranchTest(testCase)
            import mal.*
            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            s.branch = "mal-example-branch";
            obj = GitDependency.FromStruct(s);
            directory = obj.fetch(testCase.tmpDir);            
            cmd = "cd " + directory + " && git config --local --get remote.origin.url";
            [status, cmdout] = system(cmd);
            testCase.verifyEqual(string(strtrim(cmdout)), s.url);
        end
    end

end

% instructions = 
%   ModelAssemblyInstructions with properties:
% 
%             Filename: "examples\example-a-basic-usage\example-a.yaml"
%     StagingDirectory: "submodules/example-a"
%         Instructions: [1×1 mal.ModelAssemblyInstructions]
%         Dependencies: [4×1 mal.GitDependency]
%               Values: []
% 
% Adding local git repo: mal-example-a.git - https://github.com/CiaranMcAndrew/mal-example-a.git
% Adding local git repo: mal-example-branch - https://github.com/CiaranMcAndrew/mal-example-a.git
% Adding local git repo: mal-example-tag - https://github.com/CiaranMcAndrew/mal-example-a.git
% Adding local git repo: mal-example-commit - https://github.com/CiaranMcAndrew/mal-example-a.git
% Adding local git repo: model-subref - https://github.com/CiaranMcAndrew/mal-example-a.git