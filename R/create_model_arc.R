create_model_arc <- function(min_step, r){
  ## half circunference
  t <- seq(0, 180, by = 1) * pi / 180
  x <- r * cos(t)
  y <- 1 * sin(t)
  
  ## flatten it, proportionally to the data
  y[which(y>min_step)] <- min_step
  data.frame(x = x, y = y)
}