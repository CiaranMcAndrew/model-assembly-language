classdef GitDependecyTest < GenericTestCase

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
            cmd = "cd " + directory + " && git status";
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