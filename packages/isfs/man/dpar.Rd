\name{dpar}
\alias{dpar}
\alias{dpar_isfs}
\title{dpar parameters supported by the isfs package}
\description{
Use the \code{\link{dpar}} function to set or get global parameters for accessing and processing data, in similar manner to \code{\link{par}} for graphics parameters, or session options with \code{\link{options}}. This help page describes the parameters that are supported by the isfs package.
}
\section{Data Parameters}{
    \describe{
        \item{\code{avg}}{Numeric value, the time series averaging period in seconds.}
        \item{\code{accelgrav}}{Acceleration of gravity, in m/s^2 (in case we sample data on the moon).}
        \item{\code{co2_flux_corrected}}{Logical value indicating whether the covariances of co2 with the 3D wind coordinates in the current NetCDF dataset have been corrected for WPL80 and spatial decorrelation}
        \item{\code{coords}}{Character value, either "geo" or "instrument" indicating what 3D wind coordinates the user wants. If \code{coords} is not equal to \code{datacoords}, then the \code{dat.u} and \code{dat.v} functions will apply rotations to u and v, using the current value of \code{Vazimuth}. "geo" indicates geographic coordinates, where a  +U is wind to the east, +V is wind to the north.}
        \item{\code{datacoords}}{Character value, either "geo" or "instrument" indicating the coordinates of the 3D wind vectors in the current NetCDF dataset.}
        \item{\code{gsoil_philip_corrected}}{Logical value indicating whether the "Gsoil" variables from heat flux plate in the current NetCDF dataset have been corrected for the heat conductivity of the soil, per Philip, 1961.}
        \item{\code{h2o_flux_corrected}}{Logical value indicating whether the covariances of water vapor density (variable name "h2o") with the 3D wind coordinates in the current NetCDF dataset have been corrected for WPL80 and spatial decorrelation}
        \item{\code{hts}}{Numeric vector of measurement heights in meters, which is used to screen data read by \code{\link{dat}}. The height field is parsed from the variable name as a numeric field followed by "m" or "cm", where the fields in the name are separated by dots.  For example, "u.2.5m.far" has a height of 2.5 meters. A height field with a "cm" suffix is interpreted as a depth, and will be negative. "Tsoil.3.2cm.grass" has a "height" of -.032 meters.}
        \item{\code{lat}}{Latitude in degrees north. Use negative values for southern latitudes. This value is used by \code{dat("az.sun")} and \code{dat("el.sun")}}
        \item{\code{lon}}{Longitude in degrees east of Greenwich. Use negative values for west longitudes. This value is used by \code{dat("az.sun")} and \code{dat("el.sun")}}
        \item{\code{platform}}{Character value for the observing platform, used to annotate plots.}
        \item{\code{pyrgeometer.B}}{Numeric value used for the B coefficient in correcting longwave radiation (Rlw) for the pyrgeometer dome temperature (Tdome)}.
        \item{\code{pyrgeometer.swcor}}{Numeric factor used to correct longwave radiation for short wave contamination.}
        \item{\code{RH.ice}}{Logical value. Should the saturation vapor pressure (dat.satvp) be calculated wrt to ice or liquid water?}
        \item{\code{robust}}{Logical value used by ISFS data processing. When robust=TRUE, simple algorithms are used in derivations by the various \code{\link{dat}} functions. When robust=FALSE, more complicated algorithms, which may be less robust in terms of run-time errors, are used.}
        \item{\code{smooth}}{Numeric value, the time series smoothing period in seconds.}
        \item{\code{sfxs}}{Character vector of variable name suffixes, the last field in the name, separated by dots, which is used to screen data read by \code{\link{dat}}. This parameter should be avoided, use "sites" instead.}
        \item{\code{sites}}{Character vector of containing ISFS site names, which is used to screen data read by \code{\link{dat}}. The site name is the field in the variable name which follows the height, or if no height, as the last field in the variable name, where the fields are separated by dots.  E.g.  "far" in  "u.3m.far", or "Rpile.in.far".}
        \item{\code{stns}}{Integer vector of ISFS station numbers, which is used to screen data read by \code{\link{dat}}. 0 (zero) is the non-station index, for those variables which are not sampled at multiple stations.}
        \item{\code{vonKarmen}}{Numeric value of the vonKarmen coefficient.}
    }
}
\note{
\code{co2_flux_correction}, \code{h2o_flux_correction} and \code{gsoil_philip_correction} are read from global attributes in NetCDF files, when a dataset is selected.

\code{datacoords} is determined by checking the value of the dataset name. If it contains the string "geo" it will be set to "geo", otherwise "instrument". This needs further thought.
}
\references{
}
\author{
Gordon Maclean
}
\note{
}

\seealso{
\tabular{ll}{
?command \tab link\cr
\code{? dat} \tab \code{\link{dat}}\cr
\code{? dpar_eolts} \tab \code{\link{dpar_eolts}}\cr
\code{package? eolts} \tab \code{\link[eolts:eolts-package]{eolts}}\cr
}
}
\examples{
    
    myfunc  <-  function() {
        # change some parameters, saving original values
        old.dpar = dpar(stns=c(0,5:9),hts=3)
        # restore original values on function exit
        on.exit(dpar(old.dpar),add=TRUE)

        # ...
    }
}
\keyword{ ts }