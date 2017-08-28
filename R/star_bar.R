#' geom_bar significance
#' 
#' Adds significance marks to a ggplot with a geom_bar.
#' 
#' @name star_bar
#' 
#' @param gg ggplot with a geom_bar to add significance marks.
#' @param significance logical vector with the significant pairs.
#' @param fit logical value indicating if the arc should fit the shape of the data.
#' @param arc.separation numerical value indicating the distance from the arc to the data.
#' @param arc.radius numerical value indicating radius of the arc.
#' @param size numerical value indicating the size of the asterisk.
#' @return gg ggplot with the geom_bar and the significance marks.
star_bar <- function(gg, significance, fit = FALSE, arc.separation = 0, arc.radius = 0.45, size = 15){
  
	pg <- ggplot_build(gg)

	data <- pg$data[[1]]
	data$x.arc <- (data$xmax + data$xmin)/2
	data$y.arc <- data$ymax
	    
	if ( nrow(data) == 4*length(significance) & sum(data$y.arc==max(data$y.arc)) == 0.5*nrow(data)){
	    data <- data[data$y.arc!=max(data$y.arc),]
	}

	data <- data[as.vector(rbind(significance,significance)),]

	min_step <- max(data$y.arc)/40
	model_arc <- create_model_arc(min_step, arc.radius)

	plot_symbols <- get_arcs_and_symbols(data, model_arc, min_step, fit, arc.separation)
	
	gg <- gg + 
	  geom_text(data=plot_symbols$asterisks, aes(x=x_ast,y=y_ast,label='*'), size = size, inherit.aes = F) + 
	  geom_line(data=plot_symbols$arcs, aes(x_arc,y_arc, group=group), inherit.aes = F)
  
  return(gg)
	       
}