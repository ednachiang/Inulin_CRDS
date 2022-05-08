# Calculate standard error
se <- function(x){
  sd(x)/sqrt(length(x))
}

# Steal legend
g_legend <- function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}


fligner.abx.2boot <- function(sample1, sample2){
  bothSamp <- c(sample1, sample2)
  group <- c(rep(1,length(sample1)), rep(2, length(sample2)))
  bothSamp1 <- bothSamp - tapply(bothSamp, group, median)[group]
  
  a <- qnorm((1 + rank(abs(bothSamp1)) / (length(bothSamp1) + 1)) / 2)
  STAT <- sum(tapply(a, group, "sum")^2 / tapply(a, group, "length"))
  STAT <- (STAT - length(bothSamp1) * mean(a)^2) / var(a)
  STAT
  
}

fligner.2samp.2boot <- function(sample){
  sampMinusMedian <- sample - median(sample)
  rank(abs(sampMinusMedian))
  
}


### Define fligner.test to calculate CI
fligner.abx.stat <- function(y, w){
  #fact1 <- 1:table(y[,2])[1]
  y <- y - tapply(y,w,median)[w]

  a <- qnorm((1 + rank(abs(y)) / (length(y) + 1)) / 2)
  STATISTIC <- sum(tapply(a, w, "sum")^2 / tapply(a, w, "length"))
  STATISTIC <- (STATISTIC - length(y) * mean(a)^2) / var(a)
  #PARAMETER <- 1
  #PVAL <- pchisq(STATISTIC, PARAMETER, lower.tail = FALSE)
  STATISTIC
}



fligner.test.default <-
  function(x, g, ...)
  {
    ## FIXME: This is the same code as in kruskal.test(), and could also
    ## rewrite bartlett.test() accordingly ...
    if (is.list(x)) {
      if (length(x) < 2L)
        stop("'x' must be a list with at least 2 elements")
      DNAME <- deparse(substitute(x))
      x <- lapply(x, function(u) u <- u[complete.cases(u)])
      k <- length(x)
      l <- sapply(x, "length")
      if (any(l == 0))
        stop("all groups must contain data")
      g <- factor(rep(1 : k, l))
      x <- unlist(x)
    }
    else {
      if (length(x) != length(g))
        stop("'x' and 'g' must have the same length")
      DNAME <- paste(deparse(substitute(x)), "and",
                     deparse(substitute(g)))
      OK <- complete.cases(x, g)
      x <- x[OK]
      g <- g[OK]
      if (!all(is.finite(g)))
        stop("all group levels must be finite")
      g <- factor(g)
      k <- nlevels(g)
      if (k < 2)
        stop("all observations are in the same group")
    }
    n <- length(x)
    if (n < 2)
      stop("not enough observations")
    ## FIXME: now the specific part begins.
    
    ## Careful. This assumes that g is a factor:
    x <- x - tapply(x,g,median)[g]
    
    a <- qnorm((1 + rank(abs(x)) / (n + 1)) / 2)
    STATISTIC <- sum(tapply(a, g, "sum")^2 / tapply(a, g, "length"))
    STATISTIC <- (STATISTIC - n * mean(a)^2) / var(a)
    PARAMETER <- k - 1
    PVAL <- pchisq(STATISTIC, PARAMETER, lower.tail = FALSE)
    names(STATISTIC) <- "Fligner-Killeen:med chi-squared"
    names(PARAMETER) <- "df"
    METHOD <- "Fligner-Killeen test of homogeneity of variances"
    
    RVAL <- list(statistic = STATISTIC,
                 parameter = PARAMETER,
                 p.value = PVAL,
                 method = METHOD,
                 data.name = DNAME)
    class(RVAL) <- "htest"
    return(RVAL)
  }




fligner.test.formula <-
  function(formula, data, subset, na.action, ...)
  {
    if(missing(formula) || (length(formula) != 3L))
      stop("'formula' missing or incorrect")
    m <- match.call(expand.dots = FALSE)
    if(is.matrix(eval(m$data, parent.frame())))
      m$data <- as.data.frame(data)
    m[[1L]] <- quote(model.frame)
    mf <- eval(m, parent.frame())
    if(length(mf) != 2L)
      stop("'formula' should be of the form response ~ group")
    DNAME <- paste(names(mf), collapse = " by ")
    names(mf) <- NULL
    y <- do.call("fligner.test", as.list(mf))
    y$data.name <- DNAME
    y
  }









