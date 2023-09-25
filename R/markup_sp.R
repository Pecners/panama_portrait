# SPANISH VERSION

# Need to have rendered the base visual
# with R/render_graphic.R before running
# this script.

# R/markup.R includes comments, see there for
# explanation of code.

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

t1 <- "Poller One"
t2 <- "Amarante"

annot <- "Las estimaciones de población se dividen en hexágonos de 400 metros."

cat(annot)


img |>
  image_crop(geometry = "9000x6750+0+0", gravity = "center") |> 
  image_annotate(text = "EL ISTMO DE PANAMÁ", 
                 gravity = "NORTH",
                 location = "-1500+600", font = t1,
                 color = text_color, kerning = 50,
                 size = 300, weight = 700) |> 
  image_annotate(text = "DENSIDAD DE POBLACIÓN",
                 gravity = "NORTH",
                 location = "-1500+1000", font = t2,
                 color = text_second, kerning = 75,
                 weight = 700,
                 size = 275) |>
  image_annotate(text = glue("Datos de población de Kontur (publicados el 30 de junio de 2022)"),
                 gravity = "NORTH",
                 location = "-1500+1350", font = t2,
                 color = colors[8],
                 kerning = 37,
                 size = 75) |>
  image_annotate(text = annot,
                 gravity = "north",
                 location = "-1500+1500", font = t2,
                 color = colors[8],
                 kerning = 31,
                 size = 75) |>
image_write("images/titled_pan_pop_sp.png")


system(
  glue("convert -size 9000x6750 xc:none ",
       # Shadows
       "-gravity southeast -font Amarante-Regular ",
       "-pointsize 60 -strokewidth 0 ",
       "-fill '{alpha(text_second, .4)}' ",
       
       "-annotate -19x-30+8030+3540 '82°O' ", 
       
       "-annotate -19x-30+5580+4330 '80°O' ",
       "-annotate -19x-30+3150+5150 '78°O' ",
       "-annotate -19x-30+1030+4850 \"9°30'N\" ",
       "-annotate -19x-30+7820+710 \"7°30'N\" ",
       
       "images/titled_pan_pop_sp.png +swap ",
       "-composite images/titled_pan_pop_deg_sp.png")
)



# Carribbean Sea
system(
  glue("convert -size 9000x6750 xc:none -gravity Center ",
       
       "-stroke '{alpha(text_color, .1)}' -fill '{alpha(text_color, .1)}' ",
       "-pointsize 100 -kerning 250 -font Poller-One ",
       "-annotate -1000+1000 'MAR CARIBE' ",
       "-distort Arc 90 -background none +repage ",
       
       "-rotate -15 images/titled_pan_pop_deg_sp.png +swap ",
       "-gravity center -geometry +400-1700 ",
       "-composite images/titled_pan_pop_car_sp.png")
)

# Pacific Ocean
system(
  glue("convert -size 9000x6750 xc:none -gravity Center ",
       
       "-stroke '{alpha(text_color, .1)}' -fill '{alpha(text_color, .1)}' ",
       "-pointsize 100 -kerning 200 -font Poller-One ",
       "-annotate +1000+500 'OCÉANO PACIFICO' ",
       "-rotate 180 -distort Arc '160 180' -background none +repage ",
       
       "-rotate -5 images/titled_pan_pop_car_sp.png +swap ",
       "-gravity center -geometry -750+2000 ",
       "-composite images/titled_pan_pop_pac_sp.png")
)



# image_read("images/georgia_country/titled_geo_pop_sp.png") |> 
#   image_scale(geometry = "46%x") |> 
#   image_write("tracked_graphics/titled_geo_pop_small_sp.png")