classdef (Abstract) GenericTestCase < matlab.unittest.TestCase

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

end