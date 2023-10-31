# SNaG-app

Cloud application for space navigation and guidance exercises, problems, and projects.

* SNaG-app uses astrodynamics [web APIs](https://en.wikipedia.org/wiki/Web_API) to do astrodynamics computations and to provide data on satellite orbits and the orbital environment.
* Computations are performed with [ORaaS](https://oraas.orekit.space/index.html), a web API for the space dynamics library [Orekit](https://www.orekit.org/).
* Orbital information is obtained from the US government official source [space-track](https://www.space-track.org/).
* User interaction is through Matlab.
* [Documentation](https://orbitdynamics.gitlab.io/snag-app/)


## Installation
* Download [zip](https://gitlab.com/orbitdynamics/snag-app/-/archive/release/snag-app-master.zip) or
[tar.gz](https://gitlab.com/orbitdynamics/snag-app/-/archive/release/snag-app-master.tar.gz) of the latest release.
* Extract and place in a location you choose, note or copy the full path of `startup.m` ([how to](https://www.howtogeek.com/670447/) on Windows)
* After installation, run the startup file `run("`_full path_`")` with the full path.
* Check installation and initialization: `~isempty(strfind(string(path),"snag-app"))` should be true (logical 1). If it is not, then either the files are not extracted or the path is not set correctly; repeat the above steps.
* Check whether ORaaS server is available to you: `checkserver`.
* In order to have SNaG-app available every time you start up Matlab, create a file named `startup.m` in whatever folder `userpath` returns (or you can [set userpath](https://www.mathworks.com/help/matlab/ref/userpath.html) to somewhere else). This file should have the `run` function call above.
