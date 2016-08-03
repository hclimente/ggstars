#' geom_bar significance
#' 
#' Creates the ggplot layer to display a significance measure on a geom_bar.
#' 
#' @name geom_bar_star
#' 
#' @param categories all factors to be plotted
#' @param ranges contains the data for the categories for which an arc will be drawn
#' @param barsize
#' @param pairAxis
#' @return geom_bar_star
star_bar <- function(gg, significance){
  
	pg <- ggplot_build(p)

	data <- pg$data[[1]]
	data$x.arc <- (data$xmax + data$xmin)/2
	data$y.arc <- data$ymax
	    
	if ( nrow(data) == 4*length(significant) & sum(data$y.arc==max(data$y.arc)) == 0.5*nrow(data)){
	    data <- data[data$y.arc!=max(data$y.arc),]
	}

	data <- data[as.vector(rbind(significance,significance)),]
	    
	# create base arc
	## half circunference
	r <- 0.5
	t <- seq(0, 180, by = 1) * pi / 180
	x <- r * cos(t)
	y <- 1 * sin(t)
	  
	## flatten it, proportionally to the data
	minStep <- max(data$y.arc)/40
	y[which(y>minStep)] <- minStep
	modelArc <- data.frame(x = x, y = y)

	arcs <- data.frame()
	ast <- data.frame()
	for (i in seq(1,nrow(data),2)){
	    bar.pair <- data[c(i,i+1),]
	    center.arc <- mean(bar.pair$x.arc)
	    height.arc <- max(bar.pair$y.arc)
	    
	    this.arc <- data.frame(x_arc = modelArc$x + center.arc, y_arc= modelArc$y + height.arc, group=i)
	    this.arc <- rbind(this.arc,data.frame(x_arc = bar.pair$x.arc[bar.pair$y.arc == min(bar.pair$y.arc)], 
	                                          y_arc = min(bar.pair$y.arc), group=i ))
	    arcs <- rbind(arcs,this.arc)
	    
	    tmp_ast <- data.frame(x_ast = center.arc, y_ast = height.arc + 1.2 * minStep)
	    ast <- rbind(ast,tmp_ast)
	    
	}

	p + geom_text(data=ast, aes(x=x_ast,y=y_ast,label='*'), size = 15, inherit.aes = F) + 
	geom_line(data=arcs, aes(x_arc,y_arc, group=group), inherit.aes = F)
	       
}