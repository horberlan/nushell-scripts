def show_image [folder_path: string, images: list<string>, current: int] {
    kitty +kitten icat --transfer-mode file --clear --silent --no-trailing-newline $"($images | get $current)"
}

def rotate_image [folder_path: string, images: list<string>, current: int, angle: int] {
    let image_path = $"($images | get $current)"
    magick $image_path "-rotate" $angle $image_path
}

def next_image [current: number, total: number] {
    if $current < $total - 1 { $current + 1 } else { 0 }
}

def prev_image [current: number, total: number] {
    if $current > 0 { $current - 1 } else { $total - 1 }
}

# directory-type argument or file
def main [args] {
    if ($args | length) == 1 {
        let folder_path = (
            if ($args | path type) == "dir" {
                $args
            } else {
                $args | path dirname
            }
        )
        let images = ls -m $folder_path | where type =~ "image" | get name         
        let total = ($images | length)
        mut current = 0
        
        loop {
            show_image $folder_path $images $current
            
            print $"\r($current)/($total - 1)"
            
            let key = (input listen --types [key])
            match $key.code {
                "up" => { rotate_image $folder_path $images $current 90 }
                "down" => { rotate_image $folder_path $images $current -90 }
                "right" => { $current = (next_image $current $total) }
                "left" => { $current = (prev_image $current $total) }
                "q" => { break }
                _ => { print "Key not mapped." }
            }
        }
    }
}
