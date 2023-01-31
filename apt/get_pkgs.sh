apt list --installed 2>/dev/null | grep '\[installed\]' | awk -F'/' '{print $1}'
