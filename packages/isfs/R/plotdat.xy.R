# -*- mode: C++; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4; -*-
# vim: set shiftwidth=4 softtabstop=4 expandtab:
#
# 2013,2014, Copyright University Corporation for Atmospheric Research
# 
# This file is part of the "isfs" package for the R software environment.
# The license and distribution terms for this file may be found in the
# file LICENSE in this package.

plotdat.xy <- function(xdata,ydata, rfrnc, select.data, xlim, ylim, nsmth, 
                       plot=T, derived=T, method.smth="mean", 
                       lfit=F, intercept=T, cex.pts=0.5,
                       chksum=F, logxy, annotate=T, dataset=names(isfs::dataset()),
                       cex.leg = 1, browse=F, type="p", ...)
{
    # Generic function for xy plot of dat objects, per twh.
    #   e.g. plotdat.xy("P","RH")
    #
    # xdata, ydata = string or dat objects for variables to be plotted.
    # rfrnc = when ydata missing, xdata=xdata[,rfrnc] and ydata=xdata[,-rfrnc]
    # select.data = select subset of data
    # xlim = limits for abscissa (x axis).
    # ylim = limits for ordinate (y axis).
    # nsmth = number of data points for smoothing with block average.
    # derived = T replaces a derived variable with a basic variable
    # plot = F does not make plot
    # lfit = T makes a linear fit to the data
    # intercept = F calculates fit without intercept
    # chksum = T edits data on the basis of chksum
    # browse = T opens browser at end of function.
    # annotate = T is flag to add information on plot margin
    # if (is.null(dev.list())) cmotif()
   
    old.par <- par(cex=par("cex"), xaxs="i", yaxs="i", tck=0.02)
    on.exit(par(old.par))

    # input xdata
    if (is.character(xdata))
        xdata <- dat(xdata, derived=derived)
    xlabel <- class(xdata)[1]
    if (xlabel=="dat") {
        xlabel <- unique(dimnames(xdata)[[2]])
        if (length(xlabel) > 1) xlabel <- unique(words(xlabel,1,1))
    }
    xunits <- unique(xdata@units)
    dt <- deltat(xdata)["median"]
    clipx <- clip(xlabel)

    # input ydata
    if (!missing(ydata)) {
        if (is.character(ydata))
            ydata <- dat(ydata, derived=derived)
        ylabel <- class(ydata)[1]
        if (ylabel=="dat") {
            ylabel <- unique(dimnames(ydata)[[2]])
            if (length(ylabel) > 1) ylabel <- unique(words(ylabel,1,1))
        }
        if (ncol(xdata) != ncol(ydata) & ncol(xdata) != 1)
            stop(paste("data for",xlabel,"and",ylabel,"have incompatible dimensions"))
        yunits <- unique(ydata@units)
        clipy <- clip(ylabel)
    }
    else if (!missing(rfrnc)) {
        ydata <- xdata[,-rfrnc]
        xdata <- xdata[,rfrnc]
        ylabel <- xlabel
        yunits <- xunits
        clipy <- clipx
    }
    else stop("ydata and rfrnc both missing")
    
    # select subset of data
    if (!missing(select.data)) {
        xdata = xdata[select.data,]
        ydata = ydata[select.data,]
    }

    # edit data for plotting
    if (chksum) {
        okx <- dat("chksumOK.ALL_DATA")
        oky <- okx
        if (!missing(rfrnc)) {
            okx <- okx[,rfrnc]
            oky <- oky[,-rfrnc]
        }
        xdata[is.na(okx) | okx==0] <- NA_real_
        ydata[is.na(oky) | oky==0] <- NA_real_
    }
    xdata[is.infinite(xdata@data)] <- NA_real_
    ydata[is.infinite(ydata@data)] <- NA_real_
    if (!missing(nsmth) && nsmth>0) {
        xdata <- average(xdata,nsmth*dt,nsmth*dt, method=method.smth, simple=T)
        ydata <- average(ydata,nsmth*dt,nsmth*dt, method=method.smth, simple=T)
    }
    if (!missing(xlim)) {
        xdata[xdata < xlim[1]] <- xlim[1]
        xdata[xdata > xlim[2]] <- xlim[2]
    }
    else if (!is.null(clipx) && clipx$clip) {
        xlim <- c(clipx$min,clipx$max)
        xdata[xdata < xlim[1]] <- xlim[1]
        xdata[xdata > xlim[2]] <- xlim[2]
    }
    if (!missing(ylim)) {
        ydata[ydata < ylim[1]] <- ylim[1]
        ydata[ydata > ylim[2]] <- ylim[2]
    }
    else if (!is.null(clipy) && clipy$clip) {
        ylim <- c(clipy$min,clipy$max)
        ydata[ydata < ylim[1]] <- ylim[1]
        ydata[ydata > ylim[2]] <- ylim[2]
    }

    # delete variables with all missing data
    selecty <- rep(T, ncol(ydata))
    if (ncol(xdata)==1 && all(is.na(xdata)))
        stop(paste("all", dimnames(xdata)[[2]], "data missing"))
    for (i in 1:ncol(ydata)) 
        if (ncol(xdata)==1 && all(is.na(ydata[,i])))
            selecty[i] <- F
        else if (ncol(xdata)!=1 && (all(is.na(xdata[,i])) | all(is.na(ydata[,i]))))
            selecty[i] <- F
    ydata <- ydata[,selecty]
    if (ncol(xdata)!=1)
        xdata <- xdata[,selecty]

    # reorder matrix columns in ascending order of heights
    hts <- heights(dimnames(ydata)[[2]])
    ydata <- ydata[,order(hts)]
    if (ncol(xdata) == ncol(ydata))
        xdata <- xdata[,order(hts)]

    # create axis label
    xlab <- xlabel
    if (!is.null(xunits) && xunits != "") 
        xlab <- paste(xlab, " (", xunits, ")", sep="")
    if (ncol(xdata)==1) {
        ref.label <- suffixes(xdata, 1+nwords(xlabel,"."),"")
        if (!is.null(stns <- stations(xdata)))
            if (is.null(names(stns)))
                ref.label <- paste(ref.label,"stn",stns)
            else
                ref.label <- paste(ref.label, names(stns))
        xlab <- paste(ref.label," ",xlab)
    }
    ylab <- ylabel
    if (!is.null(yunits) && yunits != "") 
        ylab <- paste(ylab, " (", yunits, ")", sep="")
    if (missing(logxy))
        logxy <- ""

    # plot data
    x <- xdata@data
    y <- ydata@data
    if (plot) {
        plot.default(xdata[,1]@data, ydata[,1]@data, type="n", log=logxy,
                 xlab=xlab, ylab=ylab, ...)

	if (type!="n") {
            for (i in 1:ncol(ydata)) {
                ix <- min(ncol(xdata),1)
                points(x[,ix],y[,i], pch=8, col=i, cex=cex.pts)
            }
        }
    }
    if (lfit) {
        if (intercept)
            fit.coeff <- matrix(nrow=ncol(ydata),ncol=2)
        else
            fit.coeff <- matrix(nrow=ncol(ydata),ncol=1)
        rms <- vector(length=ncol(ydata))
        for (i in 1:ncol(ydata)) {

            # x might be one column
            ix <- min(ncol(xdata),1)

            select <- !is.na(x[,ix]) & !is.na(y[,i]) 
            if (!missing(xlim) | (!is.null(clipx) && clipx$clip)) 
                select = select & xlim[1] < x[,ix] & x[,ix] < xlim[2]
            if (!missing(ylim) | (!is.null(clipy) && clipy$clip)) 
                select = select & ylim[1] < y[,i] & y[,i] < ylim[2]
            if (intercept)
                fit <- quantreg::rq(y[select,i] ~ x[select,ix],tau=0.5)
            else
                fit <- quantreg::rq(y[select,i] ~ x[select,ix] - 1,tau=0.5)
            if (intercept)
                yfit <- fit$coefficients[1] + x[select,ix]*fit$coefficients[2] 
            else
                yfit <- x[select,ix]*fit$coefficients[1] 

            fit.coeff[i,] <- fit$coefficients
            rms[i] <- sqrt(var(fit$residuals))
            if (plot & type != "n") {
                abline(fit, col=i,lty=2)
                if (units(xdata[,ix]) == units(ydata[,i])) abline(0,1)
            }
            # test yfit
            # points(x[select,i], yfit, pch=3)
        }
    }
    else
        fit = F
   
    # annotate plot
    if (plot) {
        axis(3, labels=F)
        axis(4, labels=F)
        usr <- par("usr")
        if (logxy == "") {
            if (usr[1]*usr[2] < 0)
                abline(v=0)
            if (usr[3]*usr[4] < 0)
                abline(h=0)
        }
        if (annotate)
            logo_stamp(F)

        # add legend
        xleg <- usr[1] + 0.01*(usr[2]-usr[1])
        yleg <- usr[3] + 0.96*(usr[4]-usr[3])
        if (!missing(logxy))
            if (logxy=="x" | logxy=="xy")
                xleg <- 10^xleg
            if (logxy=="y" | logxy=="xy")
                yleg <- 10^yleg
     
        labels <- suffixes(ydata, 1+nwords(ylabel,"."),"")
        if (!is.null(stns <- stations(ydata)))
            if (is.null(names(stns)))
                labels <- paste(labels,"stn",stns)
            else
                labels <- paste(labels, names(stns))
        if (ncol(xdata)!=1) {
            vs.labels <- suffixes(xdata, 1+nwords(xlabel,"."),"")
            if (!is.null(stns <- stations(xdata)))
                if (is.null(names(stns)))
                    vs.labels <- paste(vs.labels,"stn",stns)
                else
                    vs.labels <- paste(vs.labels, names(stns))
            labels <- paste(labels, "vs", vs.labels)
        }
        labels <- ""
        if (lfit) {
            ylabel <- colnames(ydata)
            xlabel <- colnames(xdata)
            if (intercept) {
                pm <- c(-1,0,1)
                names(pm) <- c("-","+","+")
                pm <- names(pm[match(sign(fit.coeff[,1]),pm)])
                labels <- paste(ylabel,"=",signif(fit.coeff[,2],3),
                                xlabel, pm, abs(signif(fit.coeff[,1],2)),
                                ", rms =", signif(rms,2))
            }
            else
                labels <- paste(ylabel,"=",signif(fit.coeff[,1],3),
                                xlabel, ", rms =", signif(rms,2))
        }
        else if (ncol(xdata)!=1) {
            labels <- suffixes(ydata, 1+nwords(ylabel,"."),"")
            if (!is.null(stns <- stations(ydata)))
              if (is.null(names(stns)))
                  labels <- paste(labels,"stn",stns)
              else
                  labels <- paste(labels, names(stns))
            vs.labels <- suffixes(xdata, 1+nwords(xlabel,"."),"")
            if (!is.null(stns <- stations(xdata)))
                if (is.null(names(stns)))
                    vs.labels <- paste(vs.labels,"stn",stns)
                else
                    vs.labels <- paste(vs.labels, names(stns))
            labels <- paste(labels, "vs", vs.labels)
        }
        if (!all(labels == "")) # new
            legend(xleg,yleg, labels, pch=rep(16,ncol(ydata)), col=1:ncol(ydata), 
                 lty=2, lwd=1.5, bg="transparent", bty="n", cex=cex.leg)

        # print time range, low-pass filter
        t1 <- max(start(xdata[!is.na(xdata),]),start(ydata[!is.na(ydata),]))
        t2 <- min(end(xdata[!is.na(xdata),]),end(ydata[!is.na(ydata),]))
        # max/min operators lose utime formatting
        t1 = utime(t1)	
        t2 = utime(t2)
        if (annotate) label_times(t1,t2)
      
        DT1 <- 0
        DT2 <- 0
        if (!missing(nsmth))
            DT1 <- nsmth*dt
        if (!is.null(dpar("avg")) && dpar("avg")[1]!=0)
            DT2 <- dpar("avg")[1]
        if (DT1>0 | DT2>0)  
            avg <- paste(max(DT1,DT2), " sec block average", sep="")
        else
            avg = ""
        if (annotate)
            label_times(t1,t2, annotate=avg)
      
        # print dataset
        if (annotate)
            mtext(paste0("dataset=", dataset), 3, adj=1)
    } 
    if (browse) {
        cat(paste("Plotted data are in objects \"xdata\" and \"ydata\"\n",
                "Type \"c\" to exit browser\n", sep=""))
        browser()
    }
    # output data to examine residuals
    if (missing(select.data)) select.data=T

    invisible(list(xdata=xdata, ydata=ydata, select.data=select.data, 
                      select=select, fit=fit))
}
