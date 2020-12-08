classdef OLED <  matlabshared.addon.LibraryBase
    % Create an OLED addon device object
    %
    % olcd = addon(a,'OLED') creates the OLED device object.
    % Based off https://www.mathworks.com/matlabcentral/fileexchange/72441-dht22-add-on-library-for-arduino
    % with reference from https://www.mathworks.com/help/supportpkg/arduinoio/ug/add-lcd-library.html 
    
    %% What are my functions?
    properties(Access = private, Constant = true)
        CREATE_OLED            = hex2dec('01')
        DELETE_OLED            = hex2dec('02')
        SET_CURSOR_OLED	       = hex2dec('03')
        PRINT_OLED 	       = hex2dec('04')
    end
    %% Copied from DHT22 and customized?
    properties(Access = protected, Constant = true)
        LibraryName = 'OLED/OLED.h'
        DependentLibraries = {'i2c'}
        LibraryHeaderFiles = {'U8g2/src/U8x8lib.h'}
        CppHeaderFile = fullfile(arduinoio.FilePath(mfilename('fullpath')), 'src', 'OLED.h')
        CppClassName = 'OLED'
    end
    %% What are my properties? based off DHT22
    properties(Access = private)
        count;
        flipMode;
        ResourceOwner = 'OLED/OLED';
    end
    
    %% ? 
    % Constructor Method
    methods(Hidden, Access = public)
        function obj = OLED(parentObj, flipMode)
          
            obj.Parent = parentObj;
        
            try
                %Get new ID for OLED Validate it.
                obj.count = getResourceCount(obj.Parent, 'OLED');
                if obj.count >= 2
                    error('OLED:OLED:ValueError', 'Maximum supported number of OLED devices have been reached.');
                end
                incrementResourceCount(obj.Parent, 'OLED');
                % Create OLED  UPSIDE DOWN?
                obj.flipMode=flipMode;
                createOLED(obj);
            catch e
                throwAsCaller(e);
            end
        end
    end
    
    % Destructor Method
    methods(Access = protected)
        function delete(obj)
            try
                parentObj = obj.Parent;
                decrementResourceCount(obj.Parent, 'OLED');
                deleteOLED(obj);
            catch
                % Do not throw any errors
            end
        end
    end
    %% Functions to create variables?
    methods(Access = private)
        % Create Sensor
        function createOLED(obj)
            cmdID = obj.CREATE_OLED;
            flipMode = obj.flipMode;
            data = [obj.flipMode]; 
            sendCommand(obj, obj.LibraryName, cmdID, data);
        end
        % Delete Sensor
        function deleteDHT22(obj)
            cmdID = obj.DELETE_OLED;
            sendCommand(obj, obj.LibraryName, cmdID, []);
        end
    end
    
    methods(Access = public)
        function val = setCursor(obj, xval , yval)
           cmdID = obj.SET_CURSOR_OLED;
            
            try
		data = [xval; yval];
                val = sendCommand(obj, obj.LibraryName, cmdID, data);
            catch e
                throwAsCaller(e);
            end
        end
        
        function val = printOLED(obj, strs)
	     cmdID = obj.PRINT_OLED;
            
            try
                %using 9 characters causes problems with lcd.
                if numel(double(strs)) >= 8
                    error('Cannot print more than 8 characters')
                end
                %obtained from LCD tutorial on Mathworks https://www.mathworks.com/help/supportpkg/arduinoio/ug/add-lcd-library.html
                val = sendCommand(obj, obj.LibraryName, cmdID, [double(strs)]);
            catch e
                throwAsCaller(e);
            end
        end
    end
    
end