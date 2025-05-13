
## V1.4.0

Published 13 May 2025

For countries having no "1 second arc resolution" elevation data available,  add a parameter allowing to use "3 seconds arc" instead
Modify documentation  consequently
 
## V1.3.0

Published 27 April 2025

Implementation evolution 
* Troubles with Kosmtik solved ( thanks to liam-bh ) Move to Debian:bookworm, for better stability 
* So Kosmtik becomes again the first proposed solution
* Consequently update readme.md and tutorial 

## V1.2.0

Published 20 April 2025

Implementation evolution
* Move to Debian:bookworm, due to sudden and incredible incompatibility for pybind11-rdp ( trouble with "required minimum version 3.4 for CMake" )
* Kosmtik build phase also fails . Promote Tirex as the good solution 
* Consequently update readme.md and tutorial 



## V1.1.0

Published January 2025

Features evolution
* Better rendering of difficult mountain paths ( mountain_hiking ; demanding_mountain_hiking ; alpine_hiking ; demanding/difficult_alpine_hiking)
* Mountain_hiking path never rendered as blue color
* Red overlay for mountain hiking routes
* zoom16 : show hiking guideposts
* add the capability to show a GPX route ( containing "route" <rte> elements )

Implementation evolution
* Strong improvement for handling road sizes : more than 3000 lines of codes suppressed
* Rebuild Postgres views, before starting rendering ( in case they contain style modifications )
* Project.mml: add a comment to each SQL request, to facilitate debug in case of error

## V1.0.0

First published version (December 2024)

