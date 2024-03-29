% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DenANOVA.R
\name{DenANOVA}
\alias{DenANOVA}
\title{Fréchet ANOVA for Densities}
\usage{
DenANOVA(
  yin = NULL,
  hin = NULL,
  din = NULL,
  qin = NULL,
  supin = NULL,
  group = NULL,
  optns = list()
)
}
\arguments{
\item{yin}{A matrix or data frame or list holding the sample of measurements 
for the observed distributions. If \code{yin} is a matrix or data frame, 
each row holds the measurements for one distribution.}

\item{hin}{A list holding the histograms for the observed distributions.}

\item{din}{A matrix or data frame or list holding the density functions. 
If \code{din} is a matrix or data frame, each row of \code{din} holds 
the density function for one distribution.}

\item{qin}{A matrix or data frame or list holding the quantile functions. 
  If \code{qin} is a matrix or data frame, each row of \code{qin} holds 
  the quantile function for one distribution.
Note that the input can be only one of the four \code{yin}, \code{hin}, 
\code{din}, and \code{qin}. If more than one of them are specified, 
\code{yin} overwrites \code{hin}, \code{hin} overwrites \code{din}, 
and \code{din} overwrites \code{qin}.}

\item{supin}{A matrix or data frame or list holding the support grids of 
the density functions in \code{din} or the quantile functions in \code{qin}. 
If \code{supin} is a matrix or data frame, each row of \code{supin} holds 
the support grid of the corresponding density function or quantile function.
Ignored if the input is \code{yin} or \code{hin}.
It can also be a vector if all density functions in \code{din} or 
all quantile functions in \code{qin} have the same support grid.}

\item{group}{A vector containing the group memberships of the corresponding 
observed distributions in \code{yin} or \code{hin} or \code{din} or \code{qin}.}

\item{optns}{A list of control parameters specified by
\code{list(name = value)}. See `Details`.}
}
\value{
A \code{DenANOVA} object --- a list containing the following fields:
\item{pvalAsy}{a scalar holding the asymptotic \eqn{p}-value.}
\item{pvalBoot}{a scalar holding the bootstrap \eqn{p}-value.
  Returned if \code{optns$boot} is TRUE.}
\item{optns}{the control options used.}
}
\description{
Fréchet analysis of variance for densities with respect to 
  \eqn{L^2}-Wasserstein distance.
}
\details{
Available control options are 
\describe{
\item{boot}{Logical, also compute bootstrap \eqn{p}-value if \code{TRUE}. 
  Default is \code{FALSE}.}
\item{R}{The number of bootstrap replicates. Only used when \code{boot} 
  is \code{TRUE}. Default is 1000.}
\item{nqSup}{A scalar giving the number of the support points for 
  quantile functions based on which the \eqn{L^2} Wasserstein distance 
  (i.e., the \eqn{L^2} distance between the quantile functions) is computed. 
  Default is 201.}
\item{qSup}{A numeric vector holding the support grid on [0, 1] based on 
  which the \eqn{L^2} Wasserstein distance (i.e., the \eqn{L^2} distance 
  between the quantile functions) is computed. It overrides \code{nqSup}.}
\item{bwDen}{The bandwidth value used in \code{CreateDensity()} for
  density estimation; positive numeric - default: determine automatically 
  based on the data-driven bandwidth selector proposed by 
  Sheather and Jones (1991).}
\item{ndSup}{A scalar giving the number of support points the kernel density 
  estimation used in \code{CreateDensity()}; numeric - default: 101.}
\item{dSup}{User defined output grid for the support of 
  kernel density estimation used in \code{CreateDensity()}, 
  it overrides \code{ndSup}.}
\item{delta}{A scalar giving the size of the bin to be used used in 
  \code{CreateDensity()}; numeric - default: \code{diff(range(y))/1000}. 
  It only works when the raw sample is available.}
\item{kernelDen}{A character holding the type of kernel functions used in 
  \code{CreateDensity()} for density estimation; \code{"rect"}, 
  \code{"gauss"}, \code{"epan"}, \code{"gausvar"}, 
  \code{"quar"} - default: \code{"gauss"}.}
\item{infSupport}{logical if we expect the distribution to have 
  infinite support or not, used in \code{CreateDensity()} for 
  density estimation; logical - default: \code{FALSE}}
\item{denLowerThreshold}{\code{FALSE} or a positive value giving 
  the lower threshold of the densities used in \code{CreateDensity()}; 
  default: \code{0.001 * mean(qin[,ncol(qin)] - qin[,1])}.}
}
}
\examples{
\donttest{
set.seed(1)
n1 <- 100
n2 <- 100
delta <- 1
qSup <- seq(0.01, 0.99, (0.99 - 0.01) / 50)
mu1 <- rnorm(n1, mean = 0, sd = 0.5)
mu2 <- rnorm(n2, mean = delta, sd = 0.5)
Y1 <- lapply(1:n1, function(i) {
  qnorm(qSup, mu1[i], sd = 1)
})
Y2 <- lapply(1:n2, function(i) {
  qnorm(qSup, mu2[i], sd = 1)
})
Ly <- c(Y1, Y2)
Lx <- qSup
group <- c(rep(1, n1), rep(2, n2))
res <- DenANOVA(qin = Ly, supin = Lx, group = group, optns = list(boot = TRUE))
res$pvalAsy # returns asymptotic pvalue
res$pvalBoot # returns bootstrap pvalue
}
}
\references{
\itemize{
\item \cite{Dubey, P. and Müller, H.G., 2019. Fréchet analysis of variance for random objects. Biometrika, 106(4), pp.803-821.}
}
}
