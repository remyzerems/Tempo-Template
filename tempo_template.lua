---- this header is (only) required to save the script
-- ardour { ["type"] = "Snippet", name = "" }
-- function factory () return function () -- -- end end

	ardour {
	  ["type"]    = "EditorAction",
	  name        = "Tempo Template",
	}

	function factory () return function ()


        local home_path = os.getenv ( "HOME" )
        local f = assert(io.open(home_path .. "/.config/ardour5/scripts/tempo_template_playlist.plst", "r"))
        local t = f:read("*all")
        f:close()
        
        local file_values = {}
        for line in string.gmatch(t, "[^\n]+") do
            lines={}
            for pn in line:gmatch("[^,]+") do
                table.insert(lines, pn)
            end

            -- print(lines[1], ' - ', lines[2])
	        file_values[lines[1] .. " (" .. lines[2] .. "BPM)"] = lines[2]
        end



	    local dialog_options = {
		    {
			    type = "dropdown", key = "dropdown", title = "Song", 
			    values = file_values
		    },
	    }

        

	    local od = LuaDialog.Dialog ("Tempo template", dialog_options)
	    local rv = od:run()
	    if (rv) then
		    local tm = Session:tempo_map ()
		    local pos = Session:transport_frame ()
		    local tempo = ARDOUR.Tempo(rv["dropdown"], 4, rv["dropdown"])
		    tm:add_tempo(tempo, 0, pos, ARDOUR.TempoSection.PositionLockStyle.AudioTime)
	    end

	end end

