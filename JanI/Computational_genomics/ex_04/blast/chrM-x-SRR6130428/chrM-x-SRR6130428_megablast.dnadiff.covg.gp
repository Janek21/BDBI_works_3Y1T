set terminal postscript color solid "Courier" 8
set output "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR6130428/chrM-x-SRR6130428_megablast.dnadiff.covg.ps"
set size 3,1.5
set grid
unset key
set border 15
set tics scale 0
set xlabel "Scer_chrM"
set ylabel "%SIM"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
if(GPVAL_VERSION < 5) set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:85779]
set yrange [1:110]
set style line 1  lt 1 lw 4
set style line 2  lt 3 lw 4
set style line 3  lt 2 lw 4 pt 6 ps 0.5
plot \
 "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR6130428/chrM-x-SRR6130428_megablast.dnadiff.covg.fplot" title "FWD" w l ls 1, \
 "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR6130428/chrM-x-SRR6130428_megablast.dnadiff.covg.rplot" title "REV" w l ls 2
