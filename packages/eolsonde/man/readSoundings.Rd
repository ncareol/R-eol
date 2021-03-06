\name{readSoundings}
\alias{readSoundings}
\title{
Function to read one or more soundings.
}
\description{
This function scans a directory for one or more files matching a name format given in the file parameter. A list, containing one or more sounding time series is returned.
}
\usage{
readSoundings(
    dir = c(file.path(Sys.getenv("SONDE_ROOT"), "projects", Sys.getenv("SPROJECT"),
            Sys.getenv("SPLATFORM"), "data", Sys.getenv("SDATASET")),
        Sys.getenv("SONDE_DATA")),
    file = c("D\%Y\%m\%d_\%H\%M\%S_P"),
    start = dpar("start"), end = dpar("end"))
}
\arguments{
  \item{dir}{
    A character vector containing one or more directories to scan. The default value is built from environment variables.
  }
  \item{file}{
    A character vector containing \itemize{
        \item names of one or more files
        \item one or more file name patterns, compatible with \code{\link{list.files}}.
        \item one or more names with time descriptors: \%Y, \%m, \%d, \%H, \%M and \%S, compatible with \code{\link{strptime}}.
    }
    }
  \item{start}{
A \code{\link{utime}} object containing the beginning time of files to be matched. This will only work if one uses a file name pattern containing \code{\link{strptime}} time descriptors.
}
  \item{end}{
A \code{\link{utime}} object containing the end time of files to be matched. This will only work if one uses a file name pattern containing \code{\link{strptime}} time descriptors.
}
}
\details{
From a Unix shell the default setting of dir translates to:
\itemize{
    \item $SONDE_ROOT/projects/$SPROJECT/$SPLATFORM/data/$SDATASET
    \item $SONDE_DATA
}
From a Windows command interpreter it translates to:
\itemize{
    \item \%SONDE_ROOT\%\\projects\\\%SPROJECT\%\\\%SPLATFORM\%\\data\\\%SDATASET\%
    \item \%SONDE_DATA\%
}

Note that in Windows, one can use the Unix-style forward-slash for the directory separator. The back-slash is an escape for special characters. See \link{Quotes}.

The directories are scanned for files whose names match one of the patterns in the \code{file} argument.

If the file argument contains time descriptors such as "\%Y", the initial string before the time descriptors should be a fixed string, i.e. it should not contain regular expressions.  The portion after a "\%S" time descriptor can contain regular expressions, such as ".*\\.gz".  If the file argument contains time descriptors, and \code{list.files} does not match any files, it is tried again, allowing any trailing characters after the file string.

The default value: \code{file = "D\%Y\%m\%d_\%H\%M\%S_P"} will match file names starting with D, followed by "YYYYMMDD_HHMMSS", followed by "_P", followed by any trailing characters.  Therefore it would match any of \itemize{
        \item D20080816_003205_PQC
        \item D20080816_003205_P
        \item D20080816_003205_P.gz
    }

If the file pattern contains time descriptors, then it is used to parse time from the file names, using \code{\link{strptime}}. A file is selected to be read if the time in its name falls between \code{start} and \code{end}.

If the first string in the file contains "AVAPS", it is read with \code{\link{readDFile}}, otherwise with \code{\link{readQCFile}}.

\code{\link{readDFile}} and \code{\link{readQCFile}} use the R functions \code{\link{read.table}} and \code{\link{scan}}. These functions are able to read files compressed with 'gzip2', 'bzip2', 'xz' or 'lzma'.
}
\value{
A list of sounding time series objects. The names of the elements in the list are the file names of the sounding. Each time series element is a \code{\link{dat}} object, containing a data.frame, with a column for each variable in the sounding. The time of each row in the time series can be accessed with the \code{\link{positions}} method.
}
\references{
}
\author{
\email{maclean@ucar.edu}
}
\note{
}

\seealso{
    \code{\link{readDFile}} \code{\link{readQCFile}}
}
\examples{

# Read sample D files provided in the eolsonde R package
dir = system.file(package="eolsonde","unitTests","data","D-file")

# start time for search of soundings
options(time.zone="UTC")
t1 = utime("2008 8 15 17:20")
# end time
t2 = t1 + 60 * 20   # add 20 minutes

xs = readSoundings(dir=dir,start=t1,end=t2)

# display the names of the soundings
names(xs)

# display the column (variable) names of a sounding
colnames(xs[[1]])

# display the first 10 rows and 5 columns of the 3rd sounding:
xs[[3]][1:10,1:5]

# Plot profiles of RH vs P for all soundings.
svprofile(xs,"RH","P")

# loop over the soundings and generate multiple plots
par(mfrow=c(2,ceiling(length(xs)/2)))

for (fname in names(xs)) {
    x = xs[[fname]]
    # Use @data to get numeric vector from the time series
    press = x@data[,"P"]
    temp = x@data[,"T"]
    # generic XY plot
    plot(temp,press)
    title(fname)
}

# Plot profiles of T,RH,Vz,Wspd vs P, all soundings, 
par(mfrow=c(2,2),ask=TRUE)
sprofile(xs,c("T","RH","Vz","Wspd"),"P")

\dontrun{
# set the default directory for readSoundings
Sys.setenv(SONDE_DATA="/net/isf/dropsonde3/kbeierle/MPEX-2013/Dfiles")
# file name pattern
file = "D\%Y\%m\%d_\%H\%M\%S_P.[0-9].PresCorr"
t1 = utime("2013 05 16 09:00")
t2 = t1 + 7200
xs = readSoundings(file=file,start=t1,end=t2)

# Windows
xs = readSoundings(dir="C:/AVAPS_DATA/D-files",...)
# or
Sys.setenv(SONDE_DATA="C:/AVAPS_DATA/D-files")
xs = readSoundings(...)
}
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ sounding }