two.boot <- function(sample1, sample2, FUN, R, student = FALSE, M,
                     weights = NULL, ...) {
  func.name <- ifelse(is.character(FUN), FUN, deparse(substitute(FUN)))
  func <- match.fun(FUN)
  ind <- c(rep(1, length(sample1)), rep(2, length(sample2)))
  nobsgrp <- as.numeric(table(ind))
  extra <- list(...)
  

  boot.func <- function(x, idx) {
    d1 <- x[idx[ind == 1]]
    d2 <- x[idx[ind == 2]]
    fval <- func(d1, ...) - func(d2, ...)
    
    if(student) {
      b <- two.boot(d1, d2, FUN, R = M, student = FALSE,
                    M = NULL, weights = NULL, ...) 
      fval <- c(fval, var(b$t))
    }
    fval
  }
  if(!is.null(weights))
    weights <- unlist(weights)
  b <- boot(c(sample1, sample2), statistic = boot.func, R = R,
            weights = weights, strata = ind)
  b$student <- student
  structure(b, class = "simpleboot")
}







boot.func <- function(x, idx) {
  d1 <- x[idx[ind == 1]]
  d2 <- x[idx[ind == 2]]
  fval <- func(d1, ...) - func(d2, ...)
  
  if(student) {
    b <- two.boot(d1, d2, FUN, R = M, student = FALSE,
                  M = NULL, weights = NULL, ...) 
    fval <- c(fval, var(b$t))
  }
  fval
}






abc.ci.fligner <- function (data, statistic, index = 1, strata = rep(1, n), conf = 0.95, 
          eps = 0.001/n, ...) {
  y <- data
  n <- NROW(y)
  strata1 <- tapply(strata, as.numeric(strata))
  if (length(index) != 1L) {
    warning("only first element of 'index' used in 'abc.ci'")
    index <- index[1L]
  }
  S <- length(table(strata1))
  mat <- matrix(0, n, S)
  for (s in 1L:S) {
    gp <- seq_len(n)[strata1 == s]
    mat[gp, s] <- 1
  }
  w.orig <- rep(1/n, n)
  t0 <- statistic(y, w.orig/(w.orig %*% mat)[strata1])[1]
  L <- L2 <- numeric(n)
  for (i in seq_len(n)) {
    w1 <- (1 - eps) * w.orig
    w1[i] <- w1[i] + eps
    w2 <- (1 + eps) * w.orig
    w2[i] <- w2[i] - eps
    t1 <- mean.diff(y, w1/(w1 %*% mat)[strata1])[1]
    t2 <- mean.diff(y, w2/(w2 %*% mat)[strata1])[1]
    L[i] <- (t1 - t2)/(2 * eps)
    L2[i] <- (t1 - 2 * t0 + t2)/eps^2
  }
  temp1 <- sum(L * L)
  sigmahat <- sqrt(temp1)/n
  ahat <- sum(L^3)/(6 * temp1^1.5)
  bhat <- sum(L2)/(2 * n * n)
  dhat <- L/(n * n * sigmahat)
  w3 <- w.orig + eps * dhat
  w4 <- w.orig - eps * dhat
  chat <- (statistic(y, w3/(w3 %*% mat)[strata1], ...)[index] - 
             2 * t0 + statistic(y, w4/(w4 %*% mat)[strata1], ...)[index])/(2 * 
                                                                             eps * eps * sigmahat)
  bprime <- ahat - (bhat/sigmahat - chat)
  alpha <- (1 + as.vector(rbind(-conf, conf)))/2
  zalpha <- qnorm(alpha)
  lalpha <- (bprime + zalpha)/(1 - ahat * (bprime + zalpha))^2
  out <- seq(alpha)
  for (i in seq_along(alpha)) {
    w.fin <- w.orig + lalpha[i] * dhat
    out[i] <- statistic(y, w.fin/(w.fin %*% mat)[strata1], 
                        ...)[index]
  }
  out <- cbind(conf, matrix(out, ncol = 2L, byrow = TRUE))
  if (length(conf) == 1L) 
    out <- as.vector(out)
  out
}