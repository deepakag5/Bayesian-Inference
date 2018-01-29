# Reference:
# Some of the code is from the book by Professor John K. Kruschke
# Please find the reference to and website of the book below:
# Kruschke, J. K. (2014). Doing Bayesian Data Analysis: A Tutorial with R, JAGS, and Stan. 2nd Edition. Academic Press / Elsevier
# https://sites.google.com/site/doingbayesiandataanalysis/

# genMCMC: generates the MCMC chain

source("DBDA2E-utilities.R")

#===============================================================================
genMCMC = function( data, numSavedSteps=11000 , saveName=NULL , thinSteps=1 ,
                    runjagsMethod=runjagsMethodDefault , 
                    nChains=nChainsDefault, courseNum ) { 
  require(rjags)
  require(runjags)

  #-----------------------------------------------------------------------------
  # THE DATA
  # Take the data of course 1 and course 2 by specifying variables yA and yB
  yA = data$course1
  yB = data$course2
  # Specify the number of unique subjects
  Nsubj = 2
  
  # Specify the data in a list, for later shipment to JAGS:
  dataList = list(
    yA = yA,
    yB = yB
  )
  #-----------------------------------------------------------------------------
  # THE MODEL.
  modelString = "
  model {
    
    for ( i in 1:length(yA) ) {
      yA[i] ~ dbern( theta[1] )
    }
    for ( i in 1:length(yB) ) {
      yB[i] ~ dbern( theta[2] )
    }
    theta[1] ~ dbeta( omega*(kappa-2)+1 , (1-omega)*(kappa-2)+1 )
    theta[2] ~ dbeta( omega*(kappa-2)+1 , (1-omega)*(kappa-2)+1 )
    
    omega ~ dbeta(1,1)
    
    kappaMinusTwo ~ dgamma(0.01,0.01)

    kappa = kappaMinusTwo + 2
  }
  "

 # close quote for modelString
  writeLines( modelString , con="TEMPmodel.txt" )
  
  #-----------------------------------------------------------------------------
  # INTIALIZE THE CHAINS.
  # Initial values of MCMC chains based on data:
  initsList = function() {
    # Specify the theta initial vector whose length should be equal to number of the subjects
    
    thetaInit = rep(0,Nsubj)
    
    # Resample the data and specify respective thetaInits
    
    resampledYA = sample( yA , replace=TRUE )
    thetaInit[1] = sum(resampledYA)/length(resampledYA)
    
    resampledYB = sample( yB , replace=TRUE )
    thetaInit[2] = sum(resampledYB)/length(resampledYB)
    
    # Respecify thetaInit to keep away from 0,1
    
    thetaInit = 0.001+0.998*thetaInit 
    
    # Specify omegaInit which equals to mean of all thetas
    
    omegaInit = mean(c(thetaInit[1],thetaInit[2]))
    
    # Specify kappaMinusTwoInit with 100 for lazy, start high and let burn-in find better value
    
    kappaMinusTwoInit = 100
    
    # Specify return list with initial values of theta, omega and kappaMinusTwo
    
    return( list( theta=thetaInit, 
                  omega=omegaInit,
                  kappaMinusTwo=kappaMinusTwoInit
                  ) )
  }
  
  #-----------------------------------------------------------------------------
  # RUN THE CHAINS
  # parameters = c("theta[1]","theta[2]") 
  parameters = c("theta", "omega", "kappa") 
  adaptSteps = 500             # Number of steps to adapt the samplers
  burnInSteps = 500            # Number of steps to burn-in the chains
  
  # Create, initialize, and adapt the model:
  jagsModel = jags.model( "TEMPmodel.txt" , data=dataList , inits=initsList , 
                          n.chains=nChains , n.adapt=adaptSteps )
  # Burn-in:
  cat( "Burning in the MCMC chain...\n" )
  update( jagsModel , n.iter=burnInSteps )
  # The saved MCMC chain:
  cat( "Sampling final MCMC chain...\n" )
  codaSamples = coda.samples( jagsModel , variable.names=parameters , 
                              n.iter=ceiling(numSavedSteps*thinSteps/nChains), 
                              thin=thinSteps )

  # resulting codaSamples object has these indices: 
  #   codaSamples[[ chainIdx ]][ stepIdx , paramIdx ]
  if ( !is.null(saveName) ) {
    save( codaSamples , file=paste(saveName,"Mcmc.Rdata",sep="") )
  }
  return( codaSamples )
}

