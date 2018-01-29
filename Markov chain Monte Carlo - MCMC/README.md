
# Implementation of Markov Chain Monte Carlo (MCMC) using JAGS (Just Another Gibbs Sampler) on R


## Comparing the diﬃculty of two courses

Problem Statement

• Let θ be the diﬃculty of a course, y = 1 passing the course and y = 0 failing the course. Here y is distributed as a
   bernoulli distribution, with parameter 
 
   θ: y ∼ dbern(θ) (1)
  
• For courses 1 and 2 in a department, their diﬃculties, θ1 and θ2, are distributed as a beta distribution such that:

   θ1,θ2 ∼ dbeta(ω(κ−2) + 1,(1−ω)(κ−2) + 1), (2) 

   where ω is distributed as a beta distribution and κ−2 a gamma distribution: 
  
   ω ∼ dbeta(1,1) (3) κ−2 ∼ dgamma(0.01,0.01) (4) 

The goal here is to check whether course 1 is signiﬁcantly more diﬃcult than course 2 (95% HDI), given the outcome of 
the two courses


## Comparing the diﬃculty of two courses given other courses outcome

Problem Statement 

• Now besides the outcome of courses 1 and 2, the outcome of the other 48 courses, 3 to 50, are also known 

The goal here is to check whether course 1 is still signiﬁcantly more diﬃcult than course 2 (95% HDI), given the outcome
of all the 50 courses

