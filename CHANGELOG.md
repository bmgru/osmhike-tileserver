
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

