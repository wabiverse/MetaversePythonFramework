# A Metaversal Python Framework

A metaverse project for building a version of Python that can be embedded
into a macOS, visionOS, iOS, tvOS or watchOS project.

**This branch builds a packaged version of Python 3.11.6**.
Other Python versions are available by cloning other branches of the main
repository:

* TBD.

It works by downloading, patching, and building a fat binary of Python and selected
pre-requisites, and packaging them as static libraries that can be incorporated into an
XCode project. The binary modules in the Python standard library are statically
compiled, but are distributed as objects that can be dynamically loaded at runtime.

It exposes *almost* all the modules in the Python standard library except for:

* ``dbm.gnu``
* ``tkinter``
* ``readline``
* ``nis`` (Deprecated by PEP594)
* ``ossaudiodev`` (Deprecated by PEP594)
* ``spwd`` (Deprecated by PEP594)

The following standard library modules are available on macOS, but not the other
Apple platforms:

* ``curses``
* ``grp``
* ``multiprocessing``
* ``posixshmem``
* ``posixsubprocess``
* ``syslog``

The binaries support **x86_64** and **arm64** for macOS; **arm64** for visionOS,
iOS and tvOS devices; and **arm64_32** for watchOS. It also supports device simulators
on both **x86_64** and **M1** hardware. This should enable the code to run on:

* **macOS** 12 (Monterey) or later, on:
    * MacBook (including MacBooks using Apple Silicon)
    * iMac (including iMacs using Apple Silicon)
    * Mac Mini (including Apple Silicon Mac minis)
    * Mac Studio (all models)
    * Mac Pro (all models)
* **visionOS** 1.0 or later, on:
    * Vision Pro (all models)
* **iOS** 12.0 or later, on:
    * iPhone (6s or later)
    * iPad (5th gen or later)
    * iPad Air (all models)
    * iPad Mini (2 or later)
    * iPad Pro (all models)
    * iPod Touch (7th gen or later)
* **tvOS** 9.0 or later, on:
    * Apple TV (4th gen or later)
* **watchOS** 4.0 or later, on:
    * Apple Watch (4th gen or later)

## Quickstart

Alternatively, to build the frameworks on your own, download/clone this
repository, and then in the root directory, and run:

* ``make`` (or ``make all``) to build everything.
* ``make macOS`` to build everything for macOS.
* ``make xrOS`` to build everything for visionOS.
* ``make iOS`` to build everything for iOS.
* ``make tvOS`` to build everything for tvOS.
* ``make watchOS`` to build everything for watchOS.

This should:

1. Download the original source packages
2. Patch them as required for compatibility with the selected OS
3. Build the packages as Xcode-compatible XCFrameworks.

The resulting support packages will be packaged as a ``.tar.gz`` file in the ``dist`` folder.

Each support package contains:

* ``VERSIONS``, a text file describing the specific versions of code used to build the
  support package;
* ``bin``, a folder containing shell aliases for the compilers that are needed
  to build packages. This is required because Xcode uses the ``xcrun`` alias to
  dynamically generate the name of binaries, but a lot of C tooling expects that ``CC``
  will not contain spaces.
* ``platform-site``, a folder that contains site customization scripts that can be used
  to make your local Python install look like it is an on-device install for each of the
  underlying target architectures supported by the platform. This is needed because when
  you run ``pip`` you'll be on a macOS machine with a specific architecture; if ``pip``
  tries to install a binary package, it will install a macOS binary wheel (which won't
  work on xrOS/iOS/tvOS/watchOS). However, if you add the ``platform-site`` folder to your
  ``PYTHONPATH`` when invoking pip, the site customization will make your Python install
  return ``platform`` and ``sysconfig`` responses consistent with on-device behavior,
  which will cause ``pip`` to install platform-appropriate packages.
* ``Python.xcframework``, a multi-architecture build of the Python runtime library
* ``python-stdlib``, the code and binary modules comprising the Python standard library.
  On xrOS, iOS, tvOS and watchOS, there are 2 copies of every binary module - one for physical
  devices, and one for the simulator. The simulator binaries are "fat", containing code
  for both x86_64 and arm64.

### Building binary wheels

When building binary wheels, you may need to use the libraries built by this
project as inputs (e.g., the `cffi` module uses `libffi`). To support this, this
project is able to package these dependencies as "wheels" that can be added to
the ``dist`` directory.

To build these wheels, run:

* ``make wheels`` to make all wheels for all mobile platforms
* ``make wheels-xrOS`` to build all the visionOS wheels
* ``make wheels-iOS`` to build all the iOS wheels
* ``make wheels-tvOS`` to build all the tvOS wheels
* ``make wheels-watchOS`` to build all the watchOS wheels
