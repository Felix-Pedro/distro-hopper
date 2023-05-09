using Logging, LoggingExtras
logger = SimpleLogger(stdout, Logging.Trace)
addLogger(logger)
push!(Loggers.handlers(logger), FileHandler("log.txt", force=true))

function scan(pacman=true, flatpak=true, snap=true, appimage=true)

    apps = Dict()

    ######## Pacman ########
    pacman_packages = Vector{String}()
    
    try
        cmd_output = read(`pacman -Q`, String)

        # split the output by newline and store each line as an element in the vector
        for package in split(cmd_output, '\n')
            push!(pacman_packages, package)
        end
        apps["pacman"] = pacman_packages
    catch e
        @warn "trying to use pacman resulted in $e, prehaps pacman isn't available in your system"
    end

    ######## Flatpak ########
    
    flatpak_packages = Vector{String}()

    try
        cmd_output = read(`flatpak list`, String)

        # split the output by newline and store each line as an element in the vector
        for package in split(cmd_output, '\n')
            push!(flatpak_packages, package)
        end
        apps["flatpak"] = flatpak_packages
    catch e  
        @warn "trying to use flatpak resulted in $e, prehaps pacman isn't available in your system"
    end

    ######## Snap ########

    snap_packages = Vector{String}()

    try
        cmd_output = read(`snap list`, String)

        # split the output by newline and store each line as an element in the vector
        for package in split(cmd_output, '\n')
            push!(snap_packages, package)
        end

        apps["snap"] = snap_packages
    catch e
        @warn "trying to use snap resulted in $e, prehaps pacman isn't available in your system"
    end

    ######## Appimage ########

    appimage_packages = Vector{String}()

    cmd_output = read(`sudo find /usr/bin /usr/local/bin /opt $(homedir())/Applications -name '*.AppImage'`, String)

    # split the output by newline and store each line as an element in the vector
    for package in split(cmd_output, '\n')
        push!(appimage_packages, last(split(package,'/')))
    end
    apps["AppImage"] = appimage_packages

    return apps
end
