# Reference:
# Some of the code is from the book by Professor John K. Kruschke
# Please find the reference to and website of the book below:
# Kruschke, J. K. (2014). Doing Bayesian Data Analysis: A Tutorial with R, JAGS, and Stan. 2nd Edition. Academic Press / Elsevier
# https://sites.google.com/site/doingbayesiandataanalysis/

# genMCMC: generates the MCMC chain

#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
graphics.off() # This closes all of R's graphics windows.
rm(list=ls())  # Careful! This clears all of R's memory!

#------------------------------------------------------------------------------- 
# Generate course outcome
generateData = function() {
  # Generate test results using the sample function
  courseNum = 50
  studentNum= 100

  y = matrix(rep(0, courseNum * studentNum), ncol=courseNum )

  for (i in 1:courseNum) {
    if (i == 1) {
      y[, i] = sample(x = c(0, 1), prob = c(0.55, 0.45), size = studentNum, replace = TRUE)
    } else {
      pro = runif(1, 0.45, 0.45)
      y[, i] = sample(x = c(0, 1), prob = c(pro, 1 - pro), size = studentNum, replace = TRUE)
    }
  }

  courseOutcome = data.frame(y)
  colnames(courseOutcome) = paste0("course",1:courseNum)

  # Write courseOutcome data file
  write.csv(courseOutcome, file = "courseOutcome.csv", row.names = FALSE)
}
generateData()

#-------------------------------------------------------------------------------
# Read the data
myData = read.csv("courseOutcome.csv")

#-------------------------------------------------------------------------------
# Load the relevant model into R's working memory:
source("CompareCourses.R")

#-------------------------------------------------------------------------------
# Optional: Specify filename root and graphical format for saving output.
# Otherwise specify as NULL or leave saveName and saveType arguments
# out of function calls.
fileNameRoot = "courseOutcome_"
graphFileType = "pdf"

#-------------------------------------------------------------------------------
# Generate the MCMC chain:
mcmcCoda = genMCMC( data=myData , numSavedSteps=11000 , saveName=fileNameRoot ,
                    thinSteps=20, courseNum = 2 )

#-------------------------------------------------------------------------------
# Display diagnostics of chain, for specified parameters:
for ( parName in c("theta[1]","theta[2]") ) {
  diagMCMC( codaObject=mcmcCoda , parName=parName ,
                saveName=fileNameRoot , saveType=graphFileType )
}

#-------------------------------------------------------------------------------
# Display posterior information:
plotMCMC( mcmcCoda , data=myData ,
          compVal=NULL ,
          diffSList=list( c("theta[1]","theta[2]") ) ,
          compValDiff=0.0,
          saveName=fileNameRoot , saveType=graphFileType )
#-------------------------------------------------------------------------------
