get_arcs_and_symbols <- function(data, model_arc, min_step, fit, dist){
  arcs <- data.frame()
  ast <- data.frame()
  for (i in seq(1,nrow(data),2)){
    bar.pair <- data[c(i,i+1),]
    center.arc <- mean(bar.pair$x.arc)
    height.arc <- max(bar.pair$y.arc)
    
    this.arc <- data.frame(x_arc = model_arc$x + center.arc, y_arc= dist + model_arc$y + height.arc, group=i)
    
    if(fit){
      this.arc <- rbind(this.arc,data.frame(x_arc = bar.pair$x.arc[bar.pair$y.arc == min(bar.pair$y.arc)], 
                                            y_arc = dist + min(bar.pair$y.arc), group=i ))
    }
    
    arcs <- rbind(arcs,this.arc)
    
    tmp_ast <- data.frame(x_ast = center.arc, y_ast = dist + height.arc + 1.2 * min_step)
    ast <- rbind(ast,tmp_ast)
    
  }
  
  return(list(arcs = arcs, asterisks = ast))
  
}