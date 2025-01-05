# A module to change youtube-music tracks
def track [do: string] {
    if (is_ytm_running) {
        let command = match $do {
            "next" => "track-next",
            "previous" => "track-previous",
            "pause" => "track-pause",
            "play" => "track-play",
            _ => {
                print "Command not found"
                return
            }
        }
        if $command != null {
            http post http://localhost:9863/query -H ["Authorization" $"Bearer ($env.youtube-key)"] --content-type "application/json"   { "command": $"track-($do)" }
            mut_cover
        }
    } else  {
        print "yt not running"
    }
}

# check ytm is running, if not, open this shit
def is_ytm_running [] {
    let count = (ps | where name =~ "youtube-music-d" | length)
 
    if $count <= 0 {
        ^youtube-music-desktop-app &
        sleep 1000ms
        let new_count = (ps | where name =~ "youtube-music-d" | length)
        $new_count > 0
    } else {
        true
    }
}

# get current track json object
def get_current_track [] {
  if (is_ytm_running) {
    http get http://localhost:9863/query/track -H ["Authorization" $"Bearer ($env.youtube-key)"]
  }
}
# get cover track img
def show_current_track_img [] {
  if (is_ytm_running) {
    let track = get_current_track
    kitty +kitten icat --use-window-size 10,10,100,100 $track.cover
  } else print "image not found, check is_ytm_running function"
}

def mut_cover [] {
    let data_img = show_current_track_img
    mut data = get_current_track
    $data.cover = $data_img
    [
        $data.cover,
        $data.author,
        $data.title,
        $data.album,
        $data.durationHuman,
    ]
}