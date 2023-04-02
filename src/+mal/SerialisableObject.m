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
        
        function s = toStruct(this)
            warning('off', 'MATLAB:structOnObject');
            s = struct(this);
            warning('on', 'MATLAB:structOnObject');

            mco = metaclass(this);

            for fn = fieldnames(s)'
                f = char(fn);

                % Remove hidden fields
                mpo = findobj(mco.PropertyList, 'Name', f);
                if mpo.Hidden
                    s = rmfield(s, f);
                    continue
                end

                % Serialise objects
                if ~isempty(s.(f))
                    if isa(s.(f), 'mal.SerialisableObject')
                        s.(f) = s.(f).toStruct;
                    elseif isobject(s.(f))
                        % s.(f) = struct(s.(f));
                    end
                end
                
            end
            
        end
    end

end

