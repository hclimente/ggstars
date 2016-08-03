#' geom_boxplot significance
#' 
#' Adds significance marks to a ggplot with a geom_boxplot.
#' 
#' @name star_boxplot
#' 
#' @param gg ggplot with a geom_boxplot to add significance marks.
#' @param significance logical vector with the significant pairs.
#' @return gg ggplot with the geom_boxplot and the significance marks.
star_boxplot <- function(gg,significance){
  
  if (rm.outliers){
    plotRanges <- ddply(ranges, .(Cancer,Categories), summarise, Q1=quantile(y, 1/4), Q3=quantile(y, 3/4), IQR=Q3-Q1, upper.limit=Q3+1.5*IQR)
    plotRanges <- ddply(plotRanges, .(Cancer), summarise, y=max(upper.limit))
  } else {
    plotRanges <- ddply(ranges, .(Cancer), summarise, y=max(y))
  }
  
  minStep <- max(plotRanges$y)/40
  
  r <- 0.25
  t <- seq(0, 180, by = 1) * pi / 180
  x <- r * cos(t)
  y <- minStep * sin(t)
  y[which(y>minStep/2)] <- minStep/2
  modelArc <- data.frame(x = x, y = y)
  
  arcs <- data.frame(Cancer=character(),x_arc=numeric() ,y_arc=numeric())
  ast <- data.frame(Cancer=character(),x_ast=numeric() ,y_ast=numeric())
  for (kns in stat.tests$Cancer[stat.tests$p < 0.05]){
    i <- which(categories==kns)
    j <- max(plotRanges$y[plotRanges$Cancer==kns])
    tmp_arc <- data.frame(Cancer=i, x_arc=modelArc$x+(i), y_arc=modelArc$y+j)
    arcs <- rbind(arcs,tmp_arc)
    
    tmp_ast <- data.frame(Cancer=i,x_ast=i ,y_ast=j + 1.2*minStep)
    ast <- rbind(ast,tmp_ast)
  }
  
  significanceElements <- list("asterisks" = ast, "arcs" = arcs)
  
  return(significanceElements)
  
}