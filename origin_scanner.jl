
function scan()

    apps = Dict()

    ######## Pacman ########

    pacman_packages = Vector{String}()

    cmd_output = read(`pacman -Q`, String)

    # split the output by newline and store each line as an element in the vector
    for package in split(cmd_output, '\n')
        push!(pacman_packages, package)
    end
    apps["pacman"] = pacman_packages


    ######## Flatpak ########

    flatpak_packages = Vector{String}()

    cmd_output = read(`flatpak list`, String)

    # split the output by newline and store each line as an element in the vector
    for package in split(cmd_output, '\n')
        push!(flatpak_packages, package)
    end
    apps["flatpak"] = flatpak_packages

    ######## Snap ########

    snap_packages = Vector{String}()

    cmd_output = read(`snap list`, String)

    # split the output by newline and store each line as an element in the vector
    for package in split(cmd_output, '\n')
        push!(snap_packages, package)
    end

    apps["snap"] = snap_packages

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