#===============================================================================
plotMCMC = function( codaSamples , data ,
                     compVal=0.5 , rope=NULL , 
                     diffSList=NULL , diffCList=NULL , 
                     compValDiff=0.0 , ropeDiff=NULL , 
                     saveName=NULL , saveType="jpg" ) {
  # Now plot the posterior:
  mcmcMat = as.matrix(codaSamples,chains=TRUE)
  chainLength = NROW( mcmcMat )
  
  # Plot omega:
  openGraph(width=5,height=4)
  
  par( mar=c(2,2,2,2) , mgp=c(2.0,0.7,0) , pty="m" )
  postInfo = plotPost( mcmcMat[,"omega"] , 
                       compVal=compVal , ROPE=rope , 
                       cex.main=1.25 , cex.lab=1.25 , 
                       xlab="omega" ,
                       main="omega" )
  
  saveGraph( file=paste0(saveName,"mode"), type=saveType)
  
  # Plot individual theta's and differences:
  if ( !is.null(diffSList) ) {
    for ( compIdx in 1:length(diffSList) ) {
      diffSVec = diffSList[[compIdx]]
      Nidx = length(diffSVec)
      openGraph(width=2.5*Nidx,height=2.0*Nidx)
      par( mfrow=c(Nidx,Nidx) )
      xLim = range(c( compVal, rope,
                      mcmcMat[,diffSVec] ))
      for ( t1Idx in 1:Nidx ) {
        for ( t2Idx in 1:Nidx ) {
          parName1 = diffSVec[t1Idx]
          parName2 = diffSVec[t2Idx]
          if ( t1Idx > t2Idx) {  
            # plot.new() # empty plot, advance to next
            par( mar=c(3,3,3,1) , mgp=c(2.0,0.7,0) , pty="s" )
            nToPlot = 700
            ptIdx = round(seq(1,chainLength,length=nToPlot))
            plot ( mcmcMat[ptIdx,parName2] , mcmcMat[ptIdx,parName1] , 
                   cex.main=1.25 , cex.lab=1.25 , 
                   xlab=diffSVec[t2Idx] , 
                   ylab=diffSVec[t1Idx] , 
                   col="skyblue" )
            abline(0,1,lty="dotted")
          } else if ( t1Idx == t2Idx ) {
            par( mar=c(3,1.5,3,1.5) , mgp=c(2.0,0.7,0) , pty="m" )
            postInfo = plotPost( mcmcMat[,parName1] , 
                                 compVal=compVal , ROPE=rope , 
                                 cex.main=1.25 , cex.lab=1.25 , 
                                 xlab=bquote(.(parName1)) ,
                                 main=diffSVec[t1Idx] ,  
                                 xlim=xLim )
          } else if ( t1Idx < t2Idx ) {
            par( mar=c(3,1.5,3,1.5) , mgp=c(2.0,0.7,0) , pty="m" )
            postInfo = plotPost( mcmcMat[,parName1]-mcmcMat[,parName2] , 
                                 compVal=compValDiff , ROPE=ropeDiff , 
                                 cex.main=1.25 , cex.lab=1.25 , 
                                 xlab=bquote("Difference of "*omega*"'s") , 
                                 main=paste( diffSVec[t1Idx] ,
                                             "-",diffSVec[t2Idx] ) )
          }
        }
      }
      if ( !is.null(saveName) ) {
        saveGraph( file=paste0(saveName,"ThetaDiff",compIdx), type=saveType)
      }
    }
  }
}