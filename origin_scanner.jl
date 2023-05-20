using Logging, LoggingExtras, DataFrames, CSV
io = open("log.txt", "w+")
logger = SimpleLogger(io, Logging.Info)

function scan(pacman=true, flatpak=true, snap=true, appimage=true)

    apps = Dict()

    ######## Pacman ########
    if pacman
        pacman_packages = Vector{String}()
        
        try
            cmd_output = read(`pacman -Q`, String)

            # split the output by newline and store each line as an element in the vector
            for package in split(cmd_output, '\n')
                push!(pacman_packages, package)
            end
            apps["pacman"] = pacman_packages
            @info "pacman packages saved with success"
        catch e
            @warn "trying to use pacman resulted in $e, prehaps pacman isn't available in your system" 
        end
    end

    ######## Flatpak ########
    if flatpak
        flatpak_packages = Vector{String}()

        try
            cmd_output = read(`flatpak list`, String)
            column_names = ["name","id", "version", "branch", "remote"]
            lines = split(cmd_output, '\n')
            data = [split(line, '\t') for line in lines]
            df=DataFrame([Symbol(name) => [] for name in column_names])

            for line in [l for l in data if size(l)==size(column_names)]  ## this feels very ineficient but it's the best result I've got given I'm still learning julia, in python this would be considered a crime. 
                push!(df,line)
            end


            # split the output by newline and store each line as an element in the vector
            for package in split(cmd_output, '\n')
                push!(flatpak_packages, package)
            end
            df = DataFrame(flatpak_packages)
            print(df)
            apps["flatpak"] = flatpak_packages
            @info "Flatpak packages saved with success"
        catch e  
            @warn "trying to use flatpak resulted in $e, prehaps flatpak isn't available in your system"
        end
    end
    ######## Snap ########
    if snap
        snap_packages = Vector{String}()

        try
            cmd_output = read(`snap list`, String)

            # split the output by newline and store each line as an element in the vector
            for package in split(cmd_output, '\n')
                push!(snap_packages, package)
            end

            apps["snap"] = snap_packages
            @info "snap packages saved with success"
        catch e
            @warn "trying to use snap resulted in $e, prehaps snap isn't available in your system"
        end
    end

    ######## Appimage ########
    if appimage
        appimage_packages = Vector{String}()

        cmd_output = read(`sudo find /usr/bin /usr/local/bin /opt $(homedir())/Applications -name '*.AppImage'`, String)

        # split the output by newline and store each line as an element in the vector
        for package in split(cmd_output, '\n')
            push!(appimage_packages, last(split(package,'/')))
        end
        apps["AppImage"] = appimage_packages
    end
    flush(io)
    close(io)
    return apps
end
