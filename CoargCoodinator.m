classdef CoargCoodinator < handle
    properties (GetAccess=public, SetAccess=private)
        coarg = []; % init with empty matlix
    end
    methods
        function obj = CoargCoodinator()
            % no init code.
        end
        
        function insertarg(obj, target)
            if isa(target, 'Coarg')
                obj.coarg(length(obj.coarg)+1) = target;
            else
                error('insertarg need "Coarg" object');
            end
        end
        
        function deletearg(key)
        end
        
        function getarg(key)
        end
        
        function appendValues(key, values)
        end
        
        function keys = getkeys()
        end
    end
end