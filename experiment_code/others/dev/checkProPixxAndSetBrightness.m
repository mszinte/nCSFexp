function checkProPixxAndSetBrightness()

    try
        % Open connection to Datapixx
        Datapixx('Open');
        
        % Check if Datapixx is ready
        if Datapixx('IsReady')
            disp('DATAPixx detected and ready.');
            
            % Check if a PROPixx device is connected
            if Datapixx('IsPROPixx')
                disp('PROPixx detected.');
                
                % Target brightness value (0–100 %)
                newBrightness = 70;
                
                % Apply the new brightness value
                Datapixx('SetPropixxLedIntensity', newBrightness); 
                Datapixx('RegWr');  % Write to hardware
                
                % Read back the actual value applied
                Datapixx('RegWrRd'); % Update registers from hardware
                currentBrightness = Datapixx('GetPropixxLedIntensity');
                
                % Verify the change
                if currentBrightness == newBrightness
                    fprintf('PROPixx brightness successfully set to %d%%.\n', currentBrightness);
                else
                    fprintf('Warning: Requested = %d%%, but PROPixx reports %d%%.\n', newBrightness, currentBrightness);
                end
                
            else
                disp('Warning: PROPixx not detected. Check HDMI/USB connection.');
            end
        else
            disp('Warning: DATAPixx not detected. Check power and connection.');
        end

    catch ME
        % Error handling
        disp('Error communicating with the device:');
        disp(ME.message);
    end

    % Always close the connection
    Datapixx('Close');
end