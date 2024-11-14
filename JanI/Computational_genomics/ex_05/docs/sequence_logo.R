
library(ggplot2)
library(ggseqlogo)
library(gridExtra)

path<-Sys.getenv("WDR")

args = commandArgs(trailingOnly=TRUE)

print(length(args))

if (length(args)<1) {
  stop("MISSING FILE NAME.n", call.=FALSE)
}

seqFile<-args[1]

#name of the sequencs
seqName<-result <- sub("\\.tbl$", "", basename(seqFile))

# loading sequence sets
set_seq <- readLines(seqFile)

# making a sequence logo
p1 <- ggplot() + theme_logo() +
  annotate('rect', xmin = 0.5, xmax = 3.5, ymin = -0.05, ymax = Inf,
           alpha = .1, col='#0000FF', fill='#0000FF55') +
  geom_logo( set_seq, method = 'bits' ) +
  ggtitle(paste0(seqName, " (sequence logo)"))

ggsave(file=paste0(path, "/images/", seqName,"_seqLogos.png"), #Changed the path
       p1, height=6, width=9, units="in", dpi=600)

