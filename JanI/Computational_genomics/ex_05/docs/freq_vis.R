require(ggplot2);
require(ggseqlogo);
require(gridExtra);

path<-Sys.getenv("WDR")

# loading the sequence set
donors.setALL <- readLines(paste0(path, "/seqs/donor_ex05/refgenome_alldonorsites_sequences.tbl")); #Changed the path

# making a sequence logo
p1 <- ggplot() + theme_logo() +
        annotate('rect', xmin = 0.5, xmax = 3.5, ymin = -0.05, ymax = Inf,
	         alpha = .1, col='#0000FF', fill='#0000FF55') +
        geom_logo( donors.setALL, method = 'bits' ) +
        ggtitle("S.cerevisiae 361 donor sites (sequence logo)");

# drawing a pictogram
p2 <- ggplot() + theme_logo() +
        annotate('rect', xmin = 0.5, xmax = 3.5, ymin = -0.05, ymax = Inf,
	         alpha = .1, col='#0000FF', fill='#0000FF55') +
        geom_logo( donors.setALL, method = 'prob' ) +
        ggtitle("S.cerevisiae 361 donor sites (pictogram)");

# to view on the side panel
#gridExtra::grid.arrange(p1, p2); #Commented so it doesn't generate a pdf

# saving the picture
P <- gridExtra::arrangeGrob(p1, p2);
ggsave(file=paste0(path, "/images/alldonors_logo+pictogram.png"), #Changed the path
       P, height=6, width=9, units="in", dpi=600)
