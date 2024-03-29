% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/NetFIntegral.R
\name{NetFIntegral}
\alias{NetFIntegral}
\title{Generalized Fréchet integrals of network}
\usage{
NetFIntegral(phi, t_out, X, U)
}
\arguments{
\item{phi}{An eigenfunction along which we want to project the network}

\item{t_out}{Support of \code{phi}}

\item{X}{A three dimensional array of dimension \code{length(t_out) x m x m}, where \code{X[i,,]} is an \code{m x m} network adjacency matrix. The diagonal elements of adjacency matrices are zero and the off diagonal entries lie between zero and \code{U}.}

\item{U}{Upper bound of off-diagonal entries}
}
\value{
A list of the following:
\item{f}{An adjacency matrix which corresponds to the Fréchet integral of \code{X} along \code{phi}}
}
\description{
Calculating generalized Fréchet integrals of networks (equipped with Frobenius norm of adjacency matrices with zero diagonal elements and non negative off diagonal elements.)
}
\examples{
\donttest{
set.seed(5)
n <- 100
N <- 50
t_out <- seq(0,1,length.out = N)
library(mpoly)
p2 <- as.function(mpoly::jacobi(2,4,3),silent=TRUE)
p4 <- as.function(mpoly::jacobi(4,4,3),silent=TRUE)
p6 <- as.function(mpoly::jacobi(6,4,3),silent=TRUE)

# first three eigenfunctions
phi1 <- function(t){
p2(2*t-1)*t^(1.5)*(1-t)^2 / (integrate(function(x) p2(2*x-1)^2*x^(3)*(1-x)^4,0,1))$value^(1/2)
}
phi2 <- function(t){
p4(2*t-1)*t^(1.5)*(1-t)^2 / (integrate(function(x) p4(2*x-1)^2*x^(3)*(1-x)^4,0,1))$value^(1/2)
}
phi3 <- function(t){
p6(2*t-1)*t^(1.5)*(1-t)^2 / (integrate(function(x) p6(2*x-1)^2*x^(3)*(1-x)^4,0,1))$value^(1/2)
}

# random component of adjacency matrices
P12 <- 0.1 ## edge between compunities
Score <- matrix(runif(n*4), nrow = n)
# edge within first community
P1_vec <- 0.5 + 0.4*Score[,1] \%*\% t(phi1(t_out)) + 0.1*Score[,2] \%*\% t(phi3(t_out)) 
# edge within second community
P2_vec <- 0.5 + 0.3*Score[,3] \%*\% t(phi2(t_out)) + 0.1*Score[,4] \%*\% t(phi3(t_out)) 

# create Network edge matrix
N_net1 <- 5 # first community number
N_net2 <- 5 # second community number

# I: four dimension array of n x n matrix of squared distances between the time point u 
# of the ith process and process and the time point v of the jth object process,
# e.g.: I[i,j,u,v] <- d_F^2(X_i(u) X_j(v)).
I <- array(0, dim = c(n,n,N,N))
for(u in 1:N){
  for(v in 1:N){
   #frobenius norm between two adjcent matrix
    I[,,u,v] <- outer(P1_vec[,u], P1_vec[,v], function(a1, a2) (a1-a2)^2*(N_net1^2-N_net1)) +
      outer(P2_vec[,u], P2_vec[,v], function(a1, a2) (a1-a2)^2*(N_net2^2-N_net2))
  }
}


# check ObjCov work
Cov_result <- ObjCov(t_out, I, 3, smooth=FALSE)
Cov_result$lambda  # 0.266 0.15 0.04

# sum((Cov_result$phi[,1] - phi1(t_out))^2) / sum(phi1(t_out)^2)
# sum((Cov_result$phi[,2] - phi2(t_out))^2) / sum(phi2(t_out)^2)
# sum((Cov_result$phi[,3] - phi3(t_out))^2) / sum(phi3(t_out)^2)

# e.g. subj 2
subj <- 2
# X_mat is the network for varying times with X[i,,] is the adjacency matrices 
# for the ith time point
X_mat <- array(0, c(N,(N_net1+N_net2), (N_net1+N_net2)))
for(i in 1:N){
  # edge between communities is P12
  Mat <- matrix(P12, nrow = (N_net1+N_net2), ncol = (N_net1+N_net2)) 
  # edge within the first communitiy is P1
  Mat[1:N_net1, 1:N_net1] <- P1_vec[subj, i] 
  # edge within the second community is P2
  Mat[(N_net1+1):(N_net1+N_net2), (N_net1+1):(N_net1+N_net2)] <- P2_vec[subj, i] 
  diag(Mat) <- 0 #diagonal element is 0
  X_mat[i,,] <- Mat
}
# output the functional principal network(adjacency matrice) of the second eigenfunction
NetFIntegral(Cov_result$phi[,2], t_out, X_mat, 2)
}
}
\references{
\cite{Dubey, P., & Müller, H. G. (2020). Functional models for time‐varying random objects. Journal of the Royal Statistical Society: Series B (Statistical Methodology), 82(2), 275-327.}
}
