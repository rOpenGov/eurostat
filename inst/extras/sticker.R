# https://github.com/GuangchuangYu/hexSticker

library(hexSticker)
library(ggplot2)

p <- ggplot(aes(x = mpg, y = wt), data = mtcars) + geom_point()
p <- p + theme_void() + theme_transparent()
imgurl <- "plot.png"

sticker(imgurl, package="eurostat",
        p_size=8, s_x=1, s_y=.75, s_width=1.3, s_height=1,
        filename="eurostat.png")

