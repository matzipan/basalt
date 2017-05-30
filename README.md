# Basalt

This library contains components from the [Envoyer](http://github.com/matzipan/envoyer) 
app that are reusable enough that other developers might benefit from them. It was 
originally intended to be merged into [Granite](http://github.com/elementary/granite),
but it is too opinionated.

# Using it

It is meant to be statically linked, so it might need some convincing if it needs packaging 
as a shared library. To link against it, add it as a git submodule: 

    git submodule add git@github.com:matzipan/basalt lib/basalt
    
And then add the following line to your `CMakeLists.txt` file:

    add_subdirectory (lib/basalt)

## Building, Testing, and Installation

You'll need the following dependencies:
* cmake
* gobject-introspection
* libgee-0.8-dev
* libgirepository1.0-dev
* libgtk-3-dev
* valac

It's recommended to create a clean build environment

    mkdir build
    cd build/

To see a demo app of Basalt's widgets, use `basalt-demo`

    ./demo/basalt-demo

## Documentation

To generate Vala documentation from this repository, use `make valadocs`

    make valadocs

To generate C documentation from this repository, use `make cdocs`

    make cdocs

To generate both C and Vala documentation at once, use `make docs`

    make docs
