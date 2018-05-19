
## Download and Install JAGS library and rjags package for Bayesian Data Analysis using MCMC

### Windows :

STEP-1 Download JAGS Library from below link :

https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Windows/JAGS-4.3.0.exe/download

STEP-2 Check under programs & features for JAGS VERSION 4.3.0

STEP-3 Finally Install 'rjags' package in Rstudio 

         install.packages("rjags", configure.args="--with-jags...")

### MAC OS :

STEP-1 Download JAGS Library from this repository (JAGS-4.3.0.dmg file) or follow below link :
       
https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Mac%20OS%20X/JAGS-4.3.0.dmg/download

STEP-2 Check if Library is installed by typing below command on terminal
	   
	     pkg-config --modversion jags

	     (It should return version 4.3.0)

STEP-3 Finally Install 'rjags' package in Rstudio 

         install.packages("rjags", configure.args="--with-jags...")
         
         

### Linux (Debian based) OS :

STEP-1 Download JAGS Library from this repository (jags_4.3.0-1_amd64.deb file) or follow below link :
       
http://ftp.debian.org/debian/pool/main/j/jags/    (file jags_4.3.0-1_amd64.deb - size 781 kb)

STEP-2 Check if Library is installed by typing below command on terminal
	   
	     pkg-config --modversion jags

	     (It should return version 4.3.0)

STEP-3 Finally Install 'rjags' package in Rstudio 

         install.packages("rjags", configure.args="--with-jags...")



## Additional Notes 

Sometimes graphs are not displayed when we run program with RStudio (especially for MAC OS). 

For that please download X11 :

http://xquartz.macosforge.org/landing/

To install it please watch below youtube video till 2 minutes :

https://www.youtube.com/watch?v=uS4zTqfwSSQ
 
(Quick Note : If your MAC system is not allowing you to install the software you may need to provide permission to install apps from third party. Please follow youtube link https://www.youtube.com/watch?v=xFpVqkyXFy4 to see how it's done !)
