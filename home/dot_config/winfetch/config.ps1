# ===== WINFETCH CONFIGURATION =====
$noimage = $false

# Specify width for image/logo
$imgwidth = 32

# Configure how to show info for levels
# Default is for text only.
# 'bar' is for bar only.
# 'textbar' is for text + bar.
# 'bartext' is for bar + text.
# $cpustyle = 'bar'
$memorystyle = 'text'
$diskstyle = 'text'
$batterystyle = 'text'


# Remove the '#' from any of the lines in
# the following to **enable** their output.

@(
  "title"
  "dashes"
  "os"
  "computer"
  "kernel"
  "motherboard"
  "uptime"
  # "ps_pkgs"  # takes some time
  # "pkgs"
  "pwsh"
  "resolution"
  "terminal"
  # "theme"
  "cpu"
  "gpu"
  "cpu_usage"  # takes some time
  "memory"
  "disk"
  "battery"
  # "locale"
  # "weather"
  # "local_ip"
  # "public_ip"
  "blank"
  "colorbar"
)
