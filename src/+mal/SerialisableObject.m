classdef (Abstract) SerialisableObject < handle & matlab.mixin.SetGet
    
    methods 
        function assignProperties(this, s)
            arguments
                this
                s (1,1) struct
            end
            
            for f = fieldnames(s)'
                fn = string(f);
                if ismember(upper(fn), upper(fieldnames(this)))
                    set(this, fn, s.(fn));
                end

            end

        end
    end
end

