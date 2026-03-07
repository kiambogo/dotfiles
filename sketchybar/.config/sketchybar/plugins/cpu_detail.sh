#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Top 5 processes by CPU, with their mem in MB
MEM_TOTAL_MB=$(( $(sysctl -n hw.memsize) / 1048576 ))
TOP_PROCS=$(ps -Aceo pid,pcpu,rss,comm -r 2>/dev/null | awk -v total="$MEM_TOTAL_MB" 'NR>1 && $2+0 > 0 {
  name = $4
  sub(".*/", "", name)
  if (length(name) > 18) name = substr(name, 1, 18)
  mem_mb = int($3 / 1024)
  mem_pct = int(mem_mb * 100 / total)
  printf "%s|%.0f|%d|%d\n", name, $2, mem_mb, mem_pct
}' | head -5)

bar_str() {
  local pct=$1
  local filled=$(( pct * 8 / 100 ))
  local bar=""
  for ((i=0; i<8; i++)); do
    if [[ $i -lt $filled ]]; then bar="${bar}█"
    else bar="${bar}░"
    fi
  done
  echo "$bar"
}

cpu_color() {
  if   [[ $1 -ge 80 ]]; then echo $RED
  elif [[ $1 -ge 40 ]]; then echo $ORANGE
  else echo $GREEN
  fi
}

mem_color() {
  if   [[ $1 -ge 20 ]]; then echo $RED
  elif [[ $1 -ge 10 ]]; then echo $ORANGE
  else echo $BLUE
  fi
}

i=1
while IFS='|' read -r name cpu mem_mb mem_pct; do
  CPU_BAR=$(bar_str $cpu)
  MEM_BAR=$(bar_str $mem_pct)
  CPU_COLOR=$(cpu_color $cpu)
  MEM_COLOR=$(mem_color $mem_pct)

  PADDED=$(printf "%-18s" "$name")
  if [[ $mem_mb -ge 1024 ]]; then
    MEM_STR=$(echo "scale=1; $mem_mb / 1024" | bc)GB
  else
    MEM_STR="${mem_mb}MB"
  fi

  sketchybar --set cpu.proc$i \
    icon="$PADDED" \
    icon.color=$WHITE \
    label="${CPU_BAR} $(printf '%3d' $cpu)%  ${MEM_BAR} ${MEM_STR}" \
    label.color=$GREY
  ((i++))
done <<< "$TOP_PROCS"

while [[ $i -le 5 ]]; do
  sketchybar --set cpu.proc$i icon="–" label="" icon.color=$GREY
  ((i++))
done
