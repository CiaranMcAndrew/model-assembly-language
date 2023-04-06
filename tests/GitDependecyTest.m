classdef GitDependecyTest < matlab.unittest.TestCase

    properties (SetAccess=private)
        tmpDir = "tests/tmp";
    end

    methods (TestClassSetup)
        % Shared setup for the entire test class
        function startTimer(testCase)
            tic
        end
    end

    methods (TestMethodSetup)
        % Setup for each test
        function reportSetupTime(testCase)
            toc
        end

        function createTempDirectory(testCase)
            mkdir(testCase.tmpDir);
            testCase.addTeardown(@(x) rmdir(x, 's'), testCase.tmpDir)
        end

    end

    methods (TestMethodTeardown)
        function reportTeardownTime(testCase)
            toc
        end
    end

    methods
        function displayTestName(testCase)
            dbs = dbstack();
            disp("Running test case: " + dbs(2).name);
        end
    end
           
    
    methods (Test)
        % Test methods

        function constructorTest(testCase)
            import mal.*
            testCase.displayTestName();

            obj = GitDependency();
            testCase.verifyEqual(obj.Type, "git");
        end

        function fromStructTest(testCase)
            import mal.*
            testCase.displayTestName();

            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            obj = GitDependency.FromStruct(s);
            testCase.verifyEqual(obj.Url, s.url);
            testCase.verifyEqual(obj.Name, "mal-example-a.git");
        end

        function fetchTest(testCase)
            import mal.*
            testCase.displayTestName();

            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            obj = GitDependency.FromStruct(s);
            directory = obj.fetch(testCase.tmpDir);            
            cmd = "cd " + directory + " && git remote get-url origin";
            [status, cmdout] = system(cmd);
            testCase.verifyEqual(string(strtrim(cmdout)), s.url);
        end

        function fetchBranchTest(testCase)
            import mal.*
            testCase.displayTestName();

            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            s.branch = "model-branch-a";
            obj = GitDependency.FromStruct(s);
            directory = obj.fetch(testCase.tmpDir);            
            cmd = "cd " + directory + " && git branch --show-current";
            [status, cmdout] = system(cmd);
            testCase.verifyEqual(string(strtrim(cmdout)), s.branch);
        end

        function fetchTagTest(testCase)
            import mal.*
            testCase.displayTestName();
            
            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            s.tag = "release/1.0.0";
            obj = GitDependency.FromStruct(s);
            directory = obj.fetch(testCase.tmpDir);            
            cmd = "cd " + directory + " && git tag --points-at";
            [status, cmdout] = system(cmd);
            testCase.verifyTrue(contains(cmdout, s.tag));
        end

        function fetchCommitTest(testCase)
            import mal.*
            testCase.displayTestName();
            
            s = struct;
            s.url = "https://github.com/CiaranMcAndrew/mal-example-a.git";
            s.commit = "3ba5d0d";
            obj = GitDependency.FromStruct(s);
            directory = obj.fetch(testCase.tmpDir);            
            cmd = "cd " + directory + " && git rev-parse HEAD";
            [status, cmdout] = system(cmd);
            testCase.verifyTrue(contains(cmdout, s.commit));
        end
    end

end