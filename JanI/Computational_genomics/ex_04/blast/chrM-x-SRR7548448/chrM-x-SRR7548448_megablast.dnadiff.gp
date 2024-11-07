set terminal postscript color solid "Courier" 8
set output "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR7548448/chrM-x-SRR7548448_megablast.dnadiff.ps"
set ytics ( \
 "143321" 1, \
 "131217" 697, \
 "*116523" 1021, \
 "143947" 1227, \
 "*117899" 1993, \
 "*111853" 2205, \
 "*124847" 2394, \
 "*126533" 2650, \
 "117703" 2919, \
 "*140327" 3131, \
 "127993" 3655, \
 "*118637" 3939, \
 "*134869" 4155, \
 "*133191" 4534, \
 "*137781" 4885, \
 "*128849" 5325, \
 "124111" 5618, \
 "124441" 5868, \
 "129521" 6121, \
 "119599" 6422, \
 "*129753" 6643, \
 "*129205" 6946, \
 "117957" 7243, \
 "128469" 7456, \
 "115595" 7744, \
 "144459" 7947, \
 "" 8815 \
)
set size 3,3
set grid
unset key
set border 10
set tics scale 0
set xlabel "Scer_chrM"
set ylabel "QRY"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
if(GPVAL_VERSION < 5) set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:85779]
set yrange [1:8815]
set style line 1  lt 1 lw 2 pt 6 ps 0.5
set style line 2  lt 3 lw 2 pt 6 ps 0.5
set style line 3  lt 2 lw 2 pt 6 ps 0.5
plot \
 "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR7548448/chrM-x-SRR7548448_megablast.dnadiff.fplot" title "FWD" w lp ls 1, \
 "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR7548448/chrM-x-SRR7548448_megablast.dnadiff.rplot" title "REV" w lp ls 2
