#!/bin/bash
#Expat License (known as MIT License)
#https://directory.fsf.org/wiki/License:Expat
#https://spdx.org/licenses/MIT.html
#https://www.gnu.org/licenses/license-list.html#Expat
#============================================================================
# Copyright (C) 2023, Frederic Pouchal
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#============================================================================

while true; do

    echo " "
    os_name=$(uname)

    if [ "$os_name" = "Linux" ]; then
        osname="Linux"
    elif [ "$os_name" = "FreeBSD" ]; then
        osname="FreeBSD"
    elif [ "$os_name" = "Darwin" ]; then
        osname="MacOS X"
    else
        osname=$os_name
        echo "Unknown operating system: $os_name"
    fi

    count=0

    echo "Star Wars Jedi Knight II: Jedi Outcast Demo"
    echo "original level not available in the full game"

    echo "Your operating system is $osname"

    if [ "$os_name" = "Darwin" ]; then
        echo " "
        let count=count+1 >/dev/null #1
        # ((count++)) does not work on FreeBSD
        echo "$count- Install xcode and homebrew (required)"
        echo "   need Mac user password"
    fi

    echo " "
    let count=count+1 >/dev/null #2
    echo "$count- Install required programs and libraries"

    if [ "$os_name" = "Darwin" ]; then
        echo " "
    else
        echo "   required: updated system"
        echo "             root password"
        echo " "
    fi

    let count=count+1 >/dev/null #3
    echo "$count- Download source code"
    echo " "
    let count=count+1 >/dev/null #4
    echo "$count- Download map"
    echo " "
    let count=count+1 >/dev/null #5
    echo "$count- Compile the game"
    echo " "
    let count=count+1 >/dev/null #6
    echo "$count- Play the game"
    echo " "
    let count=count+1 >/dev/null #7
    if [ "$os_name" = "Darwin" ]; then
        echo "$count- Install the game in Applications"
    else
        echo "$count- Create shortcuts on the Desktop and in the Menu"
    fi
    echo " "
    let count=count+1 >/dev/null #8
    echo "$count- Help"
    echo " "
    let count=count+1 >/dev/null #9
    echo "$count- Exit"

    read number

    if [ "$os_name" = "Darwin" ]; then
        echo " "
    else
        let number=number+1 >/dev/null
    fi

    case $number in
    1)
        echo "Install xcode and homebrew"

        if ! command -v xcode-select &>/dev/null; then
            xcode-select --install
        else
            echo "xcode is already installed."
        fi

        if ! command -v brew &>/dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew doctor
        else
            echo "Homebrew is already installed."
        fi

        ;;
    2)
        echo "Install required programs and libraries"
        if [ "$os_name" = "Linux" ]; then
            if command -v apt &>/dev/null; then

                sudo apt-get update
                sudo apt-get install build-essential cmake libjpeg-dev libpng-dev zlib1g-dev libsdl2-dev 7zip git
                echo " "
            else
                echo "The 'apt' command is not available on this system."
                echo "You are not using a Debian derivative Linux"
                echo "Install these packages with your installer"
                echo "  build-essential cmake libjpeg-dev libpng-dev"
                echo "  zlib1g-dev libsdl2-dev 7zip"
                echo "For more info"
                echo "https://github.com/JACoders/OpenJK/wiki/Compilation-guide"
            fi

        elif [ "$os_name" = "FreeBSD" ]; then

            while true; do
                echo "Are you using pkg to install your programs"
                echo " "
                echo "1- Yes"
                echo " "
                echo "2- No"
                echo " "
                echo "3- Exit"
                read use_pkg

                if [ $use_pkg -ge 1 ] && [ $use_pkg -le 3 ]; then
                    break
                fi
                echo " "
                echo "Invalid input. Please enter 1,2, or 3):"
            done

            case $use_pkg in
            1)
                sudo pkg update
                sudo pkg install sdl2 cmake git gcc zlib-ng openjpeg openssl xorg 7-zip
                ;;
            2)
                echo "Install these packages with your installer"
                echo "sdl2 cmake git gcc zlib-ng openjpeg openssl"
                echo "xorg 7-zip"
                ;;
            3)
                echo "Exiting script."
                sync
                exit 0
                ;;
            *)
                echo " "
                echo "Invalid input. Please enter 1,2, or 3):"
                ;;
            esac

        elif [ "$os_name" = "Darwin" ]; then
            brew install zlib libjpeg libpng sdl2 p7zip git
        else
            echo "Unknown operating system: $os_name"
        fi

        ;;

    3)

        while true; do

            echo "1- Download from the official source"
            echo " "
            echo "2- Download from fork that works"
            echo " "
            echo "3- Exit"
            read downfrom

            if [ $downfrom -ge 1 ] && [ $downfrom -le 3 ]; then
                break
            fi
            echo " "
            echo "Invalid input. Please enter 1,2, or 3):"

        done

        case $downfrom in
        1)
            rm -rf JK2-JO-Demo
            git clone https://github.com/JACoders/OpenJK JK2-JO-Demo
            ;;
        2)
            rm -rf JK2-JO-Demo
            git clone https://github.com/fred260571/OpenJK-save JK2-JO-Demo
            ;;
        3)
            echo "Exiting script."
            sync
            exit 0
            ;;
        *)
            echo " "
            echo "Invalid input. Please enter 1,2, or 3):"
            ;;
        esac
        ;;

    4)
        echo "Downloading map"
        curl -LO https://archive.org/download/jk2demo/jk2demo.exe
        ;;
    5)
        # compile

        if [ ! -d "JK2-JO-Demo" ]; then
            echo "Error: you must download the source code before"
            exit 0
        fi

        if [ ! -e "jk2demo.exe" ]; then
            echo "Error: you must download the map before"
            exit 0
        fi

        while true; do
            echo "Customize your screen resolution for better experience"
            echo " "
            echo "1- No thanks"
            echo " "
            echo "2- Customize height and width"
            echo " "
            echo "3- Use your system resolution"

            #2048x1536
            width=2048
            height=1536

            if [ "$os_name" = "Darwin" ]; then

                # Get the screen resolution using 'system_profiler'
                resolution_info=$(system_profiler SPDisplaysDataType | awk -F 'like: ' '/like:/{print $2}')

                # Check if a resolution was found
                if [ -z "$resolution_info" ]; then
                    echo "Failed to retrieve screen resolution."
                fi
                # Extract width and height from the resolution information
                width=$(echo "$resolution_info" | awk '{print $1}')
                height=$(echo "$resolution_info" | awk '{print $3}')
            else
                # Check if xrandr command is available
                if ! command -v xrandr &>/dev/null; then
                    echo "xrandr is not installed on this system."
                fi

                # Get the screen resolution
                resolution=$(xrandr | grep -Eo '[0-9]+x[0-9]+' | head -n 1)

                # Check if a resolution was found
                if [ -z "$resolution" ]; then
                    echo "Failed to retrieve screen resolution."
                else

                    # Extract width and height from the resolution
                    width=$(echo "$resolution" | cut -d 'x' -f 1)
                    height=$(echo "$resolution" | cut -d 'x' -f 2)
                fi
            fi

            # Display the detected resolution
            echo "Detected Screen Resolution: $width $height"

            if [ "$os_name" = "Darwin" ]; then
                echo " "
            else
                echo "You can use xrandr in the console"
                echo "to have more resolutions"
                echo " "
            fi

            echo "4- Exit"
            read number2

            if [ $number2 -ge 1 ] && [ $number2 -le 4 ]; then
                break
            fi
            echo " "
            echo "Invalid input. Please enter 1,2, or 3):"
        done

        case $number2 in
        1)
            width=2048
            height=1536
            echo " "
            ;;
        2)
            echo "width"
            read width
            echo "height"
            read height
            ;;
        3)
            echo " "
            ;;
        4)
            echo "Exiting script."
            sync
            exit 0
            ;;
        *)
            echo "Invalid input. Please enter 1,2, or 3):"
            ;;
        esac

        echo "Extracting map"
        mkdir demo-map
        7z x jk2demo.exe -odemo-map
        7z x demo-map/Disk1/GameData/demo/assets0.pk3 -odemo-map/JK2-JO

        if [ "$os_name" = "Linux" ]; then

            #ChatGPT, a powerful tool is, use it you will.
            original_lc_all="$LC_ALL"
            LC_ALL=C sed -i -e 's/2048_X_1536/'"$width"'_X_'"$height"'/g' demo-map/JK2-JO/ui/setup.menu
            LC_ALL=C sed -i -e 's/2048_X_1536/'"$width"'_X_'"$height"'/g' demo-map/JK2-JO/ui/ingamesetup.menu

            LC_ALL=C sed -i -e 's/2048_X_1536/'"$width"'_X_'"$height"'/g' demo-map/JK2-JO/strip/menus1.sp
            LC_ALL=C sed -i -e 's/2048 X 1536/'"$width"' X '"$height"'/g' demo-map/JK2-JO/strip/menus1.sp
            if [ -n "$original_lc_all" ]; then
                export LC_ALL="$original_lc_all"
            else
                unset LC_ALL
            fi

        else

            #ChatGPT, a powerful tool is, use it you will.
            original_lc_all="$LC_ALL"
            LC_ALL=C sed -i '' -e 's/2048_X_1536/'"$width"'_X_'"$height"'/g' demo-map/JK2-JO/ui/setup.menu
            LC_ALL=C sed -i '' -e 's/2048_X_1536/'"$width"'_X_'"$height"'/g' demo-map/JK2-JO/ui/ingamesetup.menu

            LC_ALL=C sed -i '' -e 's/2048_X_1536/'"$width"'_X_'"$height"'/g' demo-map/JK2-JO/strip/menus1.sp
            LC_ALL=C sed -i '' -e 's/2048 X 1536/'"$width"' X '"$height"'/g' demo-map/JK2-JO/strip/menus1.sp
            if [ -n "$original_lc_all" ]; then
                export LC_ALL="$original_lc_all"
            else
                unset LC_ALL
            fi

        fi

        #      sed -i.bak 's/foo/bar/' filename

        7z a -tzip demo-map/assets0.pk3 ./demo-map/JK2-JO/*
        cp demo-map/assets0.pk3 .
        rm -rf demo-map/

        #make backup files

        #CMakeLists.txt
        if [ -e JK2-JO-Demo/CMakeLists-copy.txt ]; then
            cp JK2-JO-Demo/CMakeLists-copy.txt JK2-JO-Demo/CMakeLists.txt
        else
            cp JK2-JO-Demo/CMakeLists.txt JK2-JO-Demo/CMakeLists-copy.txt
        fi

        #code/server/sv_ccmds.cpp
        if [ -e JK2-JO-Demo/code/server/sv_ccmds-copy.cpp ]; then
            cp JK2-JO-Demo/code/server/sv_ccmds-copy.cpp JK2-JO-Demo/code/server/sv_ccmds.cpp
        else
            cp JK2-JO-Demo/code/server/sv_ccmds.cpp JK2-JO-Demo/code/server/sv_ccmds-copy.cpp
        fi

        #code/rd-vanilla/tr_WorldEffects.cpp
        if [ -e JK2-JO-Demo/code/rd-vanilla/tr_WorldEffects-copy.cpp ]; then
            cp JK2-JO-Demo/code/rd-vanilla/tr_WorldEffects-copy.cpp JK2-JO-Demo/code/rd-vanilla/tr_WorldEffects.cpp
        else
            cp JK2-JO-Demo/code/rd-vanilla/tr_WorldEffects.cpp JK2-JO-Demo/code/rd-vanilla/tr_WorldEffects-copy.cpp
        fi

        #code/rd-vanilla/tr_shader.cpp
        if [ -e JK2-JO-Demo/shared/sdl/sdl_window-copy.cpp ]; then
            cp JK2-JO-Demo/shared/sdl/sdl_window-copy.cpp JK2-JO-Demo/shared/sdl/sdl_window.cpp
        else
            cp JK2-JO-Demo/shared/sdl/sdl_window.cpp JK2-JO-Demo/shared/sdl/sdl_window-copy.cpp
        fi

        #shared/sdl/sdl_window.cpp
        if [ -e JK2-JO-Demo/shared/sdl/sdl_window-copy.cpp ]; then
            cp JK2-JO-Demo/shared/sdl/sdl_window-copy.cpp JK2-JO-Demo/shared/sdl/sdl_window.cpp
        else
            cp JK2-JO-Demo/shared/sdl/sdl_window.cpp JK2-JO-Demo/shared/sdl/sdl_window-copy.cpp
        fi

        #codemp/rd-dedicated/tr_init.cpp
        if [ -e JK2-JO-Demo/codemp/rd-dedicated/tr_init-copy.cpp ]; then
            cp JK2-JO-Demo/codemp/rd-dedicated/tr_init-copy.cpp JK2-JO-Demo/codemp/rd-dedicated/tr_init.cpp
        else
            cp JK2-JO-Demo/codemp/rd-dedicated/tr_init.cpp JK2-JO-Demo/codemp/rd-dedicated/tr_init-copy.cpp
        fi

        if [ "$os_name" = "Linux" ]; then

            sed -i "s/else if (Q_stricmp(token, \"snow\") == 0)/else if ( 0 )/" JK2-JO-Demo/code/rd-vanilla/tr_WorldEffects.cpp

            sed -i "s/map = Cmd_Argv(1);/map = \"demo\";/" JK2-JO-Demo/code/server/sv_ccmds.cpp

            sed -i "s/token = COM_ParseExt( text, qfalse );/token = COM_ParseExt( text, qfalse ); if ( !Q_stricmp( token, \"menu\/video\/tc_engl\" ) ) { token = \"menu\/video\/tc_demo\"; }/" JK2-JO-Demo/code/rd-vanilla/tr_shader.cpp

            TAB=$(printf '\t')
            #sed "s/${TAB}//g" file
            sed -i "s/2048x1536/${width}x${height}/" JK2-JO-Demo/shared/sdl/sdl_window.cpp
            sed -i "s/2048,${TAB}1536/${width},${TAB}${height}/" JK2-JO-Demo/shared/sdl/sdl_window.cpp
            sed -i "s/2048x1536/${width}x${height}/" JK2-JO-Demo/codemp/rd-dedicated/tr_init.cpp
            sed -i "s/2048,${TAB}1536/${width},${TAB}${height}/" JK2-JO-Demo/codemp/rd-dedicated/tr_init.cpp

            sed -i "s/option(BuildJK2SPEngine \"Whether to create projects for the jk2 SP engine (openjo_sp.exe)\" OFF)/option(BuildJK2SPEngine \"Whether to create projects for the jk2 SP engine (openjo_sp.exe)\" ON)/" JK2-JO-Demo/CMakeLists.txt
            sed -i "s/option(BuildJK2SPGame \"Whether to create projects for the jk2 sp gamecode mod (jk2gamex86.dll)\" OFF)/option(BuildJK2SPGame \"Whether to create projects for the jk2 sp gamecode mod (jk2gamex86.dll)\" ON)/" JK2-JO-Demo/CMakeLists.txt
            sed -i "s/option(BuildJK2SPRdVanilla \"Whether to create projects for the jk2 sp renderer (rdjosp-vanilla_x86.dll)\" OFF)/option(BuildJK2SPRdVanilla \"Whether to create projects for the jk2 sp renderer (rdjosp-vanilla_x86.dll)\" ON)/" JK2-JO-Demo/CMakeLists.txt

        else

            sed -i '' "s/else if (Q_stricmp(token, \"snow\") == 0)/else if ( 0 )/" JK2-JO-Demo/code/rd-vanilla/tr_WorldEffects.cpp

            sed -i '' "s/map = Cmd_Argv(1);/map = \"demo\";/" JK2-JO-Demo/code/server/sv_ccmds.cpp

            sed -i '' "s/token = COM_ParseExt( text, qfalse );/token = COM_ParseExt( text, qfalse ); if ( !Q_stricmp( token, \"menu\/video\/tc_engl\" ) ) { token = \"menu\/video\/tc_demo\"; }/" JK2-JO-Demo/code/rd-vanilla/tr_shader.cpp

            TAB=$(printf '\t')
            #sed "s/${TAB}//g" file
            sed -i '' "s/2048x1536/${width}x${height}/" JK2-JO-Demo/shared/sdl/sdl_window.cpp
            sed -i '' "s/2048,${TAB}1536/${width},${TAB}${height}/" JK2-JO-Demo/shared/sdl/sdl_window.cpp
            sed -i '' "s/2048x1536/${width}x${height}/" JK2-JO-Demo/codemp/rd-dedicated/tr_init.cpp
            sed -i '' "s/2048,${TAB}1536/${width},${TAB}${height}/" JK2-JO-Demo/codemp/rd-dedicated/tr_init.cpp

            sed -i '' "s/option(BuildJK2SPEngine \"Whether to create projects for the jk2 SP engine (openjo_sp.exe)\" OFF)/option(BuildJK2SPEngine \"Whether to create projects for the jk2 SP engine (openjo_sp.exe)\" ON)/" JK2-JO-Demo/CMakeLists.txt
            sed -i '' "s/option(BuildJK2SPGame \"Whether to create projects for the jk2 sp gamecode mod (jk2gamex86.dll)\" OFF)/option(BuildJK2SPGame \"Whether to create projects for the jk2 sp gamecode mod (jk2gamex86.dll)\" ON)/" JK2-JO-Demo/CMakeLists.txt
            sed -i '' "s/option(BuildJK2SPRdVanilla \"Whether to create projects for the jk2 sp renderer (rdjosp-vanilla_x86.dll)\" OFF)/option(BuildJK2SPRdVanilla \"Whether to create projects for the jk2 sp renderer (rdjosp-vanilla_x86.dll)\" ON)/" JK2-JO-Demo/CMakeLists.txt

        fi

        mkdir -p JK2-JO-Demo/build
        cd JK2-JO-Demo/build

        if [ "$os_name" = "FreeBSD" ]; then
            cmake -DCMAKE_CXX_FLAGS="-I/usr/local/include" ..
        else
            cmake ..
        fi

        make clean

        # Determine the number of CPU cores

        if [ "$os_name" = "Linux" ]; then
            cpu_cores=$(nproc)
        elif [ "$os_name" = "FreeBSD" ]; then
            cpu_cores=$(sysctl -n hw.ncpu)
        elif [ "$os_name" = "Darwin" ]; then
            cpu_cores=$(sysctl -n hw.ncpu)
        else
            echo "Unknown operating system: $os_name"
            echo "using 1 core"
            cpu_cores=1
        fi
        echo "compiling on $cpu_cores cores"

        # make help
        openjo=$(make help | grep openjo | cut -d ' ' -f 2)
        jospga=$(make help | grep jospga | cut -d ' ' -f 2)
        rdjosp=$(make help | grep rdjosp | cut -d ' ' -f 2)

        make $openjo -j$cpu_cores
        # Check the exit code of the 'make' command
        if [ $? -ne 0 ]; then
            echo "Error: 'make example' failed with exit code $?. Exiting script."
            exit 1 # Exit the script with a non-zero exit status to indicate an error
        else
            echo "make $openjo succeeded."
        fi

        make $jospga -j$cpu_cores
        # Check the exit code of the 'make' command
        if [ $? -ne 0 ]; then
            echo "Error: 'make example' failed with exit code $?. Exiting script."
            exit 1 # Exit the script with a non-zero exit status to indicate an error
        else
            echo "make $jospga succeeded."
        fi

        make $rdjosp -j$cpu_cores
        # Check the exit code of the 'make' command
        if [ $? -ne 0 ]; then
            echo "Error: 'make example' failed with exit code $?. Exiting script."
            exit 1 # Exit the script with a non-zero exit status to indicate an error
        else
            echo "make $rdjosp succeeded."
        fi

        if [ "$os_name" = "Darwin" ]; then
            cp codeJK2/game/"$jospga.dylib" "$openjo.app"/Contents/MacOS/
            cp code/rd-vanilla/"$rdjosp.dylib" "$openjo.app"/Contents/MacOS/
            mkdir "$openjo.app"/Contents/MacOS/base
            cd ..
            cd ..
            mv assets0.pk3 JK2-JO-Demo/build/"$openjo.app"/Contents/MacOS/base
        else
            cp codeJK2/game/jospga* .
            cp code/rd-vanilla/rdjosp* .
            mkdir base
            cd ..
            cd ..
            mv assets0.pk3 JK2-JO-Demo/build/base
        fi

        ;;
    6)
        # run

        if [ ! -d "JK2-JO-Demo/build" ]; then
            echo "Error: you must compile the game before"
            exit 0
        fi

        echo "in the \"more video\" menu check the brightness level"
        echo "there is a scale from 1 to 18 and if your brithness"
        echo "is correct you should barely see the number 6"
        echo " "
        echo "Use the Force, you must."
        echo "F5 to Heal"
        echo "F1 to Push your enemies"
        echo "Alt or MOUSE2 will throw your light saber like a boomerang"
        echo "Your light saber will deflect the enemies fire"
        echo " "
        echo "Press \"Enter\" to start"

        read choice
        cd JK2-JO-Demo/build
        openjo=$(make help | grep openjo | cut -d ' ' -f 2)

        if [ "$os_name" = "Darwin" ]; then
            ./"$openjo.app"/Contents/MacOS/$openjo
        else
            ./openjo*
        fi

        cd ..
        cd ..

        #./openjo* +set fs_cdpath base

        #In case of conflict with another StarWars / Quake3 game

        #You can create another account on your computer and install
        # this demo on it

        #You can set a custom search path using fs_basepath or fs_cdpath
        # when you run the game, e.g.
        #./openjk.i386 +set fs_cdpath ~/.jedi

        #You can also look at this source code to force the use of your path
        #code/qcommon/files.cpp    2578 Com_Printf ("Current search path:\n");

        ;;
    7)
        # install

        if [ ! -d "JK2-JO-Demo/build" ]; then
            echo "Error: you must compile the game before"
            exit 0
        fi
        echo "Install the game or shortcuts"
        cd JK2-JO-Demo/build
        if [ "$os_name" = "Darwin" ]; then

            openjo=$(make help | grep openjo | cut -d ' ' -f 2)
            cp -a -v "$openjo.app" /Applications
        else

            cat <<EOF >JK2.desktop
[Desktop Entry]
Type=Application
Name=Jedi-Knight-2-demo
Terminal=false
Categories=Game;ArcadeGame;
EOF

            openjo=$(make help | grep openjo | cut -d ' ' -f 2)

            echo "Exec="$(pwd)"/$openjo" >>JK2.desktop
            cd ..
            echo "Icon="$(pwd)"/shared/icons/OpenJK_Icon_128.png" >>build/JK2.desktop
            cd build

            mkdir -p ~/.local/share/applications

            #chmod +x JK2.desktop
            chmod 644 JK2.desktop
            mkdir -p ~/.local/share/applications
            cp JK2.desktop ~/.local/share/applications
            cp JK2.desktop ~/Desktop
        fi
        cd ..
        cd ..

        ;;
    8)
        echo "Help"
        echo " "
        echo "OpenJK Community effort to maintain and improve Jedi Academy"
        echo "(SP & MP) + Jedi Outcast (SP only) released by Raven Software "
        echo "https://github.com/JACoders/OpenJK"
        echo " "
        echo "Compilation guide"
        echo "https://github.com/JACoders/OpenJK/wiki/Compilation-guide"
        echo " "
        echo "JKHub sub-forum"
        echo "https://jkhub.org/forums/forum/49-openjk/"
        echo " "
        echo "In case of conflict with another StarWars / Quake3 game"
        echo " "
        echo "You can create another account on your computer and install"
        echo "this demo on it"
        echo " "
        echo "You can set a custom search path using fs_basepath or fs_cdpath"
        echo "when you run the game, e.g."
        echo "./openjo* +set fs_cdpath ~/.jedi"
        echo " "
        echo "You can also look at this source code to force the use of your path"
        echo "code/qcommon/files.cpp 2578 Com_Printf (\"Current search path:\n\");"
        echo " "
        echo "Press \"Enter\" to continue"

        read choice
        ;;
    9)
        echo "Exiting script."
        sync
        exit 0
        ;;
    10)
        echo "I'm sorry Dave, I'm afraid I can't do that"
        echo " "
        echo " "

        ;;

    *)
        if [ "$os_name" = "Darwin" ]; then
            echo "Invalid input. Please enter 1, 2, 3, 4, 5, 6, 7, 8, or 9."
        else
            echo "Invalid input. Please enter 1, 2, 3, 4, 5, 6, 7, or 8."
        fi
        echo " "
        echo "Press \"Enter\" to continue"

        read choice
        ;;
    esac
done

#shfmt -i 4 -w build-Mac.sh
