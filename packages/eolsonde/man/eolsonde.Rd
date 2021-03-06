\name{eolsonde-package}
\alias{eolsonde-package}
\alias{eolsonde}
\docType{package}
\title{
Read and Visualize EOL sounding data
}
\description{
This package contains functions for reading EOL sounding files and plotting the soundings.
}
\details{
\tabular{ll}{
Package: \tab eolsonde\cr
Depends: \tab lattice,maps, eolts, isfs\cr
License: \tab BSD_2_clause + file LICENSE\cr
}

Functions:
\describe{
\item{\link{readDFile}}{Read a D file}
\item{\link{readQCFile}}{Read a QC file}
\item{\link{readSoundings}}{Read one or more D or QC files}
\item{\link{sprofile}}{Plot profiles one or more variables in one sounding}
\item{\link{svprofile}}{Plot profiles of one variable over multiple soundings}
\item{\link{scontour}}{Plot contours of a variable over X=sounding, Y=pressure or altitude}
}
}
\author{
Gordon Maclean <maclean@ucar.edu>\cr
Author of original EOLsounding package: Liangying Zhang
}
\references{
}
\keyword{ package }
\keyword{ ts }
\seealso{
Use the following commands for help on a topic:
\tabular{ll}{
command \tab topic\cr
\code{class? nts} \tab \code{\linkS4class{nts}}\cr
\code{? nts} \tab \code{\link{nts}}\cr
\code{class? utime} \tab \code{\linkS4class{utime}}\cr
\code{? utime} \tab \code{\link{utime}}\cr
\code{? dpar} \tab \code{\link{dpar}}\cr
\code{? isfs} \tab \code{\link[isfs:isfs-package]{isfs}}\cr
\code{? eolts} \tab \code{\link[eolts:eolts-package]{eolts}}\cr
\code{? geoid_height} \tab \code{\link{geoid_height}}\cr
}
}
\examples{
}
