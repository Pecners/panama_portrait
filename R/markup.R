# ENGLISH VERSION

# Need to have rendered the base visual
# with R/render_graphic.R before running
# this script.

library(tidyverse)
library(magick)
library(glue)
library(colorspace)

header <- readRDS("R/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[9]
text_second <- colors[8]

img <- image_read(header$outfile)
image_info(img)

# FONTS

# These will need to be installed on your machine if
# they aren't already. Poller One and Amarante can
# be installed from https://fonts.google.com/.

# Set main font
t1 <- "Poller One"

# Set second font
t2 <- "Amarante"

annot <- "Population estimates are bucketed into 400 metre hexagons."

cat(annot)


img |>
  image_crop(geometry = "9000x6750+0+0", gravity = "center") |> 
  
  # MAIN TITLE
  
  image_annotate(text = "ISTHMUS OF PANAMA", 
                 gravity = "NORTH",
                 location = "-1500+600", font = t1,
                 color = text_color, kerning = 50,
                 size = 300, weight = 700) |> 
  
  # SUBTITLE
  
  image_annotate(text = "POPULATION DENSITY",
                 gravity = "NORTH",
                 location = "-1500+1000", font = t2,
                 color = text_second, kerning = 75,
                 weight = 700,
                 size = 275) |>
  
  # DATA SOURCE
  
  image_annotate(text = glue("Kontur Population Data (Released June 30, 2022)"),
                 gravity = "NORTH",
                 location = "-1500+1350", font = t2,
                 color = colors[8],
                 kerning = 47,
                 size = 75) |>
  
  # DATA EXPLANATION
  
  image_annotate(text = annot,
                 gravity = "north",
                 location = "-1500+1500", font = t2,
                 color = colors[8],
                 kerning = 31,
                 size = 75) |>
  image_write("images/titled_pan_pop.png")

# These code chunks use the system() call to run 
# imagemagick commands from the command line. I do
# this because the {magick} R package (used above)
# doesn't have the full functionality. Specifically,
# I am rotating and arcing the text below.

# Add the lat-long labels
system(
  glue("convert -size 9000x6750 xc:none ",
       "-gravity southeast -font Amarante-Regular ",
       "-pointsize 60 -strokewidth 0 ",
       "-fill '{alpha(text_second, .4)}' ",

       "-annotate -19x-30+8030+3540 '82°W' ", 
       
       "-annotate -19x-30+5580+4330 '80°W' ",
       "-annotate -19x-30+3150+5150 '78°W' ",
       "-annotate -19x-30+1030+4850 \"9°30'N\" ",
       "-annotate -19x-30+7820+710 \"7°30'N\" ",
       
       "images/titled_pan_pop.png +swap ",
       "-composite images/titled_pan_pop_deg.png")
)


# Carribbean Sea
system(
  glue("convert -size 9000x6750 xc:none -gravity Center ",

       "-stroke '{alpha(text_color, .1)}' -fill '{alpha(text_color, .1)}' ",
       "-pointsize 100 -kerning 250 -font Poller-One ",
       "-annotate -1000+1000 'CARRIBBEAN SEA' ",
       "-distort Arc 90 -background none +repage ",

       "-rotate -15 images/titled_pan_pop_deg.png +swap ",
       "-gravity center -geometry +300-1800 ",
       "-composite images/titled_pan_pop_car.png")
)

# Pacific Ocean
system(
  glue("convert -size 9000x6750 xc:none -gravity Center ",
       
       "-stroke '{alpha(text_color, .1)}' -fill '{alpha(text_color, .1)}' ",
       "-pointsize 100 -kerning 200 -font Poller-One ",
       "-annotate +1000+500 'PACIFIC OCEAN' ",
       "-rotate 180 -distort Arc '160 180' -background none +repage ",
       
       "-rotate -5 images/titled_pan_pop_car.png +swap ",
       "-gravity center -geometry -750+2000 ",
       "-composite images/titled_pan_pop_pac.png")
)


# Use this chunk below to create a smaller graphic.

# image_read("images/titled_pan_pop_pac.png") |> 
#   image_scale(geometry = "46%x") |> 
#   image_write("tracked_graphics/titled_pan_pop_small.png")