#' geom_boxplot significance
#' 
#' Adds significance marks to a ggplot with a geom_boxplot.
#' 
#' @name star_boxplot
#' 
#' @param gg ggplot with a geom_boxplot to add significance marks.
#' @param significance logical vector with the significant pairs.
#' @param rm.outliers logical value the arc should fit the data with or without the outliers.
#' @param fit logical value indicating if the arc should fit the shape of the data.
#' @param dist numerical value indicating the distance from the arc to the data.
#' @return gg ggplot with the geom_boxplot and the significance marks.
star_boxplot <- function(gg,significance,rm.outliers=TRUE, fit = FALSE, dist = 0.05){
  
  pg <- ggplot_build(gg)
  
  data <- pg$data[[1]]
  data$x.arc <- (data$xmax + data$xmin)/2
  data$y.arc <- data$ymax
  
  if (rm.outliers){
    data <- data[rep(significance, each = 2),]
  } else {
    plotRanges <- ddply(ranges, .(group), summarise, y=max(y))
  }
  
  min_step <- max(data$y.arc)/60
  model_arc <- create_model_arc(min_step, 0.25)
  
  plot_symbols <- get_arcs_and_symbols(data, model_arc, min_step, fit, dist)
  
  gg <- gg + 
    geom_text(data=plot_symbols$asterisks, aes(x=x_ast,y=y_ast,label='*'), size = 15, inherit.aes = F) + 
    geom_line(data=plot_symbols$arcs, aes(x_arc,y_arc, group=group), inherit.aes = F)
  
  return(gg)
  
}